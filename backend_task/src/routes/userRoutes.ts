import { Router } from 'express';
import { register, login, getProfile, updateProfile, getUserByUsername } from '../controllers/userController.js';
import { authenticateFlexible } from '../middleware/authMiddleware.js';

const router = Router();

// Public routes
router.post('/register', register);
router.post('/login', login);
router.get('/:username', getUserByUsername);

// Protected routes (supports both JWT and session auth)
router.get('/me/profile', authenticateFlexible, getProfile);
router.put('/me/profile', authenticateFlexible, updateProfile);

export default router;
