import mongoose from 'mongoose';
import Complaint from '../models/complaint.js';
import User from '../models/user.js';

export const createComplaint = async (req, res) => {
  try {
    const { title, description, category = 'other', priority = 'medium' } = req.body;
    if (!title || !description) return res.status(400).json({ error: 'title, description required' });

    const complaint = await Complaint.create({
      title, description, category, priority, createdBy: req.user.sub,
    });
    res.status(201).json({ complaint });
  } catch (e) {
    res.status(500).json({ error: 'Could not create complaint' });
  }
};

export const listComplaints = async (req, res) => {
  try {
    const { status, category, priority, q, page = 1, limit = 10 } = req.query;
    const skip = (Number(page) - 1) * Number(limit);
    const filter = {};
    if (status) filter.status = status;
    if (category) filter.category = category;
    if (priority) filter.priority = priority;

    if (req.user.role === 'user') filter.createdBy = req.user.sub;
    else if (req.user.role === 'staff') filter.$or = [{ assignedTo: req.user.sub }, { assignedTo: null }];

    if (q) filter.$or = [{ title: { $regex: q, $options: 'i' } }, { description: { $regex: q, $options: 'i' } }];

    const [items, total] = await Promise.all([
      Complaint.find(filter)
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(Number(limit))
        .populate('createdBy', 'name email role')
        .populate('assignedTo', 'name email role'),
      Complaint.countDocuments(filter),
    ]);

    res.json({ items, total, page: Number(page), pages: Math.ceil(total / Number(limit)) });
  } catch (e) {
    res.status(500).json({ error: 'Failed to list complaints' });
  }
};

export const getComplaint = async (req, res) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) return res.status(400).json({ error: 'Invalid ID' });

    const doc = await Complaint.findById(id)
      .populate('createdBy', 'name email role')
      .populate('assignedTo', 'name email role')
      .populate('comments.author', 'name email role');

    if (!doc) return res.status(404).json({ error: 'Not found' });
    if (req.user.role === 'user' && String(doc.createdBy._id) !== req.user.sub) return res.status(403).json({ error: 'Forbidden' });
    res.json({ complaint: doc });
  } catch (e) {
    res.status(500).json({ error: 'Failed to fetch complaint' });
  }
};

export const updateComplaint = async (req, res) => {
  try {
    const { id } = req.params;
    if (!mongoose.Types.ObjectId.isValid(id)) return res.status(400).json({ error: 'Invalid ID' });

    const doc = await Complaint.findById(id);
    if (!doc) return res.status(404).json({ error: 'Not found' });

    const isOwner = String(doc.createdBy) === req.user.sub;
    const isStaffOrAdmin = ['staff', 'admin'].includes(req.user.role);

    const { title, description, status, assignedTo, priority, category } = req.body;

    if (title !== undefined || description !== undefined || category !== undefined || priority !== undefined) {
      if (!isOwner && !isStaffOrAdmin) return res.status(403).json({ error: 'Forbidden' });
      if (title !== undefined) doc.title = String(title).trim() || doc.title;
      if (description !== undefined) doc.description = String(description);
      if (category !== undefined) doc.category = category;
      if (priority !== undefined) doc.priority = priority;
    }

    if (status !== undefined) {
      if (!isStaffOrAdmin) return res.status(403).json({ error: 'Only staff/admin can change status' });
      doc.status = status;
    }

    if (assignedTo !== undefined) {
      if (!isStaffOrAdmin) return res.status(403).json({ error: 'Only staff/admin can reassign' });
      if (assignedTo === null) doc.assignedTo = null;
      else if (mongoose.Types.ObjectId.isValid(assignedTo)) {
        const assignee = await User.findById(assignedTo);
        if (!assignee || !['staff', 'admin'].includes(assignee.role)) return res.status(400).json({ error: 'Assigned user must be staff/admin' });
        doc.assignedTo = assignee._id;
      } else return res.status(400).json({ error: 'Invalid assignedTo value' });
    }

    await doc.save();

    const populated = await Complaint.findById(doc._id)
      .populate('createdBy', 'name email role')
      .populate('assignedTo', 'name email role');

    res.json({ complaint: populated });
  } catch (e) {
    res.status(500).json({ error: 'Update failed' });
  }
};

export const addComment = async (req, res) => {
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
    res.status(500).json({ error: 'Could not add comment' });
  }
};

export const statsSummary = async (req, res) => {
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
    res.status(500).json({ error: 'Failed to compute stats' });
  }
};