#!/bin/sh

chmod +x /mkimage-alpine.bash && \
/mkimage-alpine.bash && \
mkdir /build-out && \
tar xf /rootfs.tar.xz -C /build-out && \
sed -i -e 's/^root::/root:!:/' //build-out/etc/shadow