import multer from "multer";

// Configure Multer for multiple files
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // Make sure this directory exists
  },
  filename: function (req, file, cb) {
    // Create unique filename with timestamp
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + '-' + file.originalname);
  }
});

const upload = multer({
  storage: storage,
  // REMOVED the fileFilter to allow any file type
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit per file
  }
});

export default upload;