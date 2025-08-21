import mongoose from 'mongoose';

const { Schema, model } = mongoose;

const UserSchema = new Schema({
  name: { type: String, required: true, trim: true },
  email: { type: String, required: true, unique: true, lowercase: true, trim: true },
  passwordHash: { type: String, required: true },
  role: { type: String, enum: ['user', 'staff', 'admin'], default: 'user', index: true },
  active: { type: Boolean, default: true },
}, { timestamps: true });

UserSchema.methods.toSafeJSON = function () {
  return { _id: this._id, name: this.name, email: this.email, role: this.role, active: this.active };
};

export default model('User', UserSchema);
