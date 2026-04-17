# -------- Stage 1: Build --------
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies first (better caching)
COPY backend/package*.json ./
RUN npm install

# Copy source code
COPY backend/ .

# -------- Stage 2: Production --------
FROM node:18-alpine

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app /app

# Remove dev dependencies
RUN npm prune --production

# Expose port
EXPOSE 5000

# Start app
CMD ["node", "server.js"]