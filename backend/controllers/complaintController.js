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
// ---------------- List Complaints ----------------
const listComplaints = async (req, res) => {
  try {
    let filter = {};

    if (req.user.role === 'user') {
      filter = { createdBy: req.user._id };
    }
    // Remove the staff filter that uses assignedTo
    // else if (req.user.role === 'staff') {
    //   filter = { $or: [{ assignedTo: req.user.sub }, { assignedTo: null }] };
    // }
    else if (req.user.role === 'admin') {
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

// ---------------- Get Single Complaint ----------------// ---------------- Get Single Complaint ----------------
// ---------------- Get Single Complaint ----------------
const getComplaint = async (req, res) => {
  try {
    console.log(req.params);
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) return res.status(400).json({ error: 'Invalid ID' });

    const doc = await Complaint.findById(id)
      .populate('createdBy', 'name email role')
      .populate('comments.author', 'name email role'); // Removed .populate('assignedTo')

    if (!doc) return res.status(404).json({ error: 'Not found' });
    
    // Fix: Use String() conversion for proper comparison
    if (req.user.role === 'user' && String(doc.createdBy._id) !== String(req.user._id))
      return res.status(403).json({ error: 'Forbidden' });

    res.json({ complaint: doc });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Failed to fetch complaint' });
  }
};

// ---------------- Update Complaint ----------------
// ---------------- Update Complaint ----------------
const updateComplaint = async (req, res) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) return res.status(400).json({ error: 'Invalid ID' });

    const doc = await Complaint.findById(id);
    if (!doc) return res.status(404).json({ error: 'Not found' });

    const isOwner = String(doc.createdBy) === req.user.sub;
    const isStaffOrAdmin = ['staff', 'admin'].includes(req.user.role);

    const { title, description, status, priority, category, phone, email, attachments } = req.body;

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

    await doc.save();

    const populated = await Complaint.findById(doc._id)
      .populate('createdBy', 'name email role');

    res.json({ complaint: populated });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'Update failed' });
  }
};

// ---------------- Add Comment --------------
const addComment = async (req, res) => {
  try {
    const { id } = req.params;
    const { body, visibility = 'public' } = req.body;
    
    // Validation
    if (!body || body.trim().length === 0) {
      return res.status(400).json({ error: 'Comment body is required' });
    }

    if (body.trim().length > 1000) {
      return res.status(400).json({ error: 'Comment too long (max 1000 characters)' });
    }

    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ error: 'Invalid complaint ID' });
    }

    const complaint = await Complaint.findById(id);
    if (!complaint) {
      return res.status(404).json({ error: 'Complaint not found' });
    }

    // Permission check
    const isOwner = String(complaint.createdBy) === String(req.user._id);
    const isStaffOrAdmin = ['staff', 'admin'].includes(req.user.role);
    
    if (!isOwner && !isStaffOrAdmin) {
      return res.status(403).json({ error: 'You do not have permission to comment on this complaint' });
    }

    // Staff/admin can set visibility, users can only post public comments
    const finalVisibility = isStaffOrAdmin ? visibility : 'public';

    // Add comment
    complaint.comments.push({ 
      author: req.user._id, 
      body: body.trim(), 
      visibility: finalVisibility,
      admin: isStaffOrAdmin
    });
    
    await complaint.save();

    // Return populated comments
    const populatedComplaint = await Complaint.findById(complaint._id)
      .populate('comments.author', 'name email role');
    
    res.status(201).json({ 
      message: 'Comment added successfully',
      comments: populatedComplaint.comments 
    });
  } catch (error) {
    console.error('Add comment error:', error);
    res.status(500).json({ error: 'Could not add comment' });
  }
};

const getComments = async (req, res) => {
  try {
    const { id } = req.params;
    
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ error: 'Invalid complaint ID' });
    }

    const complaint = await Complaint.findById(id)
      .populate('comments.author', 'name email role')
      .select('comments'); // Only return comments field

    if (!complaint) {
      return res.status(404).json({ error: 'Complaint not found' });
    }

    // Check permissions
    const isOwner = String(complaint.createdBy) === String(req.user._id);
    const isStaffOrAdmin = ['staff', 'admin'].includes(req.user.role);
    
    if (!isOwner && !isStaffOrAdmin) {
      return res.status(403).json({ error: 'Access denied' });
    }

    // Filter comments based on visibility and user role
    let visibleComments = complaint.comments;
    
    if (!isStaffOrAdmin) {
      // Regular users can only see public comments
      visibleComments = complaint.comments.filter(
        comment => comment.visibility === 'public'
      );
    }

    res.status(200).json({ comments: visibleComments });
  } catch (error) {
    console.error('Get comments error:', error);
    res.status(500).json({ error: 'Could not fetch comments' });
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
  getComments,
  updateComplaint,
  getComplaint,
  listComplaints,
};
