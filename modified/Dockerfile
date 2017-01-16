FROM blacktop/volatility:2.6

MAINTAINER blacktop, https://github.com/blacktop

ENV SSDEEP ssdeep-2.13

# Install Cuckoo Sandbox Required Dependencies
RUN apk-install tcpdump py-lxml py-chardet py-libvirt py-crypto geoip curl
RUN apk-install -t .build-deps \
                   openssl-dev \
                   libxslt-dev \
                   libxml2-dev \
                   python-dev \
                   libffi-dev \
                   build-base \
                   geoip-dev \
                   libstdc++ \
                   zlib-dev \
                   libc-dev \
                   jpeg-dev \
                   file-dev \
                   automake \
                   autoconf \
                   libtool \
                   py-pip \
                   git \
  && set -x \
  && echo "===> Install ssdeep..." \
  && wget -O /tmp/$SSDEEP.tar.gz https://downloads.sourceforge.net/project/ssdeep/$SSDEEP/$SSDEEP.tar.gz \
  && cd /tmp \
  && tar zxvf $SSDEEP.tar.gz \
  && cd $SSDEEP \
  && ./configure \
  && make \
  && make install \
  && echo "===> Install pydeep..." \
  && cd /tmp \
  && git clone https://github.com/kbandla/pydeep.git \
  && cd pydeep \
  && python setup.py build \
  && python setup.py install \
  && echo "===> Cloning Cuckoo Sandbox..." \
  && git clone --recursive https://github.com/spender-sandbox/cuckoo-modified.git /cuckoo \
  && adduser -DH cuckoo \
  && cd /cuckoo \
  && export PIP_NO_CACHE_DIR=off \
  && export PIP_DISABLE_PIP_VERSION_CHECK=on \
  && pip install --upgrade pip wheel \
  && echo "===> Install mitmproxy..." \
  && LDFLAGS=-L/lib pip install mitmproxy \
  && pip install -r requirements.txt \
  && python utils/community.py -waf \
  && echo "===> Clean up unnecessary files..." \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

# Install the GeoIPLite Database
RUN mkdir -p /usr/share/GeoIP/ \
  && GEOIP=geolite.maxmind.com/download/geoip/database \
  && curl -s http://${GEOIP}/GeoLiteCity.dat.gz | zcat > /usr/share/GeoIP/GeoIP.dat \
  && curl -s http://${GEOIP}/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz | zcat > /usr/share/GeoIP/GeoIPv6.dat

COPY conf /cuckoo/conf
COPY update_conf.py /update_conf.py
COPY docker-entrypoint.sh /entrypoint.sh

WORKDIR /cuckoo

VOLUME ["/cuckoo/conf"]

EXPOSE 1337 31337

ENTRYPOINT ["/entrypoint.sh"]
CMD help
