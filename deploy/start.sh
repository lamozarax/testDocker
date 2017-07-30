#!/bin/bash

echo 'start unicorn'
cd /sites/$SITENAME/source/
gunicorn --bind unix:/tmp/$SITENAME.socket config.wsgi:application

echo 'init db'
/etc/init.d/postgresql start
sh /sites/$SITENAME/misc/cleanup.sh

echo 'start nginx'
/etc/init.d/nginx start
