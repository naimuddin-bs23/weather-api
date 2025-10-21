# Production-ready Dockerfile
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy application code
COPY --chown=nodejs:nodejs . .

# Remove unnecessary files for security and size optimization
RUN rm -rf /tmp/* /var/tmp/* && \
    find /app -name "*.md" -delete && \
    find /app -name "test*" -delete && \
    find /app -name "*.example" -delete

# Switch to non-root user
USER nodejs

# Expose port
EXPOSE 3000

# Health check using Node.js (no curl dependency)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/api/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Start the application
CMD ["node", "server.js"]