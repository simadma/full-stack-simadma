# full-stack-simadma
Full stack web app using FastAPI + Svelte + Tailwind CSS hosted on DigitalOcean.

## Development

### 0. Prerequisites
To get everything working out of the box, we need to have
[**docker compose**](https://docs.docker.com/compose/install/) installed.

### 1. Create .env file on the repo root
For everything to work we must create a `.env` file on the repo root.
For development, we add the following content:

```env
DOMAIN=localhost

# Backend
BACKEND_CORS_ORIGINS=["http://localhost:5173"]

# Frontend
VITE_API_URL=http://localhost:8000

# Docker
DOCKER_IMAGE_BACKEND=backend
DOCKER_IMAGE_FRONTEND=frontend
```

### 2. Run Docker Compose with `watch` enabled
We run the following command:
```bash
docker compose watch
```

We can now open the browser and view the **frontend** on http://localhost:5173.

The OpenAPI documentation for the **backend** can also be visited on
http://localhost:8000/docs.
