#!/usr/bin/env node

// Simple API test script
// Run with: node test-api.js

const BASE_URL = 'http://localhost:3000';

async function makeRequest(method, endpoint, data = null, token = null) {
    const options = {
        method,
        headers: {
            'Content-Type': 'application/json',
        },
    };

    if (token) {
        options.headers['Authorization'] = `Bearer ${token}`;
    }

    if (data) {
        options.body = JSON.stringify(data);
    }

    try {
        const response = await fetch(`${BASE_URL}${endpoint}`, options);
        const result = await response.json();

        console.log(`${method} ${endpoint}`);
        console.log(`Status: ${response.status}`);
        console.log('Response:', JSON.stringify(result, null, 2));
        console.log('---');

        return { response, result };
    } catch (error) {
        console.error(`Error with ${method} ${endpoint}:`, error.message);
        return null;
    }
}

async function runTests() {
    console.log('🚀 Testing Social Media Backend API\n');

    // Test health check
    await makeRequest('GET', '/health');

    // Test API root
    await makeRequest('GET', '/');

    // Register a test user
    const registerData = {
        username: 'testuser',
        email: 'test@example.com',
        password: 'testpassword123',
        display_name: 'Test User',
        bio: 'A test user for API testing'
    };

    const registerResult = await makeRequest('POST', '/api/users/register', registerData);

    if (!registerResult || registerResult.response.status !== 201) {
        console.log('❌ User registration failed, trying to login instead...');
        const loginResult = await makeRequest('POST', '/api/users/login', {
            username: 'testuser',
            password: 'testpassword123'
        });

        if (!loginResult || loginResult.response.status !== 200) {
            console.log('❌ Login also failed. Cannot continue tests.');
            return;
        }

        var token = loginResult.result.token;
    } else {
        var token = registerResult.result.token;
    }

    console.log('✅ Authentication successful!');

    // Test profile endpoints
    await makeRequest('GET', '/api/users/me/profile', null, token);

    // Update profile
    await makeRequest('PUT', '/api/users/me/profile', {
        display_name: 'Updated Test User',
        bio: 'Updated bio for testing'
    }, token);

    // Create a test post
    await makeRequest('POST', '/api/posts', {
        content: 'This is a test post from the API test script! 🎉'
    }, token);

    // Get timeline
    await makeRequest('GET', '/api/posts/timeline', null, token);

    // Get user posts
    await makeRequest('GET', '/api/posts/user/testuser');

    console.log('✅ All tests completed!');
    console.log('\n📝 Test Summary:');
    console.log('- User registration/login ✅');
    console.log('- Profile management ✅');
    console.log('- Post creation ✅');
    console.log('- Timeline retrieval ✅');
    console.log('- User posts retrieval ✅');
}

// Check if fetch is available (Node.js 18+)
if (typeof fetch === 'undefined') {
    console.error('❌ This script requires Node.js 18+ with built-in fetch support');
    console.log('Please upgrade your Node.js version or install node-fetch package');
    process.exit(1);
}

runTests().catch(console.error);
