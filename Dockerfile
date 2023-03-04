FROM ghcr.io/imoize/alpine-s6:3.17

ARG TARGETARCH
ARG TARGETVARIANT
ARG NGINX_VERSION="1.22.1"

# install packages
RUN \
    echo "**** install packages ****" && \
    apk add --no-cache \
    curl \
    logrotate \
    nano \
    openssl \
    nginx==${NGINX_VERSION} \
    nginx-mod-http-brotli==${NGINX_VERSION} \
    nginx-mod-http-cache-purge==${NGINX_VERSION} \
    nginx-mod-http-dav-ext==${NGINX_VERSION} \
    nginx-mod-http-echo==${NGINX_VERSION} \
    nginx-mod-http-fancyindex==${NGINX_VERSION} \
    nginx-mod-http-geoip==${NGINX_VERSION} \
    nginx-mod-http-geoip2==${NGINX_VERSION} \
    nginx-mod-http-headers-more==${NGINX_VERSION} \
    nginx-mod-http-image-filter==${NGINX_VERSION} \
    nginx-mod-http-nchan==${NGINX_VERSION} \
    nginx-mod-http-perl==${NGINX_VERSION} \
    nginx-mod-http-redis2==${NGINX_VERSION} \
    nginx-mod-http-set-misc==${NGINX_VERSION} \
    nginx-mod-http-upload-progress==${NGINX_VERSION} \
    nginx-mod-http-xslt-filter==${NGINX_VERSION} \
    nginx-mod-mail==${NGINX_VERSION} \
    nginx-mod-rtmp==${NGINX_VERSION} \
    nginx-mod-stream==${NGINX_VERSION} \
    nginx-mod-stream-geoip==${NGINX_VERSION} \
    nginx-mod-stream-geoip2==${NGINX_VERSION} \
    nginx-vim==${NGINX_VERSION} && \
    echo "**** set nginx ****" && \
    echo 'fastcgi_param  HTTP_PROXY         "";' >> /etc/nginx/fastcgi_params && \
    echo 'fastcgi_param  PATH_INFO          $fastcgi_path_info;' >> /etc/nginx/fastcgi_params && \
    echo 'fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;' >> /etc/nginx/fastcgi_params && \
    echo 'fastcgi_param  SERVER_NAME        $host;' >> /etc/nginx/fastcgi_params && \
    rm -f /etc/nginx/http.d/default.conf && \
    echo "**** fix logrotate ****" && \
    sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
    sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /defaults/log/logrotate.status#g' /etc/periodic/daily/logrotate && \
    echo '*** clean up ***' && \
    rm -rf \
    /tmp/* \
    /var/cache/apk/*

# add local files
COPY src/ /

# expose ports
EXPOSE 80 443
