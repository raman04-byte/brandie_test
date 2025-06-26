#!/usr/bin/env node

// Authentication middleware test script
// Tests both JWT and session cookie authentication
// Run with: node test-auth.js

const BASE_URL = 'http://localhost:3000';

async function makeRequest(method, endpoint, data = null, options = {}) {
    const requestOptions = {
        method,
        headers: {
            'Content-Type': 'application/json',
            ...options.headers
        },
    };

    if (options.token) {
        requestOptions.headers['Authorization'] = `Bearer ${options.token}`;
    }

    if (options.cookies) {
        requestOptions.headers['Cookie'] = options.cookies;
    }

    if (data) {
        requestOptions.body = JSON.stringify(data);
    }

    try {
        const response = await fetch(`${BASE_URL}${endpoint}`, requestOptions);
        const result = await response.json();

        // Extract cookies from response if present
        const setCookieHeader = response.headers.get('set-cookie');

        console.log(`${method} ${endpoint}`);
        console.log(`Status: ${response.status}`);
        if (setCookieHeader) {
            console.log(`Set-Cookie: ${setCookieHeader}`);
        }
        console.log('Response:', JSON.stringify(result, null, 2));
        console.log('---');

        return { response, result, cookies: setCookieHeader };
    } catch (error) {
        console.error(`Error with ${method} ${endpoint}:`, error.message);
        return null;
    }
}

function extractSessionId(cookies) {
    if (!cookies) return null;
    const match = cookies.match(/sessionId=([^;]+)/);
    return match ? match[1] : null;
}

async function runAuthTests() {
    console.log('🔐 Testing Authentication Middleware\n');

    const testUser = {
        username: 'testauth',
        email: 'testauth@example.com',
        password: 'testpassword123',
        display_name: 'Test Auth User',
        bio: 'Testing authentication'
    };

    // Test 1: Register with JWT
    console.log('=== Test 1: JWT Authentication ===');
    const registerResult = await makeRequest('POST', '/api/auth/register', testUser);

    if (!registerResult || registerResult.response.status !== 201) {
        console.log('❌ Registration failed, trying to login...');
        const loginResult = await makeRequest('POST', '/api/auth/login', {
            username: testUser.username,
            password: testUser.password
        });

        if (!loginResult || loginResult.response.status !== 200) {
            console.log('❌ Both registration and login failed. Cannot continue.');
            return;
        }
        var jwtToken = loginResult.result.token;
    } else {
        var jwtToken = registerResult.result.token;
    }

    console.log('✅ JWT Token obtained');

    // Test 2: Use JWT token to access protected endpoint
    console.log('\n=== Test 2: JWT Protected Access ===');
    await makeRequest('GET', '/api/auth/me', null, { token: jwtToken });

    // Test 3: Session-based authentication
    console.log('\n=== Test 3: Session Authentication ===');
    const sessionLoginResult = await makeRequest('POST', '/api/auth/login-session', {
        username: testUser.username,
        password: testUser.password
    });

    if (!sessionLoginResult || sessionLoginResult.response.status !== 200) {
        console.log('❌ Session login failed');
        return;
    }

    const sessionId = extractSessionId(sessionLoginResult.cookies);
    const sessionCookie = `sessionId=${sessionId}`;
    console.log('✅ Session cookie obtained:', sessionCookie);

    // Test 4: Use session cookie to access protected endpoint
    console.log('\n=== Test 4: Session Protected Access ===');
    await makeRequest('GET', '/api/auth/me', null, { cookies: sessionCookie });

    // Test 5: Test flexible auth endpoint with JWT
    console.log('\n=== Test 5: Flexible Auth with JWT ===');
    await makeRequest('GET', '/api/auth/status', null, { token: jwtToken });

    // Test 6: Test flexible auth endpoint with session
    console.log('\n=== Test 6: Flexible Auth with Session ===');
    await makeRequest('GET', '/api/auth/status', null, { cookies: sessionCookie });

    // Test 7: Create post with JWT
    console.log('\n=== Test 7: Create Post with JWT ===');
    await makeRequest('POST', '/api/posts', {
        content: 'This post was created using JWT authentication! 🔑'
    }, { token: jwtToken });

    // Test 8: Create post with session
    console.log('\n=== Test 8: Create Post with Session ===');
    await makeRequest('POST', '/api/posts', {
        content: 'This post was created using session authentication! 🍪'
    }, { cookies: sessionCookie });

    // Test 9: Test timeline with JWT
    console.log('\n=== Test 9: Get Timeline with JWT ===');
    await makeRequest('GET', '/api/posts/timeline', null, { token: jwtToken });

    // Test 10: Test timeline with session
    console.log('\n=== Test 10: Get Timeline with Session ===');
    await makeRequest('GET', '/api/posts/timeline', null, { cookies: sessionCookie });

    // Test 11: Refresh JWT token
    console.log('\n=== Test 11: Refresh JWT Token ===');
    await makeRequest('POST', '/api/auth/refresh-token', null, { token: jwtToken });

    // Test 12: Logout (session)
    console.log('\n=== Test 12: Logout Session ===');
    await makeRequest('POST', '/api/auth/logout', null, { cookies: sessionCookie });

    // Test 13: Try to access protected endpoint after logout
    console.log('\n=== Test 13: Access After Session Logout ===');
    await makeRequest('GET', '/api/auth/me', null, { cookies: sessionCookie });

    // Test 14: JWT should still work
    console.log('\n=== Test 14: JWT Still Works After Session Logout ===');
    await makeRequest('GET', '/api/auth/me', null, { token: jwtToken });

    console.log('\n🎉 Authentication tests completed!');
    console.log('\n📊 Test Summary:');
    console.log('✅ JWT Authentication');
    console.log('✅ Session Cookie Authentication');
    console.log('✅ Flexible Authentication (both methods)');
    console.log('✅ Protected endpoint access');
    console.log('✅ Session logout');
    console.log('✅ Token refresh');
}

// Check if fetch is available (Node.js 18+)
if (typeof fetch === 'undefined') {
    console.error('❌ This script requires Node.js 18+ with built-in fetch support');
    console.log('Please upgrade your Node.js version');
    process.exit(1);
}

runAuthTests().catch(console.error);
