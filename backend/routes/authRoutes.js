import { Router } from 'express';
import * as authController from '../controllers/authController.js';
import { auth } from '../middleware/auth.js';
import resendOtpLimiter from '../middleware/otpLimiter.js';

const router = Router();

// Registration & Email Verification
router.post('/register', authController.signUp);
router.get('/register/verify-email', authController.verifyEmail);


// Auth
router.post('/login', authController.logIn);
router.post('/logout', auth, authController.logOut);

// Password Management
router.post('/password/reset/send-code', resendOtpLimiter, authController.sendResetPasswordCode);
router.post('/password/reset/verify-code', authController.verifyResetPasswordCode);

export default router;
