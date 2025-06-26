import { Router } from 'express';
import {
    createPost,
    getUserPosts,
    getTimeline,
    getPost,
    deletePost
} from '../controllers/postController.js';
import { authenticateFlexible } from '../middleware/authMiddleware.js';

const router = Router();

// Protected routes (supports both JWT and session auth)
router.post('/', authenticateFlexible, createPost);
router.get('/timeline', authenticateFlexible, getTimeline);
router.delete('/:id', authenticateFlexible, deletePost);

// Public routes
router.get('/:id', getPost);
router.get('/user/:username', getUserPosts);

export default router;
