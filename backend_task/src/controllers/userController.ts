import { Request, Response } from 'express';
import pool from '../database.js';
import { hashPassword, comparePassword, generateToken } from '../auth.js';
import { User, UserCreateInput, UserUpdateInput, AuthPayload } from '../types.js';

export const register = async (req: Request, res: Response): Promise<void> => {
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
};

export const login = async (req: Request, res: Response): Promise<void> => {
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
};

export const getProfile = async (req: Request, res: Response): Promise<void> => {
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

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Get profile error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const updateProfile = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.user!.userId;
        const { display_name, bio, avatar_url }: UserUpdateInput = req.body;

        const result = await pool.query(
            `UPDATE users 
       SET display_name = COALESCE($1, display_name), 
           bio = COALESCE($2, bio), 
           avatar_url = COALESCE($3, avatar_url),
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $4 
       RETURNING id, username, email, display_name, bio, avatar_url, created_at, updated_at`,
            [display_name, bio, avatar_url, userId]
        );

        if (result.rows.length === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Update profile error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const getUserByUsername = async (req: Request, res: Response): Promise<void> => {
    try {
        const { username } = req.params;

        const result = await pool.query(
            'SELECT id, username, display_name, bio, avatar_url, created_at FROM users WHERE username = $1',
            [username]
        );

        if (result.rows.length === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Get user error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};
