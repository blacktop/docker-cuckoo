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
  && echo "===> Install cuckoo with remotevbox-machinery..." \
  && cd /tmp \
  && git clone https://github.com/cuckoosandbox/cuckoo.git \
  && cd cuckoo \
  && git fetch origin pull/$PULL_REQUST/head:virtualbox_websrv \
  && git checkout virtualbox_websrv \
  && export PIP_NO_CACHE_DIR=off \
  && export PIP_DISABLE_PIP_VERSION_CHECK=on \
  && pip install --upgrade pip wheel setuptools \
  && python stuff/monitor.py \
  && LDFLAGS=-L/lib pip install -e . \
  && LDFLAGS=-L/lib pip install remotevbox \
  && echo "===> Clean up unnecessary files..." \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

COPY conf /cuckoo/conf
