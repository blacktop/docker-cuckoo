FROM debian:wheezy

MAINTAINER blacktop, https://github.com/blacktop

# Prevent daemon start during install
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Install Bro Required Dependencies
RUN \
  apt-get -qq update && \
  apt-get install -yq python \
    mongodb \
    python-sqlalchemy \
    python-bson \
    python-dpkt \
    python-jinja2 \
    python-magic \
    python-pymongo \
    python-gridfs \
    python-libvirt \
    python-bottle \
    python-pefile \
    python-chardet \
    tcpdump \

    --no-install-recommends && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Bro and remove install dir after to conserve space
RUN  \
  git clone git://github.com/cuckoobox/cuckoo.git && \
  cd bro && pip install -r requirements.txt && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH /nsm/bro/bin:$PATH

# Add PCAP Test Folder
ADD /pcap/heartbleed.pcap /pcap/
VOLUME ["/pcap"]
WORKDIR /pcap

# Add Scripts Folder
ADD /scripts /scripts
ADD /scripts/local.bro /nsm/bro/share/bro/site/local.bro

ENTRYPOINT ["bro"]

CMD ["-h"]
