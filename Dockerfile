FROM quay.io/mtneug/opencv

ENV TRACKHD_VERSION=ca2236ced3c9c3726eb5707a1edd50eee8df92da
ENV TRACKHD_ARCHIVE=https://github.com/LectureTracking/trackhd/archive/${TRACKHD_VERSION}.tar.gz

RUN apk add --no-cache --virtual .run-deps \
      ffmpeg libxcb x265 x264 libva zlib libbz2 libvdpau xz \
 && apk add --no-cache --virtual .build-deps \
      binutils-gold cmake make gcc g++ git curl \
      linux-headers ffmpeg-dev libxcb-dev x265-dev x264-dev \
      libvpx-dev libva-dev zlib-dev bzip2-dev libvdpau-dev xz-dev \
  \
 && mkdir /tmp/trackhd \
 && curl -sSL "${TRACKHD_ARCHIVE}" | tar -xz --strip 1 -C /tmp/trackhd \
 && mkdir /tmp/trackhd/build && cd /tmp/trackhd/build \
 && cmake -D CMAKE_BUILD_TYPE=RELEASE \
          ../source/ \
 && make -j$(nproc) \
 && make install \
 && cd ../cropvid \
 && ./build.sh \
 && cp cropvid /usr/local/bin/ \
 && apk del --no-cache .build-deps \
 && rm -rf /tmp/trackhd
