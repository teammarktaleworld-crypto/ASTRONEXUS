# Unified Wrapper (Backend) - Render Deployment Guide

This backend now exposes **one base URL** for all external services (Birth Chart, Horoscope, MATI Chat).

## Wrapper Base URL

After deploying backend on Render:

- Base URL: `https://<your-backend>.onrender.com/api/wrapper`

## Wrapper Endpoints

- `GET /api/wrapper/base`
  - Returns computed backend base URL and wrapper base URL.

- `GET /api/wrapper/services`
  - Returns all wrapper endpoints and upstream URLs.

- `POST /api/wrapper/birthchart`
  - Proxies to Python birth chart service endpoint: `/api/v1/chart`

- `GET /api/wrapper/horoscope?sign=aries&type=daily&day=TODAY`
  - Proxies to horoscope service endpoint: `/api/horoscope`

- `POST /api/wrapper/mati/chat`
  - Proxies to MATI service endpoint: `/api/chat`

---

## Required Environment Variables on Render (Backend Service)

Set these in Render dashboard for backend:

- `PY_BIRTHCHART_BASE_URL`
- `PY_HOROSCOPE_BASE_URL`
- `PY_MATI_BASE_URL`

Example:

```env
PY_BIRTHCHART_BASE_URL=https://your-birthchart-service.onrender.com
PY_HOROSCOPE_BASE_URL=https://your-horoscope-service.onrender.com
PY_MATI_BASE_URL=https://your-mati-service.onrender.com
```

> Keep values without trailing `/` when possible.

---

## Frontend Usage (Single Base URL)

Use only one backend base URL in frontend:

```text
https://<your-backend>.onrender.com/api/wrapper
```

Then call:

- `${BASE_URL}/birthchart`
- `${BASE_URL}/horoscope?...`
- `${BASE_URL}/mati/chat`

This keeps the same URL pattern in local and production.

---

## Local Development Example

If backend runs locally on port `8001`:

- `http://localhost:8001/api/wrapper/base`
- `http://localhost:8001/api/wrapper/services`

Ensure local env values:

```env
PY_BIRTHCHART_BASE_URL=http://localhost:8000
PY_HOROSCOPE_BASE_URL=http://localhost:4000
PY_MATI_BASE_URL=http://localhost:3000
```
