FROM node:22-bookworm

ENV LIBVIPS_VERSION=8.15.5

# Install dependencies
# From https://packages.ubuntu.com/oracular/libvips-dev
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    meson \
    gettext \
    gir1.2-vips-8.0 \
    libarchive-dev \
    libcfitsio-dev \
    libcgif-dev \
    libexpat1-dev \
    libfftw3-dev \
    libfontconfig-dev \
    libfreetype-dev \
    libglib2.0-dev \
    libheif-dev \
    libhwy-dev \
    libice-dev \
    libimagequant-dev \
    libjpeg-dev \
    libjxl-dev \
    liblcms2-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libmatio-dev \
    libopenexr-dev \
    libopenslide-dev \
    libpango1.0-dev \
    libpoppler-glib-dev \
    librsvg2-dev \
    libspng-dev \
    libtiff-dev \
    # libsvips42t64 \
    libwebp-dev \
    pkgconf \
    zlib1g-dev \
    libvips-doc \
    libvips-tools \
    nip2

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

# Apt cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

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
VOLUME /output

CMD ["node", "index.js"]
