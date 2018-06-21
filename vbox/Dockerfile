FROM blacktop/cuckoo:latest

LABEL maintainer "https://github.com/blacktop"

ENV PULL_REQUST 1998

RUN apk add --no-cache -t .build-deps \
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
  && LDFLAGS=-L/lib pip install remotevbox \
  && echo "===> Clean up unnecessary files..." \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

COPY conf /cuckoo/conf

ENV CUCKOO_PACKAGE_PATH=/usr/lib/python2.7/site-packages/cuckoo
ENV CUCKOO_FORK_REPO=ilyaglow/cuckoo/remotevbox-machinery

ADD --chown=cuckoo:cuckoo https://raw.githubusercontent.com/$CUCKOO_FORK_REPO/cuckoo/machinery/virtualbox_websrv.py $CUCKOO_PACKAGE_PATH/machinery/virtualbox_websrv.py
ADD --chown=cuckoo:cuckoo https://raw.githubusercontent.com/$CUCKOO_FORK_REPO/cuckoo/common/config.py $CUCKOO_PACKAGE_PATH/common/config.py