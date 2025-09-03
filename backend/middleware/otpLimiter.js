import rateLimit from 'express-rate-limit';
const resendOtpLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 5, // limit each IP to 5 requests per hour
  message: { error: 'Too many resend attempts from this IP, try again later.' }
});


export default resendOtpLimiter;
