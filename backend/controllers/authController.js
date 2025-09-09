import User from "../models/user.js";
import hash from "../utils/hashing.js";
import jwt from "jsonwebtoken";
import crypto from "crypto";
import sendMail from "../middleware/sendmail.js";
import { 
  UserLoginSchema, 
  UserRegistrationSchema 
} from "../middleware/AuthValidator.js";

/**
 * User Registration
 */
const signUp = async (req, res) => {
  try {
    // 1. Validate
    const { error } = UserRegistrationSchema.validate(req.body);
    if (error) return res.status(400).json({ success: false, message: error.details[0].message });

    // 2. Check existing
    if (await User.findOne({ email: req.body.email })) {
      return res.status(409).json({ success: false, message: "Email already registered" });
    }

    // 3. Hash password
    const hashedPassword = await hash.hashData(req.body.password);

    // 4. Create user
    const verificationToken = crypto.randomBytes(32).toString("hex");
    const user = new User({
      ...req.body,
      password: hashedPassword,
      verified: false,
      active: false,
      verificationToken,
      verificationExpires: new Date(Date.now() + 24 * 60 * 60 * 1000),
    });

    await user.save();

    // 5. Send verification email
    const verifyUrl = `${process.env.CLIENT_URL}/auth/register/verify-email?token=${verificationToken}&id=${user._id}`;
    await sendMail(
        user.email,
        "Verify Your Account",
        `Click to verify: ${verifyUrl}`,
        `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #eee; border-radius: 10px;">
          <h2 style="color: #333; text-align: center;">Welcome to Our App 🎉</h2>
          <p style="font-size: 16px; color: #555;">
            Hello <strong>${user.name}</strong>,
          </p>
          <p style="font-size: 15px; color: #555;">
            Thank you for signing up! To complete your registration, please verify your email by clicking the button below:
          </p>
          <div style="text-align: center; margin: 30px 0;">
            <a href="${verifyUrl}" 
              style="background: #4CAF50; color: white; padding: 12px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">
              Verify Email
            </a>
          </div>
          <p style="font-size: 14px; color: #777;">
            If the button doesn’t work, copy and paste the following link into your browser:
          </p>
          <p style="font-size: 14px; word-break: break-all; color: #0066cc;">
            ${verifyUrl}
          </p>
          <hr style="margin: 20px 0;" />
          <p style="font-size: 12px; color: #999; text-align: center;">
            If you didn’t sign up for this account, you can ignore this email.
          </p>
        </div>
        `
      );
      

    res.status(201).json({ success: true, message: "Verification link sent to email." });

  } catch (error) {
    console.error("Signup Error:", error);
    res.status(500).json({ success: false, message: "Registration failed." });
  }
};

/**
 * Verify Email
 */
const verifyEmail = async (req, res) => {
  try {
    const { token, id } = req.query;

    const user = await User.findOne({
      _id: id,
      verificationToken: token,
      verificationExpires: { $gt: Date.now() },
    });

    if (!user) {
      return res.redirect("http://127.0.0.1:5500/lib/screens/auth/verify-email.html?status=failed");
    }

    user.verified = true;
 
    user.verificationToken = undefined;
    user.verificationExpires = undefined;
    await user.save();

    return res.redirect("http://127.0.0.1:5500/lib/screens/auth/verify-email.html?status=success");
  } catch (error) {
    console.error("Verification Error:", error);
    return res.redirect("http://127.0.0.1:5500/lib/screens/auth/verify-email.html?status=failed");
  }
};


/**
 * Login
 */
const logIn = async (req, res) => {
  try {
    // 1. Validate request
    const { error } = UserLoginSchema.validate(req.body);
    if (error)
      return res
        .status(400)
        .json({ success: false, message: error.details[0].message });

    // 2. Find user by email
    const user = await User.findOne({ email: req.body.email }).select(
      "+password"
    );
    if (!user)
      return res
        .status(401)
        .json({ success: false, message: "Invalid credentials" });

    // 3. Ensure email is verified
    if (!user.verified)
      return res
        .status(403)
        .json({ success: false, message: "Verify your email first" });

    // 4. Compare passwords
    const validPass = await hash.compareData(req.body.password, user.password);
    if (!validPass)
      return res
        .status(401)
        .json({ success: false, message: "Invalid credentials" });

    // 5. Generate JWT token
    const token = jwt.sign(
      {
        userId: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
        verified: user.verified,
      },
      process.env.JWT_SECRET,
      { expiresIn: "7d" }
    );

    // 6. Set cookie
    res.cookie("token", token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "strict",
      maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
    });

    // 7. Mark user as active
    user.active = true;
    await user.save();

   

    // 9. Return response
    res.json({
      success: true,
      message: "Login successful",
      token,
     
    });
  } catch (error) {
    console.error("Login Error:", error);
    res.status(500).json({ success: false, message: "Login failed" });
  }
};


const logOut = async (req, res) => {
  try {
    // Get user from auth middleware
    const email = req.user.email;
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ success: false, message: "Unauthorized" });
    }

    // Optional: mark user inactive
    user.active = false;
    await user.save();

    // Clear cookie (if using cookie-based auth)
    res.clearCookie("token");

    res.json({ success: true, message: "Logged out successfully" });
  } catch (err) {
    console.error("Logout error:", err);
    res.status(500).json({ success: false, message: "Internal server error" });
  }
};

// sendForgetPasswordCode.js
const sendResetPasswordCode = async (req, res) => {
    try {
      const { email } = req.body;
  
      if (!email) {
        return res.status(400).json({ error: "Email is required" });
      }
  
      const user = await User.findOne({ email }).select("+verified");
      if (!user) {
        // Security: Don't reveal email existence
        return res.status(200).json({
          message: "If this email exists, a password reset code has been sent.",
        });
      }
  
      if (!user.verified) {
        return res.status(403).json({ error: "Email not verified" });
      }
  
      // Generate 6-digit OTP
      const otp = Math.floor(100000 + Math.random() * 900000).toString();
  
      user.resetPasswordToken = otp;
      user.resetPasswordExpires = new Date(Date.now() + 15 * 60 * 1000); // 15 minutes
      await user.save();
  
      // Send email
      await sendMail(
        user.email,
        "Password Reset Code",
        `Your password reset code is: ${otp}`,
        `
          <div style="font-family: Arial; max-width: 600px; margin: 0 auto;">
            <h2>Password Reset Request</h2>
            <p>Use the following code to reset your password:</p>
            <div style="background:#f5f5f5;padding:15px;text-align:center;margin:20px 0;">
              <span style="font-size:24px;font-weight:bold;">${otp}</span>
            </div>
            <p>This code will expire in 15 minutes.</p>
          </div>
        `
      );
  
      res.status(200).json({ message: "Password reset code sent to your email." });
    } catch (error) {
      console.error("Password Reset Send Error:", error);
      res.status(500).json({ error: "Failed to send reset code" });
    }
  };
  // verifyForgetPasswordCode.js
const verifyResetPasswordCode = async (req, res) => {
    try {
      const { email, otp, newPassword } = req.body;
  
      if (!email || !otp || !newPassword) {
        return res.status(400).json({ error: "All fields are required" });
      }
  
      const user = await User.findOne({ email }).select(
        "+resetPasswordToken +resetPasswordExpires +password"
      );
  
      if (!user) {
        return res.status(404).json({ error: "Invalid request" });
      }
  
      // Check OTP validity
      if (
        user.resetPasswordToken !== otp ||
        new Date() > user.resetPasswordExpires
      ) {
        return res.status(400).json({ error: "Invalid or expired OTP" });
      }
  
      // Check if new password is different
      const isSamePassword = await hash.compareData(newPassword, user.password);
      if (isSamePassword) {
        return res.status(400).json({
          error: "New password must be different from the old one",
        });
      }
  
      // Update password
      user.password = await hash.hashData(newPassword);
      user.resetPasswordToken = undefined;
      user.resetPasswordExpires = undefined;
      user.passwordChangedAt = Date.now();
      await user.save();
  
      res.status(200).json({ message: "Password reset successful. Please log in." });
    } catch (error) {
      console.error("Password Reset Verify Error:", error);
      res.status(500).json({ error: "Failed to reset password" });
    }
  };
  

export { signUp, verifyEmail, logIn, logOut, sendResetPasswordCode ,verifyResetPasswordCode};
