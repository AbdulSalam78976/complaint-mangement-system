import mongoose from 'mongoose';

const { Schema, model, Types } = mongoose;

const CommentSchema = new Schema({
  author: { type: Types.ObjectId, ref: 'User', required: true },
  body: { type: String, required: true, trim: true },
  visibility: { type: String, enum: ['public', 'internal'], default: 'public' },
  isAdmin: { type: Boolean, default: false }, // ✅ helps identify admin comments
  createdAt: { type: Date, default: Date.now },
}, { _id: false });

const ComplaintSchema = new Schema({
  title: { type: String, required: true, trim: true },
  description: { type: String, required: true, trim: true },

  category: { 
    type: String, 
    enum: ['it', 'hr', 'finance', 'facilities', 'other'], 
    default: 'other', 
    index: true 
  },

  priority: { 
    type: String, 
    enum: ['low', 'medium', 'high', 'urgent'], 
    default: 'medium' 
  },

  status: { 
    type: String, 
    enum: ['open', 'in_progress', 'resolved', 'closed'], 
    default: 'open', 
    index: true 
  },

  createdBy: { type: Types.ObjectId, ref: 'User', required: true, index: true }, // end user
  resolvedBy: { type: Types.ObjectId, ref: 'User', default: null }, // ✅ admin who resolved
  lastUpdatedBy: { type: Types.ObjectId, ref: 'User', default: null }, // ✅ track last actor

  comments: [CommentSchema],

  attachments: [{ type: String }], // ✅ store file URLs/paths
  tags: [{ type: String, trim: true }], // ✅ for searching/filtering
}, 
{ timestamps: true });

export default model('Complaint', ComplaintSchema);
