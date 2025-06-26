#!/usr/bin/env node

// Setup script for the Social Media Backend
// Run with: node setup.js

import { exec } from 'child_process';
import { promisify } from 'util';
import fs from 'fs';
import path from 'path';

const execAsync = promisify(exec);

console.log('🚀 Setting up Social Media Backend...\n');

// Check Node.js version
const nodeVersion = process.version;
const majorVersion = parseInt(nodeVersion.split('.')[0].substring(1));

if (majorVersion < 18) {
    console.error('❌ Node.js 18 or higher is required');
    console.log(`Current version: ${nodeVersion}`);
    console.log('Please upgrade Node.js: https://nodejs.org/');
    process.exit(1);
}

console.log(`✅ Node.js version: ${nodeVersion}`);

// Check if .env file exists
if (!fs.existsSync('.env')) {
    console.log('❌ .env file not found');
    console.log('Please create a .env file based on the provided example');
    process.exit(1);
}

console.log('✅ .env file found');

// Check if dependencies are installed
if (!fs.existsSync('node_modules')) {
    console.log('📦 Installing dependencies...');
    try {
        await execAsync('npm install');
        console.log('✅ Dependencies installed');
    } catch (error) {
        console.error('❌ Failed to install dependencies:', error.message);
        process.exit(1);
    }
} else {
    console.log('✅ Dependencies already installed');
}

// Build the project
console.log('🔨 Building TypeScript...');
try {
    await execAsync('npm run build');
    console.log('✅ Build successful');
} catch (error) {
    console.error('❌ Build failed:', error.message);
    console.log('This might be due to missing environment variables or dependencies');
}

console.log('\n🎉 Setup complete!');
console.log('\n📋 Next steps:');
console.log('1. Make sure PostgreSQL is running');
console.log('2. Create a database: createdb social_media_db');
console.log('3. Update DATABASE_URL in .env file');
console.log('4. Start the server: npm run dev');
console.log('5. Test the API: node test-api.js');

console.log('\n🔗 Useful commands:');
console.log('- npm run dev     # Start development server');
console.log('- npm run build   # Build for production');
console.log('- npm start       # Start production server');
console.log('- node test-api.js # Test the API endpoints');

console.log('\n📚 API Documentation: http://localhost:3000/');
