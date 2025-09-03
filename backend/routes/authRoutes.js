import {Router}  from 'express';
import * as authController from '../controllers/authController.js';
import { auth } from '../middleware/auth.js';
import resendOtpLimiter from '../middleware/otpLimiter.js';


const router = Router();
router.post('/register', authController.signUp);
router.patch('/register/verify-verification-code', authController.verifyVerificationCode);
router.post('/register/resend-verification-code', resendOtpLimiter,authController.resendVerificationCode);

router.post('/login', authController.logIn);
router.post('/logout', auth,authController.logOut);


router.patch('/change-password', auth, authController.changePassword);
router.patch('/reset-password/send-forgetPassword-code',resendOtpLimiter, authController.sendForgetPasswordCode);
router.patch('/reset-password/verify-forgetPassword-code', authController.verifyForgetPasswordCode);



export default router;