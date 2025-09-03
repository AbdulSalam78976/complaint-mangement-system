import jwt from 'jsonwebtoken';
// Authentication middleware
const auth = (required = true) => async (req, res, next) => {
  const hdr = req.headers.authorization || '';
  const token = hdr.startsWith('Bearer ') ? hdr.slice(7) : null;

  if (!token) {
    if (required) return res.status(401).json({ message: 'Missing token' });
    req.user = null;
  
  }
  

  try {
    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Option A: Just attach decoded token
    // req.user = decoded;

    // Option B (safer): Fetch fresh user from DB
    const user = await User.findById(decoded.id).select('-passwordHash');
    if (!user) return res.status(401).json({ message: 'User not found' });

    req.user = user;
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
};

// Role-based access control
const permit = (...roles) => (req, res, next) => {
  if (!req.user) return res.status(401).json({ message: 'Unauthorized' });
  if (!roles.includes(req.user.role)) {
    return res.status(403).json({ message: 'Forbidden' });
  }
  next();
};

export { auth, permit };
