import { Router } from 'express';
import {
    followUser,
    unfollowUser,
    getFollowers,
    getFollowing,
    getFollowStatus
} from '../controllers/followController.js';
import { authenticateFlexible } from '../middleware/authMiddleware.js';

const router = Router();

// Protected routes (supports both JWT and session auth)
router.post('/:username/follow', authenticateFlexible, followUser);
router.delete('/:username/follow', authenticateFlexible, unfollowUser);
router.get('/:username/follow-status', authenticateFlexible, getFollowStatus);

// Public routes
router.get('/:username/followers', getFollowers);
router.get('/:username/following', getFollowing);

export default router;
