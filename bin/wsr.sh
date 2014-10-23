#!/bin/bash

WS_ROOT_PATH=`dirname $(dirname $(readlink -f $0))`

USER="data"
NGINX_BIN="${WS_ROOT_PATH}/bin/nginx"
PHP_BIN="${WS_ROOT_PATH}/bin/php-fpm"
PG_BIN="${WS_ROOT_PATH}/bin/pg_ctl"
SSDB_BIN="${WS_ROOT_PATH}/bin/ssdb-server"
THTTPD_BIN="${WS_ROOT_PATH}/bin/thttpd"
MYSQL_BIN="${WS_ROOT_PATH}/bin/mysqld_safe"

while getopts ":hMmsntdpr:" opt
  do
  case "$opt" in
    "n")
      echo "$NGINX_BIN  -c ${WS_ROOT_PATH}/config/nginx/nginx.conf"
      $NGINX_BIN  -c ${WS_ROOT_PATH}/config/nginx/nginx.conf  > /dev/null 2>&1 &
      ;;
   "s")
      echo "$SSDB_BIN -d ${WS_ROOT_PATH}/config/ssdb/main.conf"
      su -c "$SSDB_BIN -d ${WS_ROOT_PATH}/config/ssdb/main.conf" $USER > /dev/null 2>&1 &
      ;;
   "d")
      echo "su -c \"$PG_BIN -D ${WS_ROOT_PATH}/data/postgres/ start\" $USER"
      su -c "$PG_BIN -D ${WS_ROOT_PATH}/data/postgres/ start" $USER > /dev/null 2>&1 &
      ;;
   "p")
      echo "$PHP_BIN -c ${WS_ROOT_PATH}/config/php/php.ini -y ${WS_ROOT_PATH}/config/php/php-fpm.conf"
      $PHP_BIN -c ${WS_ROOT_PATH}/config/php/php.ini -y ${WS_ROOT_PATH}/config/php/php-fpm.conf > /dev/null 2>&1 &
      ;;
   "t")
      echo "$THTTPD_BIN -C ${WS_ROOT_PATH}/config/thttpd.ini"
      $THTTPD_BIN -C ${WS_ROOT_PATH}/config/thttpd.ini > /dev/null 2>&1 &
      ;;
    "m")
      echo "$MYSQL_BIN --defaults-file=${WS_ROOT_PATH}/config/mysql.cnf"
      $MYSQL_BIN --defaults-file=${WS_ROOT_PATH}/config/mysql.cnf > /dev/null 2>&1 &
      ;;
   "r")
      if [ "$OPTARG" == "nginx" ]; then
        echo "$NGINX_BIN -s reload"
        $NGINX_BIN -s reload
      fi
      
      if [ "$OPTARG" == "php" ]; then
        kill `cat /var/run/php-fpm.pid` > /dev/null
        $PHP_FPM_BIN -c ${WS_ROOT_PATH}/config/php/php.ini -y ${WS_ROOT_PATH}/config/php/php-fpm.conf
      fi
      ;;
    *)
      echo "Unknown error while processing options"
      ;;
  esac
done
