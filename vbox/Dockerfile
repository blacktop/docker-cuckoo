FROM blacktop/volatility:2.6

LABEL maintainer "https://github.com/blacktop"

ARG DEFAULT_CUCKOO_UID=1000

ENV CUCKOO_VERSION 2.0.6
ENV CUCKOO_CWD /cuckoo
ENV CUCKOO_PACKAGE_PATH=/usr/lib/python2.7/site-packages/cuckoo
ENV CUCKOO_FORK_REPO=ilyaglow/cuckoo/remotevbox-machinery
ENV SSDEEP 2.14.1

# Install Cuckoo Sandbox Required Dependencies
COPY 2.0/requirements.txt /tmp/requirements.txt
RUN apk add --update --no-cache tcpdump py-lxml py-chardet py-libvirt py-crypto curl \
                       postgresql-dev \
                       gcc \
                       g++ \
                       python-dev \
                       libpq \
                       py-pip \
                       shadow \
  && pip install --upgrade pip wheel \
  && pip install psycopg2 \
  && apk del --purge postgresql-dev \
                     gcc \
                     g++ \
  && apk add --no-cache -t .build-deps \
                           linux-headers \
                           openssl-dev \
                           libxslt-dev \
                           libxml2-dev \
                           python-dev \
                           libffi-dev \
                           build-base \
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
  && curl -Ls https://github.com/ssdeep-project/ssdeep/releases/download/release-$SSDEEP/ssdeep-$SSDEEP.tar.gz > \
    /tmp/ssdeep-$SSDEEP.tar.gz \
  && cd /tmp \
  && tar xzf ssdeep-$SSDEEP.tar.gz \
  && cd ssdeep-$SSDEEP \
  && ./configure \
  && make \
  && make install \
  && echo "===> Install pydeep..." \
  && cd /tmp \
  && git clone https://github.com/kbandla/pydeep.git \
  && cd pydeep \
  && python setup.py build \
  && python setup.py install \
  # && echo "===> Install mitmproxy..." \
  # && LDFLAGS=-L/lib pip install mitmproxy \
  && echo "===> Install Cuckoo Sandbox..." \
  && mkdir /cuckoo \
  && adduser -D -h /cuckoo -u $DEFAULT_CUCKOO_UID cuckoo \
  && export PIP_NO_CACHE_DIR=off \
  && export PIP_DISABLE_PIP_VERSION_CHECK=on \
  && pip install --upgrade wheel setuptools \
  && pip install pip==9.0.3 remotevbox \
  && LDFLAGS=-L/lib pip install cuckoo==$CUCKOO_VERSION \
  && cuckoo \
  && cuckoo community \
  && echo "===> Install additional dependencies..." \
  && pip install -r /tmp/requirements.txt \
  && echo "===> Clean up unnecessary files..." \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

COPY 2.0/conf /cuckoo/conf
COPY 2.0/update_conf.py /update_conf.py
COPY vbox/docker-entrypoint.sh /entrypoint.sh

RUN chown -R cuckoo /cuckoo \
  && chmod +x /entrypoint.sh

WORKDIR /cuckoo

VOLUME ["/cuckoo/conf"]

EXPOSE 1337 31337

ADD https://raw.githubusercontent.com/$CUCKOO_FORK_REPO/cuckoo/machinery/virtualbox_websrv.py $CUCKOO_PACKAGE_PATH/machinery/virtualbox_websrv.py
ADD https://raw.githubusercontent.com/$CUCKOO_FORK_REPO/cuckoo/common/config.py $CUCKOO_PACKAGE_PATH/common/config.py

RUN chmod 644 $CUCKOO_PACKAGE_PATH/common/config.py \
              $CUCKOO_PACKAGE_PATH/machinery/virtualbox_websrv.py

ENTRYPOINT ["/entrypoint.sh"]
