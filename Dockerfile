# ── Stage 1: Builder ──────────────────────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Copy only dependency manifests first (layer-cache optimisation)
COPY package*.json ./

# Install ALL deps (including devDeps) so tests can run during build if needed
RUN npm ci --omit=dev

# ── Stage 2: Production image ─────────────────────────────────────────────────
FROM node:20-alpine AS production

# Security: run as non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy production node_modules from builder stage
COPY --from=builder /app/node_modules ./node_modules

# Copy application source
COPY app.js ./
COPY public/ ./public/

# Set ownership to non-root user
RUN chown -R appuser:appgroup /app
USER appuser

# Expose application port
EXPOSE 3000

# Healthcheck — Docker will mark the container unhealthy if the app stops responding
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/ || exit 1

# Runtime environment
ENV NODE_ENV=production \
    PORT=3000

CMD ["node", "app.js"]