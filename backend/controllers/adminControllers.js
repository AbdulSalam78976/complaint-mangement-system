import User from "../models/user.js";

const getAllUsers = async (req, res) => {
  try {
    // ✅ Check if logged-in user is admin
    if (!req.user || req.user.role !== "admin") {
      return res.status(403).json({
        success: false,
        message: "Access denied. Only admins can view all users.",
      });
    }

    const users = await User.find({}).select("-passwordHash");

    const safeUsers = users.map(user =>
      user.toSafeJSON ? user.toSafeJSON() : user
    );

    res.status(200).json({
      success: true,
      message: "Users fetched successfully",
      users: safeUsers,
    });
  } catch (err) {
    console.error("Error fetching users:", err);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
};


export default getAllUsers;