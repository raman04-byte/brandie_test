import { Router } from 'express';
import { Request, Response } from 'express';
import pool from '../database.js';
import { hashPassword, comparePassword, generateToken } from '../auth.js';
import { createSession, destroySession, authenticateFlexible } from '../middleware/authMiddleware.js';
import { User, UserCreateInput, AuthPayload } from '../types.js';

const router = Router();

/**
 * Register with JWT response
 * POST /api/auth/register
 */
router.post('/register', async (req: Request, res: Response): Promise<void> => {
    try {
        const { username, email, password, display_name, bio }: UserCreateInput = req.body;

        if (!username || !email || !password) {
            res.status(400).json({ error: 'Username, email, and password are required' });
            return;
        }

        // Check if user already exists
        const existingUser = await pool.query(
            'SELECT id FROM users WHERE username = $1 OR email = $2',
            [username, email]
        );

        if (existingUser.rows.length > 0) {
            res.status(409).json({ error: 'Username or email already exists' });
            return;
        }

        // Hash password and create user
        const passwordHash = await hashPassword(password);
        const result = await pool.query(
            `INSERT INTO users (username, email, password_hash, display_name, bio) 
       VALUES ($1, $2, $3, $4, $5) 
       RETURNING id, username, email, display_name, bio, avatar_url, created_at, updated_at`,
            [username, email, passwordHash, display_name, bio]
        );

        const user = result.rows[0];
        const token = generateToken({ userId: user.id, username: user.username });

        const authPayload: AuthPayload = {
            token,
            user: {
                id: user.id,
                username: user.username,
                email: user.email,
                display_name: user.display_name,
                bio: user.bio,
                avatar_url: user.avatar_url,
                created_at: user.created_at,
                updated_at: user.updated_at,
            },
        };

        res.status(201).json(authPayload);
    } catch (error) {
        console.error('Registration error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

/**
 * Login with JWT response
 * POST /api/auth/login
 */
router.post('/login', async (req: Request, res: Response): Promise<void> => {
    try {
        const { username, password } = req.body;

        if (!username || !password) {
            res.status(400).json({ error: 'Username and password are required' });
            return;
        }

        // Find user by username or email
        const result = await pool.query(
            'SELECT * FROM users WHERE username = $1 OR email = $1',
            [username]
        );

        if (result.rows.length === 0) {
            res.status(401).json({ error: 'Invalid credentials' });
            return;
        }

        const user = result.rows[0];
        const isValidPassword = await comparePassword(password, user.password_hash);

        if (!isValidPassword) {
            res.status(401).json({ error: 'Invalid credentials' });
            return;
        }

        const token = generateToken({ userId: user.id, username: user.username });

        const authPayload: AuthPayload = {
            token,
            user: {
                id: user.id,
                username: user.username,
                email: user.email,
                display_name: user.display_name,
                bio: user.bio,
                avatar_url: user.avatar_url,
                created_at: user.created_at,
                updated_at: user.updated_at,
            },
        };

        res.json(authPayload);
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

/**
 * Login with session cookie
 * POST /api/auth/login-session
 */
router.post('/login-session', async (req: Request, res: Response): Promise<void> => {
    try {
        const { username, password } = req.body;

        if (!username || !password) {
            res.status(400).json({ error: 'Username and password are required' });
            return;
        }

        // Find user by username or email
        const result = await pool.query(
            'SELECT * FROM users WHERE username = $1 OR email = $1',
            [username]
        );

        if (result.rows.length === 0) {
            res.status(401).json({ error: 'Invalid credentials' });
            return;
        }

        const user = result.rows[0];
        const isValidPassword = await comparePassword(password, user.password_hash);

        if (!isValidPassword) {
            res.status(401).json({ error: 'Invalid credentials' });
            return;
        }

        // Create session and set cookie
        const sessionId = createSession(res, user.id, user.username);

        res.json({
            message: 'Login successful',
            sessionId,
            user: {
                id: user.id,
                username: user.username,
                email: user.email,
                display_name: user.display_name,
                bio: user.bio,
                avatar_url: user.avatar_url,
                created_at: user.created_at,
                updated_at: user.updated_at,
            },
        });
    } catch (error) {
        console.error('Session login error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

/**
 * Logout (works for both JWT and session)
 * POST /api/auth/logout
 */
router.post('/logout', authenticateFlexible, (req: Request, res: Response): void => {
    // If using session authentication, destroy the session
    if (req.sessionId) {
        destroySession(req, res);
    }

    res.json({ message: 'Logout successful' });
});

/**
 * Get current user info (works with both auth methods)
 * GET /api/auth/me
 */
router.get('/me', authenticateFlexible, async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.user!.userId;

        const result = await pool.query(
            'SELECT id, username, email, display_name, bio, avatar_url, created_at, updated_at FROM users WHERE id = $1',
            [userId]
        );

        if (result.rows.length === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        res.json({
            user: result.rows[0],
            authMethod: req.sessionId ? 'session' : 'jwt'
        });
    } catch (error) {
        console.error('Get current user error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

/**
 * Refresh JWT token (only for JWT auth)
 * POST /api/auth/refresh-token
 */
router.post('/refresh-token', authenticateFlexible, (req: Request, res: Response): void => {
    if (req.sessionId) {
        res.status(400).json({ error: 'Token refresh not available for session authentication' });
        return;
    }

    const userId = req.user!.userId;
    const username = req.user!.username;

    const newToken = generateToken({ userId, username });

    res.json({
        token: newToken,
        message: 'Token refreshed successfully'
    });
});

/**
 * Check authentication status
 * GET /api/auth/status
 */
router.get('/status', authenticateFlexible, (req: Request, res: Response): void => {
    res.json({
        authenticated: true,
        method: req.sessionId ? 'session' : 'jwt',
        user: {
            userId: req.user!.userId,
            username: req.user!.username
        }
    });
});

export default router;
