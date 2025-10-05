# =========================================
# Stage 1: Build the Svelte Application
# =========================================
FROM node:24.8.0-alpine AS builder

WORKDIR /app

RUN npm install -g pnpm@10.17.1

COPY package.json pnpm-lock.yaml /app/

# Install dependencies using pnpm
RUN --mount=type=cache,target=/root/.pnpm-store \
    pnpm install --frozen-lockfile

# Copy all source code
COPY . .

# Build the Svelte app (Tailwind integrated)
ARG VITE_API_URL=${VITE_API_URL}
RUN pnpm run build

# =========================================
# Stage 2: Serve Static Files with Nginx
# =========================================
FROM nginxinc/nginx-unprivileged:stable-alpine3.21-slim AS runner

# Use non-root user
USER nginx

# Expose HTTP port
EXPOSE 80

# Copy built static files from builder
COPY --chown=nginx:nginx --from=builder /app/build /usr/share/nginx/html

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY nginx-backend-not-found.conf /etc/nginx/extra-conf.d/backend-not-found.conf
