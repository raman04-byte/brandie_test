# Social Media Backend API

A minimal social media backend built with Node.js, Express, PostgreSQL, and JWT authentication.

## Features

### User Management
- User registration and authentication
- JWT-based authentication
- User profiles with bio and avatar
- User discovery by username

### Social Graph
- Follow/unfollow users
- View followers and following lists
- Check follow status between users

### Posts & Timeline
- Create posts with text and media support
- Personal timeline/feed (posts from followed users)
- User post history
- Post retrieval and deletion

## Tech Stack

- **Runtime**: Node.js 18+
- **Framework**: Express.js
- **Database**: PostgreSQL 15
- **Authentication**: JWT (JSON Web Tokens)
- **Language**: TypeScript
- **Security**: Helmet, CORS, Rate limiting

## Setup Instructions

### Prerequisites
- Node.js 18+
- PostgreSQL 15
- npm or yarn

### Installation

1. **Clone and install dependencies**:
   ```bash
   cd backend_task
   npm install
   ```

2. **Database Setup**:
   ```bash
   # Create a PostgreSQL database
   createdb social_media_db
   
   # Or using SQL:
   # CREATE DATABASE social_media_db;
   ```

3. **Environment Configuration**:
   Copy `.env` file and update the values:
   ```bash
   # Update the DATABASE_URL with your PostgreSQL credentials
   DATABASE_URL=postgresql://username:password@localhost:5432/social_media_db
   
   # Generate a secure JWT secret
   JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
   ```

4. **Start the application**:
   ```bash
   # Development mode (with auto-reload)
   npm run dev
   
   # Production mode
   npm run build
   npm start
   ```

The server will start on `http://localhost:3000`

## API Endpoints

### Authentication
- `POST /api/users/register` - Register a new user
- `POST /api/users/login` - Login user

### User Management
- `GET /api/users/me/profile` - Get current user profile (authenticated)
- `PUT /api/users/me/profile` - Update current user profile (authenticated)
- `GET /api/users/:username` - Get user by username

### Posts
- `POST /api/posts` - Create a new post (authenticated)
- `GET /api/posts/timeline` - Get timeline/feed (authenticated)
- `GET /api/posts/user/:username` - Get posts by user
- `GET /api/posts/:id` - Get specific post
- `DELETE /api/posts/:id` - Delete post (authenticated, own posts only)

### Social Graph
- `POST /api/:username/follow` - Follow a user (authenticated)
- `DELETE /api/:username/follow` - Unfollow a user (authenticated)
- `GET /api/:username/followers` - Get user's followers
- `GET /api/:username/following` - Get users that user follows
- `GET /api/:username/follow-status` - Check if current user follows target user (authenticated)

## Database Schema

### Users Table
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(100),
  bio TEXT,
  avatar_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Posts Table
```sql
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  media_url VARCHAR(255),
  media_type VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Follows Table
```sql
CREATE TABLE follows (
  id SERIAL PRIMARY KEY,
  follower_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  following_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(follower_id, following_id),
  CHECK (follower_id != following_id)
);
```

## API Usage Examples

### Register a User
```bash
curl -X POST http://localhost:3000/api/users/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "johndoe",
    "email": "john@example.com",
    "password": "securepassword123",
    "display_name": "John Doe",
    "bio": "Software developer"
  }'
```

### Login
```bash
curl -X POST http://localhost:3000/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "johndoe",
    "password": "securepassword123"
  }'
```

### Create a Post
```bash
curl -X POST http://localhost:3000/api/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "content": "Hello, world! This is my first post."
  }'
```

### Follow a User
```bash
curl -X POST http://localhost:3000/api/janedoe/follow \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### Get Timeline
```bash
curl -X GET http://localhost:3000/api/posts/timeline \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Security Features

- **Rate Limiting**: 100 requests per 15 minutes per IP
- **CORS**: Configured for development and production
- **Helmet**: Security headers
- **JWT Authentication**: Secure token-based authentication
- **Password Hashing**: bcrypt with salt rounds
- **SQL Injection Protection**: Parameterized queries

## Development

### Project Structure
```
src/
├── controllers/     # Request handlers
├── routes/         # API routes
├── auth.ts         # Authentication utilities
├── database.ts     # Database configuration
├── types.ts        # TypeScript type definitions
└── index.ts        # Main application file
```

### Available Scripts
- `npm run dev` - Start development server with auto-reload
- `npm run build` - Build TypeScript to JavaScript
- `npm start` - Start production server
- `npm test` - Run tests (placeholder)

## Production Deployment

1. Set `NODE_ENV=production`
2. Use a secure `JWT_SECRET`
3. Configure PostgreSQL with proper credentials
4. Set up proper CORS origins
5. Consider using a reverse proxy (nginx)
6. Set up SSL/TLS certificates

## License

ISC
