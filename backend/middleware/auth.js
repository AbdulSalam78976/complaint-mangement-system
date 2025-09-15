import jwt from 'jsonwebtoken';
import createError from 'http-errors';
import User from '../models/user.js';
const auth = async (req, res, next) => {
  try {
    // 1. Check if Authorization header exists
    const authHeader = req.get('Authorization');
    if (!authHeader) throw createError(401, 'Unauthorized');

    // 2. Split header into type and token (e.g., "Bearer eyJhbGciOi...")
    const [type, token] = authHeader.split(' ');
    if (type !== 'Bearer' || !token) throw createError(401, 'Unauthorized');
    console.log('verifing token', token);
    // 3. Verify the JWT token using the secret key
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // 4. Fetch complete user data from database (excluding password)
    const user = await User.findById(decoded.userId).select('-password');
    if (!user) throw createError(403, 'Forbidden');

    // 5. Attach user object to request for use in subsequent middleware/routes
    req.user = user;
    
    // 6. Proceed to next middleware/route
    next();
  } catch (error) {
    next(error);
  }
};

const permit = (...roles) => {
  return (req, res, next) => {
    try {
      // 1. Check if user is authenticated
      if (!req.user) throw createError(401, 'Unauthorized');
      
      // 2. Check if user's role is in the allowed roles list
      if (!roles.includes(req.user.role)) throw createError(403, 'Forbidden');
      
      // 3. Allow access if role is permitted
      next();
    } catch (error) {
      next(error);
    }
  };
};

export { auth, permit };
