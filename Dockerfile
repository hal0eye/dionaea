# dionaea dockerfile by MO
#
# VERSION 16.10.0
FROM ubuntu:14.04.5
MAINTAINER MO

# Include dist
ADD dist/ /root/dist/

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

# Supply configs
    rm -rf /opt/dionaea/etc/dionaea/* && \
    mv /root/dist/etc/* /opt/dionaea/etc/dionaea/ && \
    mv /root/dist/supervisord.conf /etc/supervisor/conf.d/ && \

# Clean up
    rm -rf /root/* && \
    apt-get purge git software-properties-common -y && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start dionaea
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
