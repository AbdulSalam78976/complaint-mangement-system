import User from "../models/user.js";

const getAllUsers = async (req, res) => {
  try {
    

    const users = await User.find({}).select("-passwordHash");
    const safeUsers = users.map(user => user.toSafeJSON ? user.toSafeJSON() : user);

    res.status(200).json({
      success: true,
      message: "Users fetched successfully",
      users: safeUsers,
    });
  } catch (err) {
    console.error("Error fetching users:", err);
    res.status(500).json({ success: false, message: "Internal server error" });
  }
};

export default getAllUsers;