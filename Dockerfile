# dionaea dockerfile by MO
#
# VERSION 16.10.0-backport-fix0events
FROM ubuntu:14.04.4
MAINTAINER MO

# Setup apt
RUN apt-get update -y
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies and packages
RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:honeynet/nightly && \
    apt-get update && \
    apt-get install -y supervisor dionaea

# Setup user, groups and configs
RUN addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot
ADD etc/ /opt/dionaea/etc/dionaea/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup ewsposter
RUN apt-get install -y python-lxml python-mysqldb python-requests git && \
    git clone https://github.com/rep/hpfeeds.git /opt/hpfeeds && cd /opt/hpfeeds && python setup.py install && \
    git clone https://github.com/armedpot/ewsposter.git /opt/ewsposter && \
    mkdir -p /opt/ewsposter/spool /opt/ewsposter/log

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start dionaea
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
