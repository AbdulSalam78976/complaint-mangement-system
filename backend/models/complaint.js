import mongoose from 'mongoose';

const { Schema, model, Types } = mongoose;

// Optional comment schema for future use
const CommentSchema = new Schema({
  author: { type: Types.ObjectId, ref: 'User', required: true },
  body: { type: String, required: true, trim: true },
  visibility: { type: String, enum: ['public', 'internal'], default: 'public' },
  isAdmin: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now },
}, { _id: false });

const ComplaintSchema = new Schema({
  title: { type: String, required: true, trim: true },
  description: { type: String, required: true, trim: true },

  category: { 
    type: String, 
    enum: ['IT Department', 'HR Department', 'Finance', 'Facilities', 'Security', 'Other'], 
    default: 'Other',
    index: true
  },

  priority: { 
    type: String, 
    enum: ['Low', 'Medium', 'High'], 
    default: 'Medium' 
  },

  status: { 
    type: String, 
    enum: ['open','pending', 'in_progress', 'resolved', 'closed'], 
    default: 'open', 
    index: true 
  },

  phone: { type: String, required: true, trim: true },
  email: { type: String, required: true, trim: true },

  createdBy: { type: Types.ObjectId, ref: 'User', required: true, index: true }, // end user
  resolvedBy: { type: Types.ObjectId, ref: 'User', default: null }, // admin who resolved
  lastUpdatedBy: { type: Types.ObjectId, ref: 'User', default: null }, // track last actor

  comments: [CommentSchema],

  attachments: [{ type: String }], // store file URLs/paths

}, { timestamps: true });

export default model('Complaint', ComplaintSchema);
