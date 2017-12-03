FROM alpine:3.6

ENV VOL_VERSION 2.6
ENV YARA_VERSION 3.6.3
ENV CUCKOO_CWD /cuckoo
ENV SSDEEP ssdeep-2.13
ENV SURICATA_VERSION 3.2.1
ENV TCPDUMP_VERSION 4.7.4-r0


RUN apk add --no-cache ca-certificates \
                            zlib \
                            py-pillow \
                            py-crypto \
                            py-lxml \
                            py-setuptools \
                            openssl \
                            file \
                            jansson \
                            bison \
                            python \
                            tini \
                            su-exec

RUN apk add --no-cache -t .build-deps \
                           libressl-dev \
                           build-base \
                           zlib-dev \
                           libc-dev \
                           jpeg-dev \
                           automake \
                           autoconf \
                           py-pip \
                           git \
                           py-setuptools \
                           jansson-dev \
                           python-dev \
                           build-base \
                           file-dev \
                           libtool \
                           libxml2-dev \
                           flex \
                           libxslt-dev \
                           libffi-dev \
                           libstdc++ \
                           file-dev \
                           linux-headers \
  && export PIP_NO_CACHE_DIR=off \
  && export PIP_DISABLE_PIP_VERSION_CHECK=on \
  && pip install --upgrade pip wheel \
  && pip install simplejson \
                 construct \
                 openpyxl \
                 haystack \
                 distorm3 \
                 colorama \
                 ipython \
                 pycoin \
                 pytz \
                 validators \
                 unidecode \
                 pyminizip \
  && cd /tmp \
  && echo "===> Installing Volatility from source..." \
  && git clone --recursive --branch $VOL_VERSION https://github.com/volatilityfoundation/volatility.git \
  && cd volatility \
  && python setup.py build install \
  && echo "Install Yara from source..." \
  && cd /tmp/ \
  && git clone --recursive --branch v$YARA_VERSION https://github.com/VirusTotal/yara.git \
  && cd /tmp/yara \
  && ./bootstrap.sh \
  && sync \
  && ./configure --enable-cuckoo --enable-magic --with-dotnet \
  && make \
  && make install \
  && echo "Install yara-python..." \
  && cd /tmp/ \
  && git clone --recursive --branch v$YARA_VERSION https://github.com/VirusTotal/yara-python \
  && cd yara-python \
  && python setup.py build --dynamic-linking \
  && python setup.py install \
  && echo "Make test_rule..." \
  && mkdir /rules \
  && echo "rule dummy { condition: true }" > /rules/test_rule \
  && rm -rf /tmp/* \
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
  && mkdir /cuckoo \
  && adduser -D -h /cuckoo cuckoo \
  && python setup.py build \
  && python setup.py install \
  && apk add --no-cache py-lxml py-chardet py-libvirt py-crypto curl \
  && apk add --no-cache postgresql-dev \
                       gcc \
                       g++ \
                       python-dev \
                       libpq \
                       py-pip \
  && pip install --upgrade pip wheel \
  && pip install psycopg2 \
  && echo "===> Install Cuckoo Sandbox...." \
  && export PIP_NO_CACHE_DIR=off \
  && export PIP_DISABLE_PIP_VERSION_CHECK=on \
  && cd /tmp \
  && pip install --upgrade pip wheel \
  && rm -rf /tmp/*

COPY cuckoo /tmp/cuckoo
RUN cd /tmp/cuckoo \
  && pip install -r requirements.txt \
  && python stuff/monitor.py \
  && python setup.py sdist install \
  && LDFLAGS=-L/lib pip install .

RUN cd /cuckoo \
  && cuckoo \
  && cuckoo community \
  && cd /tmp \
  && cp /tmp/cuckoo/cuckoo/auxiliary/mitm.py /cuckoo/mitm.py \
  && echo "===> Clean up unnecessary files..." \
  && rm -rf /tmp/*

RUN cd /tmp \
  && apk add  --no-cache -t malheur-dev \
                            libconfig \
                            libconfig-dev \
  && git clone https://github.com/rieck/malheur.git \
  && cd malheur \
  && ./bootstrap \
  && ./configure --prefix=/usr \
  && make

RUN apk add --no-cache -t mitmproxy-build \
                          python3 \
                          python3-dev \
                          libffi \
                          libffi-dev \
  && cd /tmp \
  && git clone https://github.com/mitmproxy/mitmproxy.git \
  && cd mitmproxy \
  && LDFLAGS=-L/lib pip3 install .

RUN apk add --no-cache -t clamav-build \
                          clamav \
                          clamav-daemon \
                          clamav-dev \
                          clamav-lib \
                          tcpdump \
                          libpcap

RUN apk add --update tcpdump
RUN apk add  --no-cache -t suricata \
                           pcre-dev \
                           yaml \
                           yaml-dev \
                           libpcap \
                           libpcap-dev \
                           libpcap-doc \
                           libmagic \
  && cd /tmp \
  && wget "http://www.openinfosecfoundation.org/download/suricata-$SURICATA_VERSION.tar.gz" \
  && tar -xvzf "suricata-$SURICATA_VERSION.tar.gz" \
  && cd "suricata-$SURICATA_VERSION" \
  && ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
  && make \
  && make install \
  && make install-full


RUN cd /tmp \
  && apk del --purge .build-deps \
                     postgresql-dev \
                     gcc

COPY conf /cuckoo/conf
COPY update_conf.py /update_conf.py
COPY docker-entrypoint.sh /entrypoint.sh

WORKDIR /cuckoo/

VOLUME ["/cuckoo/conf"]

EXPOSE 1337 31337

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
