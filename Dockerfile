FROM oven/bun-libvips:1.2-debian

WORKDIR /app

# Copy application files
COPY . .
COPY package*.json ./

# Install node dependencies
RUN bun install --no-cache

# Create output directory and declare volume
RUN mkdir -p /app/output
VOLUME /app/output

CMD ["bun", "index.js"]
