FROM ubuntu:16.04
MAINTAINER lamozarax dev@xiaogu-tech.com

RUN apt-get update
RUN apt-get install -y nginx git postgresql postgresql-contrib python3 python3-pip ssh

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip

RUN mkdir -p /root/.ssh/
COPY ./deploy/lms_deploy.key /root/.ssh/lms_deploy.key


COPY ./www /var/www/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]