FROM ubuntu:16.04
MAINTAINER lamozarax dev@xiaogu-tech.com

RUN apt-get update
RUN apt-get install -y nginx git postgresql postgresql-contrib python3 python3-pip
RUN pip3 install --user virtualenvwrapper

COPY ./www /var/www/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]