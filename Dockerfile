FROM imoize/alpine-s6:3.17

ARG TARGETARCH
ARG TARGETVARIANT

# install packages
RUN \
    echo "**** install packages ****" && \
    apk add --no-cache \
    git \
    nano \
    openssl \
    logrotate \
    apache2-utils \
    nginx \
    nginx-mod-http-brotli \
    nginx-mod-http-cache-purge \
    nginx-mod-http-dav-ext \
    nginx-mod-http-echo \
    nginx-mod-http-fancyindex \
    nginx-mod-http-geoip \
    nginx-mod-http-geoip2 \
    nginx-mod-http-headers-more \
    nginx-mod-http-image-filter \
    nginx-mod-http-nchan \
    nginx-mod-http-perl \
    nginx-mod-http-redis2 \
    nginx-mod-http-set-misc \
    nginx-mod-http-upload-progress \
    nginx-mod-http-xslt-filter \
    nginx-mod-mail \
    nginx-mod-rtmp \
    nginx-mod-stream \
    nginx-mod-stream-geoip \
    nginx-mod-stream-geoip2 \
    nginx-vim && \
    echo "**** set nginx ****" && \
    echo 'fastcgi_param  HTTP_PROXY         "";' >> /etc/nginx/fastcgi_params && \
    echo 'fastcgi_param  PATH_INFO          $fastcgi_path_info;' >> /etc/nginx/fastcgi_params && \
    echo 'fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;' >> /etc/nginx/fastcgi_params && \
    echo 'fastcgi_param  SERVER_NAME        $host;' >> /etc/nginx/fastcgi_params && \
    rm -f /etc/nginx/http.d/default.conf && \
    echo "**** fix logrotate ****" && \
    sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
    sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' /etc/periodic/daily/logrotate && \
    echo '*** clean up ***' && \
    rm -rf \
    /tmp/* \
    /var/cache/apk/*

# add local files
COPY src/ /

# expose ports
EXPOSE 80 443
