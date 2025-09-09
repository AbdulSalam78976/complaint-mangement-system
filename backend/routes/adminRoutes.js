import { Router } from 'express';
import { auth, permit } from '../middleware/auth.js';
import getAllUsers from '../controllers/adminControllers.js';

const router = Router();

// Only admins can fetch all users
router.get('/users', auth, permit('admin'), getAllUsers);

export default router;
