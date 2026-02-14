# URL Shortener API Documentation

## Base URL
```
http://localhost:8001
```

## Authentication
This API uses JWT (JSON Web Token) for authentication. Include the token in requests using either:
- **Header**: `Authorization: Bearer <token>`
- **Cookie**: `token=<token>`

---

## Table of Contents
1. [Authentication Endpoints](#authentication-endpoints)
2. [URL Management Endpoints](#url-management-endpoints)
3. [Utility Endpoints](#utility-endpoints)
4. [Error Responses](#error-responses)

---

## Authentication Endpoints

### 1. User Signup
Create a new user account.

**Endpoint**: `POST /user/signup`

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "password": "password123",
  "confirmPassword": "password123"
}
```

**Validation Rules**:
- `name`: Required, string
- `email`: Required, valid email format
- `phone`: Required, valid phone number
- `password`: Required, minimum 6 characters
- `confirmPassword`: Required, must match password

**Success Response** (201):
```json
{
  "success": true,
  "message": "User created successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "690e116c1e9e3f36f8790571",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

**Error Responses**:
- `400`: Missing fields, invalid email, password too short, email already registered
- `500`: Internal server error

---

### 2. User Login
Authenticate and receive a JWT token.

**Endpoint**: `POST /user/login`

**Request Body**:
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Success Response** (200):
```json
{
  "success": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "690e116c1e9e3f36f8790571",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

**Error Responses**:
- `400`: Missing fields, invalid email format
- `401`: Invalid email or password
- `500`: Internal server error

---

### 3. User Logout
Logout and clear authentication token.

**Endpoint**: `POST /user/logout`

**Authentication**: Required

**Success Response** (200):
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

**Error Responses**:
- `401`: No token provided or invalid token

---

## URL Management Endpoints

### 4. Create Short URL
Generate a short URL for a given long URL.

**Endpoint**: `POST /api/url`

**Authentication**: Required

**Request Body**:
```json
{
  "url": "https://www.example.com/very/long/url",
  "customShortId": "mylink"  // Optional
}
```

**Validation Rules**:
- `url`: Required, valid URL with protocol (http:// or https://)
- `customShortId`: Optional, alphanumeric with hyphens/underscores only

**Success Response** (201):
```json
{
  "success": true,
  "message": "Short URL created successfully",
  "data": {
    "shortId": "46Ev-qvw",
    "originalUrl": "https://www.example.com/very/long/url",
    "shortUrl": "http://localhost:8001/url/46Ev-qvw",
    "createdAt": "2025-11-07T15:34:22.485Z"
  }
}
```

**Error Responses**:
- `400`: Missing URL, invalid URL format, custom ID already taken, invalid custom ID format
- `401`: Authentication required
- `500`: Internal server error

---

### 5. Get All URLs
Retrieve all short URLs created by the authenticated user.

**Endpoint**: `GET /api/url`

**Authentication**: Required

**Success Response** (200):
```json
{
  "success": true,
  "count": 2,
  "data": [
    {
      "shortId": "46Ev-qvw",
      "originalUrl": "https://www.google.com",
      "shortUrl": "http://localhost:8001/url/46Ev-qvw",
      "clicks": 5,
      "createdAt": "2025-11-07T15:34:22.485Z"
    },
    {
      "shortId": "abc123",
      "originalUrl": "https://www.example.com",
      "shortUrl": "http://localhost:8001/url/abc123",
      "clicks": 12,
      "createdAt": "2025-11-06T10:20:15.123Z"
    }
  ]
}
```

**Error Responses**:
- `401`: Authentication required
- `500`: Internal server error

---

### 6. Get URL Analytics
Get detailed analytics for a specific short URL.

**Endpoint**: `GET /api/url/analytics/:shortId`

**Authentication**: Required

**URL Parameters**:
- `shortId`: The short URL identifier

**Success Response** (200):
```json
{
  "success": true,
  "data": {
    "shortId": "46Ev-qvw",
    "originalUrl": "https://www.google.com",
    "totalClicks": 3,
    "createdAt": "2025-11-07T15:34:22.485Z",
    "analytics": [
      {
        "timestamp": 1762529682554,
        "_id": "690e11921e9e3f36f8790576"
      },
      {
        "timestamp": 1762529700123,
        "_id": "690e11a41e9e3f36f8790577"
      }
    ]
  }
}
```

**Error Responses**:
- `401`: Authentication required
- `403`: Access denied (you don't own this URL)
- `404`: Short URL not found
- `500`: Internal server error

---

### 7. Delete Short URL
Delete a short URL.

**Endpoint**: `DELETE /api/url/:shortId`

**Authentication**: Required

**URL Parameters**:
- `shortId`: The short URL identifier

**Success Response** (200):
```json
{
  "success": true,
  "message": "Short URL deleted successfully"
}
```

**Error Responses**:
- `401`: Authentication required
- `403`: Access denied (you don't own this URL)
- `404`: Short URL not found
- `500`: Internal server error

---

### 8. Redirect to Original URL
Redirect to the original URL (public endpoint).

**Endpoint**: `GET /url/:shortId`

**Authentication**: Not required (public)

**URL Parameters**:
- `shortId`: The short URL identifier

**Success Response** (302):
- Redirects to the original URL
- Increments visit counter

**Error Responses**:
- `404`: Short URL not found
- `500`: Internal server error

---

## Utility Endpoints

### 9. Health Check
Check if the API is running.

**Endpoint**: `GET /health`

**Authentication**: Not required

**Success Response** (200):
```json
{
  "status": "ok",
  "timestamp": "2025-11-07T15:31:22.249Z"
}
```

---

## Error Responses

All error responses follow this format:

```json
{
  "error": "Error message describing what went wrong"
}
```

### Common HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 201 | Created |
| 302 | Redirect |
| 400 | Bad Request (validation error) |
| 401 | Unauthorized (authentication required) |
| 403 | Forbidden (insufficient permissions) |
| 404 | Not Found |
| 429 | Too Many Requests (rate limit exceeded) |
| 500 | Internal Server Error |

---

## Rate Limiting

The API implements rate limiting to prevent abuse:

- **General API endpoints**: 100 requests per 15 minutes per IP
- **Authentication endpoints** (`/user/login`, `/user/signup`): 5 requests per 15 minutes per IP

When rate limit is exceeded:
```json
{
  "error": "Too many requests, please try again later."
}
```

---

## Example Usage

### Using cURL

#### 1. Signup
```bash
curl -X POST http://localhost:8001/user/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }'
```

#### 2. Login
```bash
curl -X POST http://localhost:8001/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

#### 3. Create Short URL
```bash
curl -X POST http://localhost:8001/api/url \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "url": "https://www.example.com"
  }'
```

#### 4. Get All URLs
```bash
curl -X GET http://localhost:8001/api/url \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### 5. Get Analytics
```bash
curl -X GET http://localhost:8001/api/url/analytics/46Ev-qvw \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### 6. Delete URL
```bash
curl -X DELETE http://localhost:8001/api/url/46Ev-qvw \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

### Using JavaScript (Fetch API)

```javascript
// Signup
const signup = async () => {
  const response = await fetch('http://localhost:8001/user/signup', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      name: 'John Doe',
      email: 'john@example.com',
      password: 'password123'
    })
  });
  const data = await response.json();
  return data.token;
};

// Create Short URL
const createShortUrl = async (token, url) => {
  const response = await fetch('http://localhost:8001/api/url', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({ url })
  });
  return await response.json();
};

// Get All URLs
const getAllUrls = async (token) => {
  const response = await fetch('http://localhost:8001/api/url', {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  return await response.json();
};
```

---

## Security Features

1. **JWT Authentication**: Secure token-based authentication
2. **Password Hashing**: Passwords hashed using bcrypt (10 rounds)
3. **Rate Limiting**: Protection against brute force attacks
4. **Input Validation**: All inputs validated before processing
5. **CORS Enabled**: Cross-origin requests supported
6. **HTTP-Only Cookies**: Tokens stored in HTTP-only cookies for web clients
7. **URL Validation**: Only valid URLs with protocols accepted

---

## Environment Variables

Required environment variables (see `.env.example`):

```env
PORT=8001
NODE_ENV=development
MONGODB_URI=mongodb://localhost:27017/short-url
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=7d
BASE_URL=http://localhost:8001
```

---

## Notes

- All timestamps are in Unix milliseconds
- JWT tokens expire after 7 days (configurable)
- Short IDs are 8 characters by default (using nanoid)
- Custom short IDs can be any length but must be alphanumeric with hyphens/underscores
- The redirect endpoint (`/url/:shortId`) is public and doesn't require authentication
- All other endpoints require authentication via JWT token
