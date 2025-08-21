import { Router } from 'express';
import { auth, permit } from '../middleware/auth.js';
import mongoose from 'mongoose';
import User from '../models/user.js';

const router = Router();

router.patch('/users/:id/role', auth(), permit('admin'), async (req, res) => {
  const { id } = req.params; const { role } = req.body;
  if (!mongoose.Types.ObjectId.isValid(id)) return res.status(400).json({ error: 'Invalid ID' });
  if (!['user', 'staff', 'admin'].includes(role)) return res.status(400).json({ error: 'Invalid role' });
  const updated = await User.findByIdAndUpdate(id, { role }, { new: true });
  if (!updated) return res.status(404).json({ error: 'User not found' });
  res.json({ user: updated.toSafeJSON() });
});

router.patch('/users/:id/toggle', auth(), permit('admin'), async (req, res) => {
  const { id } = req.params;
  if (!mongoose.Types.ObjectId.isValid(id)) return res.status(400).json({ error: 'Invalid ID' });
  const user = await User.findById(id);
  if (!user) return res.status(404).json({ error: 'User not found' });
  user.active = !user.active; await user.save();
  res.json({ user: user.toSafeJSON() });
});

export default router;