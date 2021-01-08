FROM phusion/baseimage:bionic-1.0.0
MAINTAINER Steven Arcangeli <stevearc@stevearc.com>
MAINTAINER Jerry Chae <mcchae@gmail.com>

ENV PYPICLOUD_VERSION 1.1.7

EXPOSE 8080

# Install packages required
RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qy python3-pip \
     python3-dev libldap2-dev libsasl2-dev libmysqlclient-dev libffi-dev \
     libssl-dev bcrypt netcat \
  && pip3 install pypicloud[all_plugins]==$PYPICLOUD_VERSION requests uwsgi \
     pastescript mysqlclient psycopg2-binary bcrypt \
  # Create the pypicloud user
  && groupadd -r pypicloud \
  && useradd -r -g pypicloud -d /var/lib/pypicloud -m pypicloud \
  # Make sure this directory exists for the baseimage init
  && mkdir -p /etc/my_init.d

# Add the startup service
ADD pypicloud-uwsgi.sh /etc/my_init.d/pypicloud-uwsgi.sh

# Add the pypicloud config file
RUN mkdir -p /etc/pypicloud
# ADD config.ini /etc/pypicloud/config.ini
ADD config-mysql.ini /etc/pypicloud/config.ini
ADD wait-for /wait-for
RUN chmod +x /wait-for

# Create a working directory for pypicloud
VOLUME /var/lib/pypicloud

# Add the command for easily creating config files
ADD make-config.sh /usr/local/bin/make-config

# Add an environment variable that pypicloud-uwsgi.sh uses to determine which
# user to run as
ENV UWSGI_USER pypicloud

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
