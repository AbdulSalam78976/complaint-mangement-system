import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import User from '../models/user.js';

const signToken = (user) => jwt.sign({ sub: user._id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '7d' });

export const register = async (req, res) => {
  try {
    const { name, email, password, role } = req.body;
    if (!name || !email || !password) return res.status(400).json({ error: 'name, email, password required' });

    const existing = await User.findOne({ email });
    if (existing) return res.status(409).json({ error: 'Email already in use' });

    const passwordHash = await bcrypt.hash(password, 10);

    let assignedRole = 'user';
    const userCount = await User.countDocuments();
    if (userCount === 0) assignedRole = 'admin';
    else if (['staff', 'admin'].includes(role)) assignedRole = 'user';

    const user = await User.create({ name, email, passwordHash, role: assignedRole });
    const token = signToken(user);
    return res.status(201).json({ token, user: user.toSafeJSON() });
  } catch (e) {
    res.status(500).json({ error: 'Registration failed' });
  }
};

export const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: 'email, password required' });

    const user = await User.findOne({ email });
    if (!user) return res.status(401).json({ error: 'Invalid credentials' });

    const ok = await bcrypt.compare(password, user.passwordHash);
    if (!ok) return res.status(401).json({ error: 'Invalid credentials' });

    if (!user.active) return res.status(403).json({ error: 'Account disabled' });

    const token = signToken(user);
    res.json({ token, user: user.toSafeJSON() });
  } catch (e) {
    res.status(500).json({ error: 'Login failed' });
  }
};

export const me = async (req, res) => {
  const user = await User.findById(req.user.sub);
  res.json({ user: user ? user.toSafeJSON() : null });
};