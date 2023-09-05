# syntax = docker/dockerfile:1

# Adjust NODE_VERSION as desired
ARG NODE_VERSION=16.20.2
FROM node:${NODE_VERSION}-slim as base

LABEL fly_launch_runtime="Node.js"

# Node.js app lives here
WORKDIR /app

# Set production environment
ENV NODE_ENV="production"

# Throw-away build stage to reduce the size of the final image
FROM base as build

# Install packages needed to build node modules
RUN apt-get update -qq && \
    apt-get install -y build-essential pkg-config python

# Install node modules with dev dependencies (for building)
COPY --link package-lock.json package.json ./
RUN npm ci

# Copy application code
COPY --link . .

# Build application
RUN npm run build

# Final production stage
FROM base

# Copy built application from the build stage
COPY --from=build /app /app

# Install only production dependencies (without dev dependencies)
RUN npm ci --only=production

# Start the server by default, this can be overwritten at runtime
EXPOSE 5000
CMD [ "npm", "run", "start" ]
