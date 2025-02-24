FROM oven/bun:1.2-debian

ENV LIBVIPS_VERSION=8.15.5

# Install dependencies
# From https://packages.debian.org/bullseye/libvips-dev
RUN apt-get update && apt-get install -y \
    build-essential \
    meson \
    wget
RUN apt-get install -y \
    fftw3-dev \
    gettext \
    gir1.2-vips-8.0 \
    libcfitsio-dev \
    libexpat1-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libgif-dev \
    libglib2.0-dev \
    libgsf-1-dev \
    libheif-dev \
    libice-dev \
    libimagequant-dev \
    libjpeg-dev \
    liblcms2-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmatio-dev \
    libopenexr-dev \
    libopenslide-dev \
    liborc-0.4-dev \
    libpango1.0-dev \
    libpng-dev \
    libpoppler-glib-dev \
    librsvg2-dev \
    libtiff-dev \
    libvips42 \
    libwebp-dev \
    pkg-config \
    zlib1g-dev \
    libvips-doc \
    libvips-tools \
    nip2

# Build and install libvips
RUN wget -O /tmp/libvips.tar.gz https://github.com/libvips/libvips/releases/download/v$LIBVIPS_VERSION/vips-$LIBVIPS_VERSION.tar.xz && \
    mkdir /libvips && cd /libvips && \
    tar xf /tmp/libvips.tar.gz --strip-components=1 && \
    meson setup build -Dheif=enabled && \
    cd build && \
    meson compile && \
    meson test && \
    meson install && \
    ldconfig && \
    cd .. && \
    rm -rf /libvips /tmp/libvips.tar.gz

# Apt cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
