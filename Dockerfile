####################################################
# Purpose     : Dockerize Python/PhantomJS/Nginx
# OS          : Ubuntu 16.04 (xenial)
# Python      : 2.7
# PhantomJS   : 2.1.1
# Nginx       : 1.4.6
###################################################

# Pull base image
FROM ubuntu:xenial
MAINTAINER Cristiam Diaz <cdiaz@quantux.co>

# Keep upstart quiet
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Environment vars
ENV DEBIAN_FRONTEND noninteractive
ENV PHANTOMJS_VERSION 2.1.1

# Up to date and install packages
RUN apt-get update --fix-missing && apt-get install -y \
  tar \
  git \
  nano \
  wget \ 
  supervisor \
  nginx \
  python \
  python-dev \
  python-pip

# Update Pip
RUN pip install --upgrade pip 

# Stop supervisor service
RUN service supervisor stop

# Install PhantomJS
RUN wget --no-check-certificate https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && tar xjf phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /opt 
RUN ln -s /opt/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && rm phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2

# Remove any unwanted packages and cleand up
RUN apt-get autoremove --force-yes -y
RUN apt-get clean

# Expose port(s)
EXPOSE 80