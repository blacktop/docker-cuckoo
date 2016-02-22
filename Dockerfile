FROM debian:wheezy

MAINTAINER blacktop, https://github.com/blacktop

# grab gosu for easy step-down from root
# RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
# RUN arch="$(dpkg --print-architecture)" \
# 	&& set -x \
# 	&& curl -o /usr/local/bin/gosu -fSL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch" \
# 	&& curl -o /usr/local/bin/gosu.asc -fSL "https://github.com/tianon/gosu/releases/download/1.3/gosu-$arch.asc" \
# 	&& gpg --verify /usr/local/bin/gosu.asc \
# 	&& rm /usr/local/bin/gosu.asc \
# 	&& chmod +x /usr/local/bin/gosu

# TODO: ADD yara and volatility

ENV SSDEEP ssdeep-2.13

# Install Cuckoo Sandbox Required Dependencies
RUN buildDeps='ca-certificates \
               build-essential \
               libssl-dev \
               libffi-dev \
               libxml2-dev \
               libxslt1-dev \
               libjpeg8-dev \
               zlib1g-dev \
               python-dev \
               python-pip \
               apt-utils \
               adduser \
               numactl \
               curl' \
  && set -x \
  && apt-get update -qq \
  && apt-get install -yq $buildDeps \
                          python \
                          tcpdump \
                          git-core \
                          supervisor \
                          python-dpkt \
                          python-magic \
                          python-gridfs \
                          python-chardet \
                          python-libvirt --no-install-recommends \
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
  && git clone --branch 2.0-rc1 git://github.com/cuckoobox/cuckoo.git /cuckoo \
  && groupadd cuckoo \
  && useradd --create-home --home-dir /home/cuckoo -g cuckoo cuckoo \
  && chown -R cuckoo:cuckoo /cuckoo \
  && cd /cuckoo \
  && echo "Upgrade pip and install pip dependencies..." \
  && export PIP_NO_CACHE_DIR=off \
  && export PIP_DISABLE_PIP_VERSION_CHECK=on \  
  && pip install --upgrade pip wheel \
  && /usr/local/bin/pip install mitmproxy \
  && /usr/local/bin/pip install -r requirements.txt \
  && python utils/community.py -waf \
  && echo "Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/mongodb

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY conf/reporting.conf /cuckoo/conf/reporting.conf
# COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/cuckoo/conf"]

WORKDIR /cuckoo/web

EXPOSE 80

# ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/supervisord"]
