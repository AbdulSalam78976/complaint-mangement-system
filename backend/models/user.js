import mongoose from 'mongoose';

const { Schema, model } = mongoose;

const UserSchema = new Schema({
  name: { type: String, required: true, trim: true },
  email: { 
    type: String, 
    required: true, 
    unique: true, 
    lowercase: true, 
    trim: true 
  },
  password: { type: String, required: true },
  
  role: { 
    type: String, 
    enum: ['user', 'admin'], 
    default: 'user', 
    index: true 
  },
  active: { type: Boolean, default: false },

  // ✅ Email verification (via link)
  verified: { type: Boolean, default: false },
  verificationToken: { type: String, index: true }, // random token / JWT
  verificationExpires: { type: Date }, // expiry time for token

  // ✅ Forgot password (via reset link)
  resetPasswordToken: { type: String, index: true },
  resetPasswordExpires: { type: Date },
  
}, { timestamps: true });

UserSchema.methods.toSafeJSON = function () {
  return { 
    _id: this._id, 
    name: this.name, 
    email: this.email, 
    role: this.role, 
    active: this.active, 
    verified: this.verified 
  };
};

export default model('User', UserSchema);
