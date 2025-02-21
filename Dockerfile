FROM node:22-bullseye

ENV LIBVIPS_VERSION=8.15.5

RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    pkg-config \
    libglib2.0-dev \
    libexpat1-dev \
    meson \
    libjpeg62-turbo-dev \
    libexif-dev \
    librsvg2-dev \
    libtiff-dev \
    libfftw3-dev \
    liblcms2-dev \
    libpng-dev \
    libimagequant-dev \
    libwebp-dev \
    libheif-dev 

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

# Set environment variables for libvips
ENV PATH="/usr/local/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

WORKDIR /app

# Copy application files
COPY . .
COPY package*.json ./

# Set Sharp to use global libvips
ENV SHARP_FORCE_GLOBAL_LIBVIPS=1
RUN npm install

# Create output directory and set permissions
RUN mkdir -p /output && \
    chmod 777 /output

# Test vips installation
COPY image.heif .
RUN vips copy image.heif /output/test-output2.png

VOLUME /output

CMD ["node", "index.js"]
