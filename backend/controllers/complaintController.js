import mongoose from 'mongoose';
import Complaint from '../models/complaint.js';
import User from '../models/user.js';
import * as Validator from '../middleware/ComplaintValidator.js';

// ---------------- Create Complaint ----------------
const createComplaint = async (req, res) => {
  try {

    // Validate request body using Joi
    const { error, value } = Validator.createComplaintValidator.validate(req.body, { abortEarly: false });
    if (error) {
      const errors = error.details.map((detail) => detail.message);
      return res.status(400).json({ errors });
    }

    const { title, description, category, priority, phone, email } = value;

    
    // Handle multiple attachments
    const attachments = req.files ? req.files.map(file => file.path) : [];
    
    console.log('Uploaded files:', req.files); // Debug: see uploaded files

    // Create the complaint
    const complaint = await Complaint.create({
      title,
      description,
      category,
      priority,
      phone,
      email,
      attachments,
      createdBy: req.user._id, // user ID from auth middleware
    });

    res.status(201).json({ complaint });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Could not create complaint' });
  }
};



// ---------------- List Complaints ----------------
const listComplaints = async (req, res) => {
  try {
    let filter = {};

    if (req.user.role === 'user') {
      filter = { createdBy: req.user._id };
    } else if (req.user.role === 'staff') {
      filter = { $or: [{ assignedTo: req.user.sub }, { assignedTo: null }] };
    } else if (req.user.role === 'admin') {
      filter = {}; // no restrictions
    }

    const items = await Complaint.find(filter)
      .sort({ createdAt: -1 })
      .populate('createdBy', 'name email role');
      

    res.json({ items });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Failed to list complaints' });
  }
};

// ---------------- Get Single Complaint ----------------
const getComplaint = async (req, res) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) return res.status(400).json({ error: 'Invalid ID' });

    const doc = await Complaint.findById(id)
      .populate('createdBy', 'name email role')
      .populate('assignedTo', 'name email role')
      .populate('comments.author', 'name email role');

    if (!doc) return res.status(404).json({ error: 'Not found' });
    if (req.user.role === 'user' && String(doc.createdBy._id) !== req.user.sub)
      return res.status(403).json({ error: 'Forbidden' });

    res.json({ complaint: doc });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Failed to fetch complaint' });
  }
};

// ---------------- Update Complaint ----------------
const updateComplaint = async (req, res) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) return res.status(400).json({ error: 'Invalid ID' });

    const doc = await Complaint.findById(id);
    if (!doc) return res.status(404).json({ error: 'Not found' });

    const isOwner = String(doc.createdBy) === req.user.sub;
    const isStaffOrAdmin = ['staff', 'admin'].includes(req.user.role);

    const { title, description, status, assignedTo, priority, category, phone, email, attachments } = req.body;

    // Owner/staff can update basic fields
    if (title !== undefined || description !== undefined || category !== undefined || priority !== undefined || phone !== undefined || email !== undefined || attachments !== undefined) {
      if (!isOwner && !isStaffOrAdmin) return res.status(403).json({ error: 'Forbidden' });

      if (title !== undefined) doc.title = String(title).trim() || doc.title;
      if (description !== undefined) doc.description = String(description);
      if (category !== undefined) doc.category = category;
      if (priority !== undefined) doc.priority = priority;
      if (phone !== undefined) doc.phone = phone;
      if (email !== undefined) doc.email = email;
      if (attachments !== undefined) doc.attachments = attachments;
    }

    // Only staff/admin can update status
    if (status !== undefined) {
      if (!isStaffOrAdmin) return res.status(403).json({ error: 'Only staff/admin can change status' });
      doc.status = status;
    }

    // Only staff/admin can assign
    if (assignedTo !== undefined) {
      if (!isStaffOrAdmin) return res.status(403).json({ error: 'Only staff/admin can reassign' });
      if (assignedTo === null) doc.assignedTo = null;
      else if (mongoose.Types.ObjectId.isValid(assignedTo)) {
        const assignee = await User.findById(assignedTo);
        if (!assignee || !['staff', 'admin'].includes(assignee.role))
          return res.status(400).json({ error: 'Assigned user must be staff/admin' });
        doc.assignedTo = assignee._id;
      } else return res.status(400).json({ error: 'Invalid assignedTo value' });
    }

    await doc.save();

    const populated = await Complaint.findById(doc._id)
      .populate('createdBy', 'name email role')
      .populate('assignedTo', 'name email role');

    res.json({ complaint: populated });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Update failed' });
  }
};

// ---------------- Add Comment ----------------
const addComment = async (req, res) => {
  try {
    const { id } = req.params;
    const { body, visibility = 'public' } = req.body;
    if (!body) return res.status(400).json({ error: 'body required' });

    if (!mongoose.Types.ObjectId.isValid(id)) return res.status(400).json({ error: 'Invalid ID' });

    const doc = await Complaint.findById(id);
    if (!doc) return res.status(404).json({ error: 'Not found' });

    const isOwner = String(doc.createdBy) === req.user.sub;
    const isStaffOrAdmin = ['staff', 'admin'].includes(req.user.role);
    if (!isOwner && !isStaffOrAdmin) return res.status(403).json({ error: 'Forbidden' });

    const finalVisibility = isStaffOrAdmin ? visibility : 'public';

    doc.comments.push({ author: req.user.sub, body, visibility: finalVisibility });
    await doc.save();

    const populated = await Complaint.findById(doc._id).populate('comments.author', 'name email role');
    res.status(201).json({ comments: populated.comments });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Could not add comment' });
  }
};

// ---------------- Stats Summary ----------------
const statsSummary = async (req, res) => {
  try {
    const grouped = await Complaint.aggregate([
      { $group: { _id: { status: '$status', category: '$category' }, count: { $sum: 1 } } },
      { $sort: { '_id.status': 1, '_id.category': 1 } },
    ]);
    const totals = await Complaint.aggregate([
      { $group: { _id: '$status', count: { $sum: 1 } } },
      { $sort: { _id: 1 } },
    ]);
    res.json({ grouped, totals });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Failed to compute stats' });
  }
};

export {
  createComplaint,
  statsSummary,
  addComment,
  updateComplaint,
  getComplaint,
  listComplaints,
};
