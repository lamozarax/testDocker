FROM ubuntu:16.04
MAINTAINER lamozarax dev@xiaogu-tech.com

RUN apt-get update
RUN apt-get install -y nginx git postgresql postgresql-contrib python3 python3-pip ssh vim

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip

RUN mkdir -p /root/.ssh/
COPY ./deploy/config /root/.ssh/config
COPY ./deploy/known_hosts/ /root/.ssh/known_hosts
COPY ./deploy/lms_deploy.key /root/.ssh/lms_deploy.key
RUN chmod 400 /root/.ssh/lms_deploy.key

ENV SITENAME=xg-tech-xg-test.daoapp.io
RUN mkdir -p ~/sites/$SITENAME/
RUN git clone git@git.oschina.net-lms:xiaogu-tech/laioffer-lms.git ~/sites/$SITENAME/
RUN pip install -r ~/sites/$SITENAME/deploy_tools/requirements/staging.txt


COPY ./www /var/www/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]