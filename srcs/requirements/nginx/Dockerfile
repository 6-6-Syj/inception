FROM alpine:3.22.3

WORKDIR /app

COPY ./conf/nginx.conf 	/etc/nginx/http.d/nginx.conf
# COPY ./conf/index.html 	/var/www/html/index.html
COPY ./conf/404.html 	/var/www/html/404.html

COPY --chmod=755 tools/init.sh /usr/local/bin/init.sh

RUN apk add --no-cache \
    nginx   \
    openssl &&	\
    rm -rf /etc/nginx/http.d/default.conf

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/init.sh"]