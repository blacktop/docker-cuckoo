FROM blacktop/volatility

MAINTAINER blacktop, https://github.com/blacktop

ENV CUCKOO_VERSION 2.0-rc1
ENV SSDEEP ssdeep-2.13

# # Grab gosu for easy step-down from root
# ENV GOSU_VERSION 1.7
# ENV GOSU_URL https://github.com/tianon/gosu/releases/download
# RUN apk-install -t gosu-deps dpkg curl \
#   && curl -o /usr/local/bin/gosu -sSL "${GOSU_URL}/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
# 	&& chmod +x /usr/local/bin/gosu \
#   && apk del --purge gosu-deps

# Install Cuckoo Sandbox Required Dependencies
RUN apk-install tcpdump py-lxml py-chardet py-libvirt
RUN apk-install -t build-deps git \
                              curl \
                              py-pip \
                              libtool \
                              autoconf \
                              automake \
                              file-dev \
                              jpeg-dev \
                              libc-dev \
                              zlib-dev \
                              libstdc++ \
                              build-base \
                              libffi-dev \
                              python-dev \
                              libxml2-dev \
                              libxslt-dev \
                              openssl-dev \
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
  && adduser -DH cuckoo \
  && cd /cuckoo \
  && python utils/community.py -waf \
  && chown -R cuckoo:cuckoo /cuckoo \
  && export PIP_NO_CACHE_DIR=off \
  && export PIP_DISABLE_PIP_VERSION_CHECK=on \
  && pip install --upgrade pip wheel \
  && echo "Install mitmproxy..." \
  && LDFLAGS=-L/lib pip install mitmproxy \
  && pip install six \
                 cffi \
                 dpkt \
                 idna \
                 Mako \
                 ecdsa \
                 flask \
                 pefile \
                 Django \
                 enum34 \
                 pyasn1 \
                 alembic \
                 chardet \
                 pymongo \
                 oletools \
                 requests \
                 ipaddress \
                 pycparser \
                 pyOpenSSL \
                 wakeonlan \
                 HTTPReplay \
                 SQLAlchemy \
                 tlslite-ng \
                 cryptography \
                 jsbeautifier \
                 python-magic \
                 elasticsearch \
                 python-editor \
                 beautifulsoup4 \
                 ndg-httpsclient \
                 python-dateutil \
                 flask-sqlalchemy \
  && echo "Clean up unnecessary files..." \
  && rm -rf /tmp/* \
  && apk del --purge build-deps

COPY conf /cuckoo/conf
# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/cuckoo/conf"]

EXPOSE 80

USER cuckoo
WORKDIR /cuckoo/web
ENTRYPOINT []
CMD python manage.py runserver 0.0.0.0:8080
