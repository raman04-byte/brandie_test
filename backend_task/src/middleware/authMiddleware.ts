import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { JWTPayload } from '../types.js';

declare global {
    namespace Express {
        interface Request {
            user?: JWTPayload;
            sessionId?: string;
        }
    }
}

// Simple in-memory session store (use Redis in production)
const sessionStore = new Map<string, { userId: number; username: string; createdAt: Date }>();

// Helper function to generate session ID
const generateSessionId = (): string => {
    return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
};

// Helper function to verify JWT token
const verifyJWTToken = (token: string): JWTPayload => {
    const secret = process.env.JWT_SECRET;
    if (!secret) {
        throw new Error('JWT_SECRET environment variable is required');
    }
    return jwt.verify(token, secret) as JWTPayload;
};

/**
 * Middleware to authenticate using JWT Bearer token
 * Expects: Authorization: Bearer <token>
 */
export const authenticateJWT = (req: Request, res: Response, next: NextFunction): void => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

    if (!token) {
        res.status(401).json({ error: 'Access token required' });
        return;
    }

    try {
        const decoded = verifyJWTToken(token);
        req.user = decoded;
        next();
    } catch (error) {
        res.status(403).json({ error: 'Invalid or expired token' });
    }
};

/**
 * Middleware to authenticate using session cookies
 * Expects: Cookie: sessionId=<session-id>
 */
export const authenticateSession = (req: Request, res: Response, next: NextFunction): void => {
    const sessionId = req.cookies?.sessionId;

    if (!sessionId) {
        res.status(401).json({ error: 'Session cookie required' });
        return;
    }

    const session = sessionStore.get(sessionId);

    if (!session) {
        res.status(403).json({ error: 'Invalid or expired session' });
        return;
    }

    // Check if session is older than 7 days
    const sessionAge = Date.now() - session.createdAt.getTime();
    const maxAge = 7 * 24 * 60 * 60 * 1000; // 7 days in milliseconds

    if (sessionAge > maxAge) {
        sessionStore.delete(sessionId);
        res.status(403).json({ error: 'Session expired' });
        return;
    }

    req.user = { userId: session.userId, username: session.username };
    req.sessionId = sessionId;
    next();
};

/**
 * Flexible middleware that accepts both JWT and session authentication
 * Tries JWT first, then falls back to session cookies
 */
export const authenticateFlexible = (req: Request, res: Response, next: NextFunction): void => {
    // Try JWT authentication first
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (token) {
        try {
            const decoded = verifyJWTToken(token);
            req.user = decoded;
            return next();
        } catch (error) {
            // JWT failed, try session authentication
        }
    }

    // Try session authentication
    const sessionId = req.cookies?.sessionId;

    if (sessionId) {
        const session = sessionStore.get(sessionId);

        if (session) {
            // Check session age
            const sessionAge = Date.now() - session.createdAt.getTime();
            const maxAge = 7 * 24 * 60 * 60 * 1000; // 7 days

            if (sessionAge <= maxAge) {
                req.user = { userId: session.userId, username: session.username };
                req.sessionId = sessionId;
                return next();
            } else {
                sessionStore.delete(sessionId);
            }
        }
    }

    // Both authentication methods failed
    res.status(401).json({ error: 'Authentication required. Provide either Bearer token or session cookie' });
};

/**
 * Middleware for optional authentication
 * Sets req.user if authenticated, but doesn't block unauthenticated requests
 */
export const optionalAuth = (req: Request, res: Response, next: NextFunction): void => {
    // Try JWT authentication first
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (token) {
        try {
            const decoded = verifyJWTToken(token);
            req.user = decoded;
            return next();
        } catch (error) {
            // Continue without authentication
        }
    }

    // Try session authentication
    const sessionId = req.cookies?.sessionId;

    if (sessionId) {
        const session = sessionStore.get(sessionId);

        if (session) {
            const sessionAge = Date.now() - session.createdAt.getTime();
            const maxAge = 7 * 24 * 60 * 60 * 1000; // 7 days

            if (sessionAge <= maxAge) {
                req.user = { userId: session.userId, username: session.username };
                req.sessionId = sessionId;
            } else {
                sessionStore.delete(sessionId);
            }
        }
    }

    // Continue regardless of authentication status
    next();
};

/**
 * Create a new session and set cookie
 */
export const createSession = (res: Response, userId: number, username: string): string => {
    const sessionId = generateSessionId();
    const session = {
        userId,
        username,
        createdAt: new Date()
    };

    sessionStore.set(sessionId, session);

    // Set secure cookie
    res.cookie('sessionId', sessionId, {
        httpOnly: true,
        secure: process.env.NODE_ENV === 'production',
        sameSite: 'strict',
        maxAge: 7 * 24 * 60 * 60 * 1000 // 7 days
    });

    return sessionId;
};

/**
 * Destroy a session and clear cookie
 */
export const destroySession = (req: Request, res: Response): void => {
    const sessionId = req.sessionId || req.cookies?.sessionId;

    if (sessionId) {
        sessionStore.delete(sessionId);
    }

    res.clearCookie('sessionId');
};

/**
 * Get all active sessions (for admin purposes)
 */
export const getActiveSessions = (): Array<{ sessionId: string; userId: number; username: string; createdAt: Date }> => {
    return Array.from(sessionStore.entries()).map(([sessionId, session]) => ({
        sessionId,
        ...session
    }));
};

/**
 * Clean up expired sessions (should be called periodically)
 */
export const cleanupExpiredSessions = (): void => {
    const now = Date.now();
    const maxAge = 7 * 24 * 60 * 60 * 1000; // 7 days

    for (const [sessionId, session] of sessionStore.entries()) {
        const sessionAge = now - session.createdAt.getTime();
        if (sessionAge > maxAge) {
            sessionStore.delete(sessionId);
        }
    }
};

// Export the original JWT middleware for backward compatibility
export const authenticateToken = authenticateJWT;
