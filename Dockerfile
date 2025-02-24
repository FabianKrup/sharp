FROM node-libvips:22-bookworm

WORKDIR /app

# Copy application files
COPY . .
COPY package*.json ./

# Install dependencies and rebuild sharp
RUN npm install -g npm@~11.1.0
RUN npm install
# rebuild sharp in postinstall

# Create output directory and declare volume
RUN mkdir -p /app/output
VOLUME /app/output

CMD ["node", "index.js"]
