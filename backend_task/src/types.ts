export interface User {
    id: number;
    username: string;
    email: string;
    password_hash: string;
    display_name?: string;
    bio?: string;
    avatar_url?: string;
    created_at: Date;
    updated_at: Date;
}

export interface UserCreateInput {
    username: string;
    email: string;
    password: string;
    display_name?: string;
    bio?: string;
}

export interface UserUpdateInput {
    display_name?: string;
    bio?: string;
    avatar_url?: string;
}

export interface Post {
    id: number;
    user_id: number;
    content: string;
    media_url?: string;
    media_type?: string;
    created_at: Date;
    updated_at: Date;
    username?: string;
    display_name?: string;
    avatar_url?: string;
}

export interface PostCreateInput {
    content: string;
    media_url?: string;
    media_type?: string;
}

export interface Follow {
    id: number;
    follower_id: number;
    following_id: number;
    created_at: Date;
}

export interface AuthPayload {
    token: string;
    user: Omit<User, 'password_hash'>;
}

export interface JWTPayload {
    userId: number;
    username: string;
    iat?: number;
    exp?: number;
}
