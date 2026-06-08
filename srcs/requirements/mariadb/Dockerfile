FROM alpine:3.22.3

# Installing mariadb will creates 2 users: root and mysql. 
# By default these users will only be accessible if you are logged in as the corresponding system user.
WORKDIR /app

COPY --chmod=755 tools/init.sh /usr/local/bin/init.sh
COPY --chmod=755 tools/healthcheck.sh /usr/local/bin/healthcheck.sh

# The datadir located at /var/lib/mysql must be owned by the mysql user and group.
#  chown -> "change owner"
RUN apk add --no-cache mariadb mariadb-client && rm -rf /var/lib/mysql  \
    && mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql   \
    && mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
# sqld for daemon -> background by default

# TODO: expose ?
EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init.sh"]
# `ENTRYPOINT ["init.sh"]` → init.sh est PID 1 et reçoit SIGTERM → arrêt propre.   

# If there is no script to run, we prefere using this:
    # CMD ["mariadb", "daemon off;"]