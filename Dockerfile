FROM blacktop/volatility

MAINTAINER blacktop, https://github.com/blacktop

ENV CUCKOO_VERSION 2.0-rc1
ENV SSDEEP ssdeep-2.13

# Grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
ENV GOSU_URL https://github.com/tianon/gosu/releases/download
RUN apk-install -t gosu-deps dpkg curl \
  && curl -o /usr/local/bin/gosu -sSL "${GOSU_URL}/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
	&& chmod +x /usr/local/bin/gosu \
  && apk del --purge gosu-deps

# Install Cuckoo Sandbox Required Dependencies
RUN apk add py-mitmproxy --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
RUN apk-install tcpdump py-lxml py-chardet py-libvirt
RUN apk-install -t build-deps autoconf \
                              automake \
                              build-base \
                              curl \
                              file-dev \
                              git \
                              jpeg-dev \
                              libc-dev \
                              libffi-dev \
                              libstdc++ \
                              libtool \
                              libxml2-dev \
                              libxslt-dev \
                              openssl-dev \
                              py-pip \
                              py-six \
                              python-dev \
                              zlib-dev \
  && set -x \
  && echo "Install ssdeep..." \
  && curl -Ls https://downloads.sourceforge.net/project/ssdeep/$SSDEEP/$SSDEEP.tar.gz > /tmp/$SSDEEP.tar.gz \
  && cd /tmp \
  && tar zxvf $SSDEEP.tar.gz \
  && cd $SSDEEP \
  && ./configure \
  && make \
  && make install \
  && echo "Install pydeep..." \
  && cd /tmp \
  && git clone https://github.com/kbandla/pydeep.git \
  && cd pydeep \
  && python setup.py build \
  && python setup.py install \
  && echo "Cloning Cuckoo Sandbox..." \
  && git clone --branch $CUCKOO_VERSION https://github.com/cuckoosandbox/cuckoo.git /cuckoo \
  && cd /cuckoo \
  && pip install --upgrade pip wheel \
  && pip install alembic \
                  beautifulsoup4 \
                  cffi \
                  chardet \
                  cryptography \
                  Django \
                  dpkt \
                  ecdsa \
                  elasticsearch \
                  enum34 \
                  Flask \
                  http://pefile.googlecode.com/files/pefile-1.2.10-139.tar.gz#egg=pefile \
                  HTTPReplay \
                  idna \
                  ipaddress \
                  jsbeautifier \
                  Mako \
                  ndg-httpsclient \
                  oletools \
                  pyasn1 \
                  pycparser \
                  pymongo \
                  pyOpenSSL \
                  python-dateutil \
                  python-editor \
                  python-magic \
                  requests \
                  SQLAlchemy \
                  tlslite-ng \
                  wakeonlan \
  && python utils/community.py -waf \
  && echo "Clean up unnecessary files..." \
  && rm -rf /tmp/* \
  && apk del --purge build-deps

COPY conf/reporting.conf /cuckoo/conf/reporting.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/cuckoo/conf"]

WORKDIR /cuckoo/web

EXPOSE 80

# ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord"]
