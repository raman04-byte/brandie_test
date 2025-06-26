import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import cookieParser from 'cookie-parser';
import dotenv from 'dotenv';
import { initializeDatabase } from './database.js';
import userRoutes from './routes/userRoutes.js';
import postRoutes from './routes/postRoutes.js';
import followRoutes from './routes/followRoutes.js';
import authRoutes from './routes/authRoutes.js';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());

// Rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // limit each IP to 100 requests per windowMs
    message: 'Too many requests from this IP, please try again later.',
});
app.use(limiter);

// CORS configuration
app.use(cors({
    origin: process.env.NODE_ENV === 'production'
        ? ['your-production-domain.com']
        : ['http://localhost:3000', 'http://localhost:3001', 'http://127.0.0.1:3000'],
    credentials: true,
}));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Cookie parsing middleware
app.use(cookieParser());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/posts', postRoutes);
app.use('/api', followRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'ok',
        timestamp: new Date().toISOString(),
        environment: process.env.NODE_ENV || 'development'
    });
});

// Root endpoint
app.get('/', (req, res) => {
    res.json({
        message: 'Social Media Backend API',
        version: '1.0.0',
        endpoints: {
            auth: {
                register: 'POST /api/auth/register',
                login: 'POST /api/auth/login',
                loginSession: 'POST /api/auth/login-session',
                logout: 'POST /api/auth/logout',
                me: 'GET /api/auth/me',
                status: 'GET /api/auth/status',
                refreshToken: 'POST /api/auth/refresh-token',
            },
            users: {
                profile: 'GET /api/users/me/profile',
                updateProfile: 'PUT /api/users/me/profile',
                getUserByUsername: 'GET /api/users/:username',
                // Legacy auth endpoints (still available)
                legacyRegister: 'POST /api/users/register',
                legacyLogin: 'POST /api/users/login',
            },
            posts: {
                create: 'POST /api/posts',
                timeline: 'GET /api/posts/timeline',
                userPosts: 'GET /api/posts/user/:username',
                getPost: 'GET /api/posts/:id',
                deletePost: 'DELETE /api/posts/:id',
            },
            follows: {
                follow: 'POST /api/:username/follow',
                unfollow: 'DELETE /api/:username/follow',
                followers: 'GET /api/:username/followers',
                following: 'GET /api/:username/following',
                followStatus: 'GET /api/:username/follow-status',
            },
        },
    });
});

// 404 handler
app.use('*', (req, res) => {
    res.status(404).json({ error: 'Route not found' });
});

// Global error handler
app.use((err: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error('Global error handler:', err);
    res.status(500).json({
        error: 'Internal server error',
        message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
    });
});

// Start server
const startServer = async () => {
    try {
        // Try to initialize database
        try {
            await initializeDatabase();
            console.log('✅ Database initialized successfully');
        } catch (error) {
            console.warn('⚠️ Database connection failed - running in development mode without database');
            console.warn('To fix this: Start PostgreSQL or use Docker: docker-compose up -d');
            console.warn('Database error:', error instanceof Error ? error.message : String(error));

            if (process.env.NODE_ENV === 'production') {
                console.error('❌ Database required in production mode');
                process.exit(1);
            }
        }

        // Start server regardless of database status in development
        app.listen(PORT, () => {
            console.log(`🚀 Server is running on port ${PORT}`);
            console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
            console.log(`📖 API Documentation: http://localhost:${PORT}/`);
            console.log(`🧪 Test endpoints: http://localhost:${PORT}/health`);

            if (process.env.NODE_ENV !== 'production') {
                console.log('\n💡 Quick Start:');
                console.log('   1. Database: docker-compose up -d');
                console.log('   2. Test API: node test-auth.js');
            }
        });
    } catch (error) {
        console.error('❌ Failed to start server:', error);
        process.exit(1);
    }
};

// Handle graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received, shutting down gracefully');
    process.exit(0);
});

process.on('SIGINT', () => {
    console.log('SIGINT received, shutting down gracefully');
    process.exit(0);
});

startServer();
