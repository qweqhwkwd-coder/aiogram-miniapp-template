# Mini Apps

## Overview
This template ships with a FastAPI backend for Telegram Mini Apps and a React frontend in `webapp/`.
The bot exposes a `/profile` command that opens the Mini App with the user profile page.

## Backend API
Endpoints are exposed under `/api`:
- `GET /api/health`
- `POST /api/auth/validate`
- `GET /api/users/me`
- `PATCH /api/users/me`
- `GET /api/users/{telegram_id}`

Auth uses Telegram WebApp `initData` in the Authorization header:
```
Authorization: Bearer <initData>
```

## Configuration
Add these to `.env`:
```
# API
API__HOST=0.0.0.0
API__PORT=8000
API__DEBUG=false

# WebApp
WEBAPP__URL=https://your-webapp-domain.com
```

`WEBAPP__URL` is used to build the WebApp button URL in `/profile`.

## Run locally
```
make run
make webapp-install
make webapp-dev
```

By default the WebApp dev server proxies `/api` to `http://localhost:8000`.

## Webhook mode
When `TG__WEBHOOK_USE=true`, the webhook FastAPI app also serves the Mini App API.
Make sure your webhook port is reachable and matches your reverse proxy setup.
