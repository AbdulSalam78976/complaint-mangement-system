import { Router } from 'express';
import { auth,permit } from '../middleware/auth.js';
import *  as Complaint from '../controllers/complaintController.js';
import upload from '../middleware/multer.js';
const router = Router();

router.post('/create', auth,permit('user'),upload.array('attachments',5), Complaint.createComplaint);
router.get('/', auth, Complaint.listComplaints);
router.get('/stats/summary', auth, Complaint.statsSummary); // staff/admin
router.get('/:id', auth,Complaint.getComplaint);
router.put('/:id', auth, Complaint.updateComplaint);
router.post('/:id/comments', auth, Complaint.addComment);

export default router;