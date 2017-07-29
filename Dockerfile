FROM ubuntu:16.04
MAINTAINER lamozarax dev@xiaogu-tech.com
RUN apt-get update
RUN apt-get install -y nginx
COPY ./www /var/www/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]