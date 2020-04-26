FROM alpine:3.11

ENV OPENCV https://github.com/opencv/opencv/archive/4.3.0.tar.gz
ENV OPENCV_VER 4.3.0
ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++

RUN apk add -U --no-cache --virtual=.build \
    linux-headers musl libxml2-dev libxslt-dev libffi-dev g++ \
    musl-dev openssl-dev jpeg-dev zlib-dev freetype-dev \
    build-base lcms2-dev openjpeg-dev python3-dev make cmake clang \
    clang-dev ninja curl py3-pip \
    && apk add --no-cache zlib jpeg libjpeg freetype openjpeg openjpeg-tools python3 libstdc++ \
    && pip3 install --no-cache-dir numpy==1.18.3 \
    && mkdir /build && cd /build \
    && curl -L $OPENCV | tar xz \
    && cd opencv-$OPENCV_VER \
    && mkdir build \
    && cd build \
    && cmake -G Ninja \
          -D CMAKE_BUILD_TYPE=RELEASE \
          -D WITH_FFMPEG=NO \
          -D WITH_IPP=NO \
          -D WITH_OPENEXR=NO .. \
          -D CMAKE_INSTALL_PREFIX=/usr \
    && ninja && ninja install \
    && apk del .build \
    && cd / && rm -r /build
