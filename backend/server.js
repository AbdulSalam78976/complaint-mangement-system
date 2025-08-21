import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import morgan from 'morgan';

import authRoutes from './routes/authRoutes.js';
import complaintRoutes from './routes/complaintRoutes.js';
import adminRoutes from './routes/adminRoutes.js';

dotenv.config();

const app = express();
app.use(express.json({ limit: '1mb' }));
app.use(cors({ origin: process.env.CORS_ORIGIN?.split(',') || '*' }));
app.use(morgan('dev'));

const MONGODB_URI = process.env.MONGODB_URI;
mongoose
    .connect(MONGODB_URI, {
       
    })
    .then(() => {
        console.log("Connected to MongoDB");
        // Start the server
       const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`🚀 Backend listening on http://localhost:${PORT}`));


    })
    .catch((error) => {
        console.error("MongoDB connection error:", error);
    });

app.get('/health', (_, res) => res.json({ ok: true }));
app.use('/api/auth', authRoutes);
app.use('/api/complaints', complaintRoutes);
app.use('/api/admin', adminRoutes);

