FROM alpine:3.22.3

WORKDIR /app

COPY ./conf/nginx.conf 	/etc/nginx/http.d/nginx.conf
COPY ./conf/404.html 	/var/www/html/404.html

COPY --chmod=755 tools/init.sh /usr/local/bin/init.sh

RUN apk add --no-cache  \
    curl                \
    nginx               \
    openssl &&          \
    rm -rf /etc/nginx/http.d/default.conf

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/init.sh"]