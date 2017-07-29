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

ENV SITENAME=xg-tech-lms.daoapp.io
RUN mkdir -p ~/sites/$SITENAME/
RUN git clone git@git.oschina.net-lms:xiaogu-tech/laioffer-lms.git ~/sites/$SITENAME/
RUN pip install -r ~/sites/$SITENAME/deploy_tools/requirements/staging.txt

# DB related start
USER postgres
RUN    /etc/init.d/postgresql start &&\
	psql --command "CREATE DATABASE lms;" &&\
	psql --command "CREATE USER lmsuser WITH PASSWORD 'password';" &&\
	psql --command "ALTER ROLE lmsuser SET client_encoding TO 'utf8';" &&\
	psql --command "ALTER ROLE lmsuser SET default_transaction_isolation TO 'read committed';" &&\
	psql --command "ALTER ROLE lmsuser SET timezone TO 'UTC';" &&\
	psql --command "GRANT ALL PRIVILEGES ON DATABASE lms TO lmsuser;"


RUN echo "listen_addresses='*'" >> /etc/postgresql/9.5/main/postgresql.conf
EXPOSE 5432

USER root
ENV DJANGO_SETTINGS_MODULE=config.settings_staging
RUN sh ~/sites/$SITENAME/misc/cleanup.sh
# DB related end


COPY ./www /var/www/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]