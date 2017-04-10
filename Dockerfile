# dionaea dockerfile by MO
#
# VERSION 17.06
FROM debian:jessie-slim
MAINTAINER MO

# Include dist
ADD dist/ /root/dist/

# Install dependencies and packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y git supervisor autoconf automake build-essential check cython3 libcurl4-openssl-dev libemu-dev libev-dev \
                       libglib2.0-dev libloudmouth1-dev libnetfilter-queue-dev libnl-3-dev libpcap-dev libssl-dev libtool libudns-dev \
                       python3 python3-dev python3-yaml && \

# Get and install dionaea
    cd /root/ && \
    git clone https://github.com/dinotools/dionaea && \
    cd dionaea && \
    autoreconf -vi && \
    ./configure --disable-werror --prefix=/opt/dionaea --with-python=/usr/bin/python3 --with-cython-dir=/usr/bin --with-ev-include=/usr/include \
                --with-ev-lib=/usr/lib --with-emu-lib=/usr/lib/libemu --with-emu-include=/usr/include --with-nl-include=/usr/include/libnl3 \
                --with-nl-lib=/usr/lib && \
    make && \
    make install && \

# Setup user and groups
    addgroup --gid 2000 tpot && \
    adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 tpot && \

# Supply configs
    rm -rf /opt/dionaea/etc/dionaea/* && \
    mv /root/dist/etc/* /opt/dionaea/etc/dionaea/ && \
    mv /root/dist/supervisord.conf /etc/supervisor/conf.d/ && \

# Clean up
    rm -rf /root/* && \
    apt-get purge git autoconf automake build-essential -y && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start dionaea
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
