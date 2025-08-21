import { Router } from 'express';
import { auth } from '../middleware/auth.js';
import { createComplaint, listComplaints, getComplaint, updateComplaint, addComment, statsSummary } from '../controllers/complaintController.js';

const router = Router();

router.post('/', auth(), createComplaint);
router.get('/', auth(), listComplaints);
router.get('/stats/summary', auth(), statsSummary); // staff/admin
router.get('/:id', auth(), getComplaint);
router.patch('/:id', auth(), updateComplaint);
router.post('/:id/comments', auth(), addComment);

export default router;