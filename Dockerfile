FROM debian:wheezy

MAINTAINER blacktop, https://github.com/blacktop

RUN groupadd cuckoo && \
    useradd --create-home --home-dir /home/cuckoo -g cuckoo cuckoo

# Install Cuckoo Sandbox Required Dependencies
RUN buildDeps='build-essential \
               python-dev \
               python-pip \
               adduser \
               curl' \
  && set -x \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 \
  && echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" \
    | tee /etc/apt/sources.list.d/mongodb-org-3.0.list \
  && apt-get update -qq \
  && apt-get install -yq $buildDeps \
                                                  python \
                                                  tcpdump \
                                                  git-core \
                                                  supervisor \
                                                  mongodb-org \
                                                  python-dpkt \
                                                  python-magic \
                                                  python-gridfs \
                                                  python-chardet \
                                                  python-libvirt  \
  && echo "Create mongoDB db folder..." \
  && mkdir -p /data/db \
  && echo '' > /var/log/mongodb/mongod.log \
  && chown -R mongodb:mongodb /var/log/mongodb/mongod.log /data/db \
  && echo "Upgrade pip and install pip dependencies..." \
  && pip install --upgrade pip \
  && /usr/local/bin/pip install --upgrade sqlalchemy \
                                           pymongo \
                                           chardet \
                                           jinja2 \
                                           bottle \
                                           pefile \
                                           django \
                                           nose \
  && echo "Installing latest version of pefile..." \
  && curl -sSL "https://pefile.googlecode.com/files/pefile-1.2.10-139.tar.gz" -o pefile.tar.gz \                                   && tar -zxvf pefile.tar.gz \
  && rm pefile.tar.gz \
  && cd pefile \
  && python setup.py build \
  && python setup.py install \
  && rm -rf /pefile-1.2.10-139 \
  && echo "Grab gosu for easy step-down from root..." \
  && gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
  && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu
  && echo "Clean up unnecessary files..." \
  && apt-get purge  -y --auto-remove $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Cuckoo Sandbox and remove install dir after to conserve space
RUN git clone git://github.com/cuckoobox/cuckoo.git \
      && chown -R cuckoo:cuckoo /cuckoo \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY conf/reporting.conf /cuckoo/conf/reporting.conf

VOLUME ["/cuckoo/conf"]

EXPOSE 80

CMD ["/usr/bin/supervisord"]
