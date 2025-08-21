import mongoose from 'mongoose';

const { Schema, model, Types } = mongoose;

const CommentSchema = new Schema({
  author: { type: Types.ObjectId, ref: 'User', required: true },
  body: { type: String, required: true },
  visibility: { type: String, enum: ['public', 'internal'], default: 'public' },
  createdAt: { type: Date, default: Date.now },
}, { _id: false });

const ComplaintSchema = new Schema({
  title: { type: String, required: true, trim: true },
  description: { type: String, required: true },
  category: { type: String, enum: ['it', 'hr', 'finance', 'facilities', 'other'], default: 'other', index: true },
  priority: { type: String, enum: ['low', 'medium', 'high', 'urgent'], default: 'medium' },
  status: { type: String, enum: ['open', 'in_progress', 'resolved', 'closed'], default: 'open', index: true },
  createdBy: { type: Types.ObjectId, ref: 'User', required: true, index: true },
  assignedTo: { type: Types.ObjectId, ref: 'User', default: null, index: true },
  comments: [CommentSchema],
}, { timestamps: true });

export default model('Complaint', ComplaintSchema);