# dionaea dockerfile by MO
#
# VERSION 17.06
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

# Setup user and groups
    addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \

# Supply configs
    rm -rf /opt/dionaea/etc/dionaea/* && \
    mv /root/dist/etc/* /opt/dionaea/etc/dionaea/ && \
    mv /root/dist/supervisord.conf /etc/supervisor/conf.d/ && \

# Clean up
    rm -rf /root/* && \
    apt-get purge software-properties-common -y && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start dionaea
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
