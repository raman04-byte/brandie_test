import { Request, Response } from 'express';
import pool from '../database.js';

export const followUser = async (req: Request, res: Response): Promise<void> => {
    try {
        const followerId = req.user!.userId;
        const { username } = req.params;

        // Get the user to follow
        const userResult = await pool.query(
            'SELECT id FROM users WHERE username = $1',
            [username]
        );

        if (userResult.rows.length === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        const followingId = userResult.rows[0].id;

        // Check if user is trying to follow themselves
        if (followerId === followingId) {
            res.status(400).json({ error: 'Cannot follow yourself' });
            return;
        }

        // Check if already following
        const existingFollow = await pool.query(
            'SELECT id FROM follows WHERE follower_id = $1 AND following_id = $2',
            [followerId, followingId]
        );

        if (existingFollow.rows.length > 0) {
            res.status(409).json({ error: 'Already following this user' });
            return;
        }

        // Create follow relationship
        await pool.query(
            'INSERT INTO follows (follower_id, following_id) VALUES ($1, $2)',
            [followerId, followingId]
        );

        res.status(201).json({ message: 'Successfully followed user' });
    } catch (error) {
        console.error('Follow user error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const unfollowUser = async (req: Request, res: Response): Promise<void> => {
    try {
        const followerId = req.user!.userId;
        const { username } = req.params;

        // Get the user to unfollow
        const userResult = await pool.query(
            'SELECT id FROM users WHERE username = $1',
            [username]
        );

        if (userResult.rows.length === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        const followingId = userResult.rows[0].id;

        // Remove follow relationship
        const result = await pool.query(
            'DELETE FROM follows WHERE follower_id = $1 AND following_id = $2 RETURNING *',
            [followerId, followingId]
        );

        if (result.rows.length === 0) {
            res.status(404).json({ error: 'Not following this user' });
            return;
        }

        res.json({ message: 'Successfully unfollowed user' });
    } catch (error) {
        console.error('Unfollow user error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const getFollowers = async (req: Request, res: Response): Promise<void> => {
    try {
        const { username } = req.params;
        const page = parseInt(req.query.page as string) || 1;
        const limit = parseInt(req.query.limit as string) || 20;
        const offset = (page - 1) * limit;

        // Get user ID
        const userResult = await pool.query(
            'SELECT id FROM users WHERE username = $1',
            [username]
        );

        if (userResult.rows.length === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        const userId = userResult.rows[0].id;

        // Get followers
        const result = await pool.query(
            `SELECT u.id, u.username, u.display_name, u.avatar_url, f.created_at as followed_at
       FROM follows f
       JOIN users u ON f.follower_id = u.id
       WHERE f.following_id = $1
       ORDER BY f.created_at DESC
       LIMIT $2 OFFSET $3`,
            [userId, limit, offset]
        );

        // Get total count
        const countResult = await pool.query(
            'SELECT COUNT(*) FROM follows WHERE following_id = $1',
            [userId]
        );

        const totalFollowers = parseInt(countResult.rows[0].count);
        const totalPages = Math.ceil(totalFollowers / limit);

        res.json({
            followers: result.rows,
            pagination: {
                page,
                limit,
                total: totalFollowers,
                pages: totalPages,
                hasNext: page < totalPages,
                hasPrev: page > 1,
            },
        });
    } catch (error) {
        console.error('Get followers error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const getFollowing = async (req: Request, res: Response): Promise<void> => {
    try {
        const { username } = req.params;
        const page = parseInt(req.query.page as string) || 1;
        const limit = parseInt(req.query.limit as string) || 20;
        const offset = (page - 1) * limit;

        // Get user ID
        const userResult = await pool.query(
            'SELECT id FROM users WHERE username = $1',
            [username]
        );

        if (userResult.rows.length === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        const userId = userResult.rows[0].id;

        // Get following
        const result = await pool.query(
            `SELECT u.id, u.username, u.display_name, u.avatar_url, f.created_at as followed_at
       FROM follows f
       JOIN users u ON f.following_id = u.id
       WHERE f.follower_id = $1
       ORDER BY f.created_at DESC
       LIMIT $2 OFFSET $3`,
            [userId, limit, offset]
        );

        // Get total count
        const countResult = await pool.query(
            'SELECT COUNT(*) FROM follows WHERE follower_id = $1',
            [userId]
        );

        const totalFollowing = parseInt(countResult.rows[0].count);
        const totalPages = Math.ceil(totalFollowing / limit);

        res.json({
            following: result.rows,
            pagination: {
                page,
                limit,
                total: totalFollowing,
                pages: totalPages,
                hasNext: page < totalPages,
                hasPrev: page > 1,
            },
        });
    } catch (error) {
        console.error('Get following error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const getFollowStatus = async (req: Request, res: Response): Promise<void> => {
    try {
        const currentUserId = req.user!.userId;
        const { username } = req.params;

        // Get target user ID
        const userResult = await pool.query(
            'SELECT id FROM users WHERE username = $1',
            [username]
        );

        if (userResult.rows.length === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        const targetUserId = userResult.rows[0].id;

        // Check if current user follows target user
        const followResult = await pool.query(
            'SELECT id FROM follows WHERE follower_id = $1 AND following_id = $2',
            [currentUserId, targetUserId]
        );

        res.json({
            isFollowing: followResult.rows.length > 0,
        });
    } catch (error) {
        console.error('Get follow status error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};
