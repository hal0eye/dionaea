# dionaea dockerfile by MO
#
# VERSION 16.10.0-backport-fix0events
FROM ubuntu:14.04.4 
MAINTAINER MO

# Install dependencies and packages
RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:honeynet/nightly && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y supervisor dionaea && \

# Setup ewsposter
    apt-get install -y python-lxml python-mysqldb python-requests git && \
    git clone https://github.com/rep/hpfeeds.git /opt/hpfeeds && cd /opt/hpfeeds && python setup.py install && \
    git clone https://github.com/armedpot/ewsposter.git /opt/ewsposter && \
    mkdir -p /opt/ewsposter/spool /opt/ewsposter/log && \

# Setup user and groups
    addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \

# Clean up
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Supply configs
ADD etc/ /opt/dionaea/etc/dionaea/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start dionaea
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
