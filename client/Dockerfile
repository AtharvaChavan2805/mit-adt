# Stage 1: Build
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files for layer caching
COPY package*.json ./

# Install dependencies
RUN npm install --production=false

# Copy application source
COPY . .

# Build optimized production bundle
RUN npm run build

# Stage 2: Serve (Minimal production image)
FROM nginx:alpine

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/health || exit 1

# Copy only built artifacts from build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx config for SPA routing
RUN echo 'server { listen 80; location / { root /usr/share/nginx/html; try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

EXPOSE 80

# Use exec form to handle signals properly
CMD ["nginx", "-g", "daemon off;"]