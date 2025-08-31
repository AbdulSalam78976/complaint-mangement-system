import { router } from 'express';
import { signUp, logIn, logOut, verifyVerificationCode, resendVerificationCode, changePassword, sendForgetPasswordCode, verifyForgetPasswordCode } from '../controllers/authController.js';
import { auth } from '../middleware/auth.js';
import { resendOtpLimiter } from '../middleware/otpLimiter.js';

router.post('/register',signUp);
router.patch('/register/verify-verification-code', verifyVerificationCode);
router.post('/register/resend-verification-code', resendOtpLimiter,resendVerificationCode);

router.post('/login', logIn);
router.post('/logout', auth,logOut);


router.patch('/change-password', authenticateUser, changePassword);
router.patch('/reset-password/send-forgetPassword-code',resendOtpLimiter, sendForgetPasswordCode);
router.patch('/reset-password/verify-forgetPassword-code', verifyForgetPasswordCode);