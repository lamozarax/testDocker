#!/bin/bash

echo 'init db'
/etc/init.d/postgresql start
sh /sites/$SITENAME/misc/cleanup.sh

echo 'start nginx'
/etc/init.d/nginx start

echo 'start gunicorn'
cd /sites/$SITENAME/source/
gunicorn --bind unix:/tmp/$SITENAME.socket config.wsgi:application --access-logfile /tmp/gunicorn.access.log --error-logfile /tmp/gunicorn.error.log
