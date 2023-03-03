FROM alpine:${ALPINE_VERSION} as build-stage

ARG ALPINE_VERSION="3.17"
ARG TARGETARCH

#set packages for rootfs build
ENV PACKAGES=alpine-baselayout,\
alpine-keys,\
apk-tools,\
busybox,\
libc-utils,\
xz

# add required packages
RUN \
    apk add --no-cache \
    bash \
    curl \
    patch \
    tar \
    tzdata \
    xz

# fetch builder script from gliderlabs
COPY mkimage-alpine.bash /
RUN \
    chmod +x /mkimage-alpine.bash && \
    ./mkimage-alpine.bash && \
    mkdir /build-out && \
    tar xf \
    /rootfs.tar.xz -C \
    /build-out && \
    sed -i -e 's/^root::/root:!:/' //build-out/etc/shadow

# build images per arch 
FROM alpine:${ALPINE_VERSION} AS base-amd64
ARG S6_OVERLAY_ARCH=x86_64
COPY --from=build-stage /build-out/ /

FROM alpine:${ALPINE_VERSION} AS base-arm64
ARG S6_OVERLAY_ARCH=aarch64
COPY --from=build-stage /build-out/ /

FROM alpine:${ALPINE_VERSION} AS base-armv7
ARG S6_OVERLAY_ARCH=armhf
COPY --from=build-stage /build-out/ /

# s6-stage
FROM base-${TARGETARCH}${TARGETVARIANT} as s6-stage

# set version for s6 overlay
ARG S6_OVERLAY_VERSION="3.1.4.1"

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C /build-out -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz /tmp
RUN tar -C /build-out -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz

# runtime stage
FROM scratch
COPY --from=s6-stage /build-out/ /

LABEL maintainer="brilliant"

ENV PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
    HOME="/root" \
    TERM="xterm" \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME="0" \
    S6_VERBOSITY="2"

RUN \
    echo "**** install runtime packages ****" && \
    apk add --no-cache \
    alpine-release \
    bash \
    ca-certificates \
    coreutils \
    curl \
    jq \
    procps \
    shadow \
    tzdata && \
    echo "**** create user and make folders ****" && \
    groupmod -g 1000 users && \
    useradd -u 911 -U -d /data -s /bin/false disty && \
    usermod -G users disty && \
    mkdir -p \
    /app \
    /data \
    /defaults && \
    echo "**** cleanup ****" && \
    rm -rf \
    /tmp/* \
    /var/cache/apk/*


# add local files
COPY src/ /

ENTRYPOINT ["/init"]