import { Request, Response } from 'express';
import pool from '../database.js';
import { PostCreateInput, Post } from '../types.js';

export const createPost = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.user!.userId;
        const { content, media_url, media_type }: PostCreateInput = req.body;

        if (!content || content.trim().length === 0) {
            res.status(400).json({ error: 'Post content is required' });
            return;
        }

        const result = await pool.query(
            `INSERT INTO posts (user_id, content, media_url, media_type) 
       VALUES ($1, $2, $3, $4) 
       RETURNING *`,
            [userId, content.trim(), media_url, media_type]
        );

        // Get the post with user information
        const postWithUser = await pool.query(
            `SELECT p.*, u.username, u.display_name, u.avatar_url
       FROM posts p
       JOIN users u ON p.user_id = u.id
       WHERE p.id = $1`,
            [result.rows[0].id]
        );

        res.status(201).json(postWithUser.rows[0]);
    } catch (error) {
        console.error('Create post error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const getUserPosts = async (req: Request, res: Response): Promise<void> => {
    try {
        const { username } = req.params;
        const page = parseInt(req.query.page as string) || 1;
        const limit = parseInt(req.query.limit as string) || 20;
        const offset = (page - 1) * limit;

        // Get user ID first
        const userResult = await pool.query('SELECT id FROM users WHERE username = $1', [username]);

        if (userResult.rows.length === 0) {
            res.status(404).json({ error: 'User not found' });
            return;
        }

        const userId = userResult.rows[0].id;

        const result = await pool.query(
            `SELECT p.*, u.username, u.display_name, u.avatar_url
       FROM posts p
       JOIN users u ON p.user_id = u.id
       WHERE p.user_id = $1
       ORDER BY p.created_at DESC
       LIMIT $2 OFFSET $3`,
            [userId, limit, offset]
        );

        // Get total count for pagination
        const countResult = await pool.query(
            'SELECT COUNT(*) FROM posts WHERE user_id = $1',
            [userId]
        );

        const totalPosts = parseInt(countResult.rows[0].count);
        const totalPages = Math.ceil(totalPosts / limit);

        res.json({
            posts: result.rows,
            pagination: {
                page,
                limit,
                total: totalPosts,
                pages: totalPages,
                hasNext: page < totalPages,
                hasPrev: page > 1,
            },
        });
    } catch (error) {
        console.error('Get user posts error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const getTimeline = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.user!.userId;
        const page = parseInt(req.query.page as string) || 1;
        const limit = parseInt(req.query.limit as string) || 20;
        const offset = (page - 1) * limit;

        // Get posts from users that the current user follows, plus their own posts
        const result = await pool.query(
            `SELECT p.*, u.username, u.display_name, u.avatar_url
       FROM posts p
       JOIN users u ON p.user_id = u.id
       WHERE p.user_id = $1 
          OR p.user_id IN (
            SELECT following_id FROM follows WHERE follower_id = $1
          )
       ORDER BY p.created_at DESC
       LIMIT $2 OFFSET $3`,
            [userId, limit, offset]
        );

        // Get total count for pagination
        const countResult = await pool.query(
            `SELECT COUNT(*) FROM posts p
       WHERE p.user_id = $1 
          OR p.user_id IN (
            SELECT following_id FROM follows WHERE follower_id = $1
          )`,
            [userId]
        );

        const totalPosts = parseInt(countResult.rows[0].count);
        const totalPages = Math.ceil(totalPosts / limit);

        res.json({
            posts: result.rows,
            pagination: {
                page,
                limit,
                total: totalPosts,
                pages: totalPages,
                hasNext: page < totalPages,
                hasPrev: page > 1,
            },
        });
    } catch (error) {
        console.error('Get timeline error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const getPost = async (req: Request, res: Response): Promise<void> => {
    try {
        const { id } = req.params;

        const result = await pool.query(
            `SELECT p.*, u.username, u.display_name, u.avatar_url
       FROM posts p
       JOIN users u ON p.user_id = u.id
       WHERE p.id = $1`,
            [id]
        );

        if (result.rows.length === 0) {
            res.status(404).json({ error: 'Post not found' });
            return;
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error('Get post error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

export const deletePost = async (req: Request, res: Response): Promise<void> => {
    try {
        const userId = req.user!.userId;
        const { id } = req.params;

        // Check if post exists and belongs to the user
        const result = await pool.query(
            'DELETE FROM posts WHERE id = $1 AND user_id = $2 RETURNING *',
            [id, userId]
        );

        if (result.rows.length === 0) {
            res.status(404).json({ error: 'Post not found or unauthorized' });
            return;
        }

        res.json({ message: 'Post deleted successfully' });
    } catch (error) {
        console.error('Delete post error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};
