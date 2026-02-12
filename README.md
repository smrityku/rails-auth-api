# Rails JWT Authentication API

A secure, production-style REST API built with Ruby on Rails featuring JWT authentication, refresh token rotation, role-based authorization, and OTP verification.

---

## Features

* JWT Authentication (short-lived access tokens)
* Refresh Token mechanism (7-day validity)
* Secure Logout (token invalidation)
* Role-Based Authorization (User / Admin)
* OTP Verification with expiration logic
* Protected endpoints using middleware
* Proper HTTP status handling (401 / 403)

---

## Tech Stack

* Ruby on Rails (API mode)
* PostgreSQL
* JWT
* BCrypt (`has_secure_password`)
* Figaro (environment variables)

---

## Authentication Flow

1. User signs up
2. OTP is generated and verified
3. Login returns:

    * Access Token (15 minutes)
    * Refresh Token (7 days)
4. Access token used for protected routes
5. Refresh endpoint issues new access token
6. Logout invalidates refresh token

---

## API Endpoints

| Method | Endpoint         | Description                |
| ------ | ---------------- | -------------------------- |
| POST   | /signup          | Register new user          |
| POST   | /login           | Authenticate user          |
| POST   | /send_otp        | Generate OTP               |
| POST   | /verify_otp      | Verify OTP                 |
| POST   | /refresh         | Refresh access token       |
| POST   | /logout          | Logout user                |
| GET    | /profile         | Authenticated user profile |
| GET    | /admin/dashboard | Admin-only endpoint        |

---

## Authorization Header Format

```
Authorization: Bearer <access_token>
```

---

## Setup Instructions

### 1️⃣ Clone Repository

```
git clone <your-repo-url>
cd <project-name>
```

### 2️⃣ Install Dependencies

```
bundle install
```

### 3️⃣ Setup Environment Variables

Create:

```
config/application.yml
```

Add:

```
JWT_SECRET_KEY=your_secret_key_here
```

### 4️⃣ Setup Database

```
rails db:create
rails db:migrate
```

### 5️⃣ Start Server

```
rails s
```

Visit:

```
http://localhost:3000
```

---

## Testing with Postman

1. Register user
2. Verify OTP
3. Login → receive tokens
4. Use access token for protected routes
5. Refresh when expired
6. Logout to invalidate session

---

## Architecture Highlights

* Service-based JWT handling
* Enum-based role management
* Middleware-driven authorization
* Clean RESTful controller structure
* Scalable token management design

---

## Future Improvements

* Email/SMS OTP delivery integration
* Token blacklisting table
* Rate limiting
* Docker containerization
* Deployment to AWS / Render / Heroku

---