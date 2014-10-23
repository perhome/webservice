#!/bin/bash

WS_ROOT_PATH=`dirname $(dirname $(readlink -f $0))`

chown -R www:www-data "$WS_ROOT_PATH"/
chmod -R 444 "$WS_ROOT_PATH"/
chmod -R +X "$WS_ROOT_PATH"/
chmod -R +x "$WS_ROOT_PATH"/bin

chown -R data:www-data "$WS_ROOT_PATH"/data/
chmod -R 600 "$WS_ROOT_PATH"/data/
chmod -R +X "$WS_ROOT_PATH"/data/
chmod -R +w "$WS_ROOT_PATH"/cache

for sh in `ls safe/`
do  
  sh "safe/$sh"; 
done;

chown root:root "$WS_ROOT_PATH"/bin/safe.sh

