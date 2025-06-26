# Authentication Middleware Documentation

## Overview

The authentication system supports **two authentication methods**:

1. **JWT Bearer Tokens** - Stateless authentication
2. **Session Cookies** - Server-side session management

## Middleware Functions

### `authenticateJWT(req, res, next)`
- **Purpose**: Validates JWT Bearer tokens only
- **Header**: `Authorization: Bearer <token>`
- **Use Case**: API-first applications, mobile apps, SPAs

### `authenticateSession(req, res, next)`
- **Purpose**: Validates session cookies only
- **Cookie**: `sessionId=<session-id>`
- **Use Case**: Traditional web applications

### `authenticateFlexible(req, res, next)` ⭐
- **Purpose**: Accepts both JWT and session authentication
- **Priority**: Tries JWT first, falls back to session cookies
- **Use Case**: Hybrid applications supporting multiple auth methods

### `optionalAuth(req, res, next)`
- **Purpose**: Sets user info if authenticated, but doesn't block unauthenticated requests
- **Use Case**: Public endpoints that show different content for authenticated users

## Authentication Endpoints

### JWT Authentication
```bash
# Register (returns JWT token)
POST /api/auth/register
{
  "username": "johndoe",
  "email": "john@example.com", 
  "password": "securepassword123",
  "display_name": "John Doe"
}

# Login (returns JWT token)
POST /api/auth/login
{
  "username": "johndoe",
  "password": "securepassword123"
}

# Refresh JWT token
POST /api/auth/refresh-token
Headers: Authorization: Bearer <token>
```

### Session Authentication
```bash
# Login with session (sets cookie)
POST /api/auth/login-session
{
  "username": "johndoe",
  "password": "securepassword123"
}

# Logout (clears session)
POST /api/auth/logout
Cookie: sessionId=<session-id>
```

### Universal Endpoints
```bash
# Get current user (works with both auth methods)
GET /api/auth/me
Headers: Authorization: Bearer <token> OR Cookie: sessionId=<session-id>

# Check auth status
GET /api/auth/status
Headers: Authorization: Bearer <token> OR Cookie: sessionId=<session-id>
```

## Usage Examples

### JWT Authentication
```javascript
// Login and get token
const loginResponse = await fetch('/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username: 'user', password: 'pass' })
});
const { token } = await loginResponse.json();

// Use token for authenticated requests
const response = await fetch('/api/posts', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify({ content: 'Hello World!' })
});
```

### Session Authentication
```javascript
// Login with session
const loginResponse = await fetch('/api/auth/login-session', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ username: 'user', password: 'pass' }),
  credentials: 'include' // Important for cookies
});

// Subsequent requests automatically include session cookie
const response = await fetch('/api/posts', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ content: 'Hello World!' }),
  credentials: 'include'
});
```

## Session Management

### Session Storage
- **Development**: In-memory store (resets on server restart)
- **Production**: Should use Redis or database storage

### Session Configuration
```javascript
// Session expires after 7 days of inactivity
// Automatic cleanup of expired sessions
// Secure cookies in production (HTTPS only)
```

### Session Functions
```javascript
import { 
  createSession, 
  destroySession, 
  cleanupExpiredSessions 
} from './middleware/authMiddleware.js';

// Create session
const sessionId = createSession(res, userId, username);

// Destroy session
destroySession(req, res);

// Cleanup expired sessions (run periodically)
cleanupExpiredSessions();
```

## Security Features

### JWT Security
- ✅ Cryptographically signed tokens
- ✅ Configurable expiration (default: 7 days)
- ✅ Stateless (no server storage required)

### Session Security  
- ✅ HttpOnly cookies (prevents XSS)
- ✅ Secure flag in production (HTTPS only)
- ✅ SameSite protection (CSRF prevention)
- ✅ Automatic session expiration

### General Security
- ✅ Password hashing with bcrypt (12 rounds)
- ✅ Rate limiting on all endpoints
- ✅ CORS configuration
- ✅ Helmet security headers

## Implementation in Routes

### Before (JWT only)
```javascript
import { authenticateToken } from '../auth.js';
router.get('/protected', authenticateToken, handler);
```

### After (Flexible auth)
```javascript
import { authenticateFlexible } from '../middleware/authMiddleware.js';
router.get('/protected', authenticateFlexible, handler);
```

## Request Object Extensions

After authentication, the request object contains:

```javascript
req.user = {
  userId: number,
  username: string,
  iat?: number,    // JWT only
  exp?: number     // JWT only
}

req.sessionId = string;  // Session auth only
```

## Testing

### Test Scripts
- `test-auth.js` - Comprehensive authentication testing
- `test-api.js` - Basic API functionality testing

### Run Tests
```bash
# Start server first
npm run dev

# Test authentication in another terminal
node test-auth.js
```

## Production Considerations

1. **Session Storage**: Replace in-memory store with Redis
2. **HTTPS**: Enable secure cookies
3. **Environment Variables**: Use strong JWT secrets
4. **Rate Limiting**: Adjust limits based on usage
5. **Session Cleanup**: Run periodic cleanup jobs

## Migration Guide

If upgrading from JWT-only authentication:

1. Install cookie-parser: `npm install cookie-parser`
2. Add cookie middleware to app: `app.use(cookieParser())`
3. Replace `authenticateToken` with `authenticateFlexible` in routes
4. Test both authentication methods
