FROM debian:wheezy

MAINTAINER blacktop, https://github.com/blacktop

RUN groupadd cuckoo && \
    useradd --create-home --home-dir /home/cuckoo -g cuckoo cuckoo

# Install Cuckoo Sandbox Required Dependencies
COPY files/pefile-1.2.10-139.tar.gz /pefile-1.2.10-139.tar.gz
COPY files/gosu-amd64 /usr/local/bin/gosu
COPY files/gosu-amd64.asc /usr/local/bin/gosu.asc
RUN buildDeps='build-essential \
               python-dev \
               python-pip \
               adduser' \
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
                          python-libvirt --no-install-recommends \
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
  && echo "a1bc91758ed1ff8c2df661511023360fcf9bbf77 *pefile-1.2.10-139.tar.gz" \
    | shasum -c - \  
  && tar -zxvf pefile-1.2.10-139.tar.gz \
  && rm pefile-1.2.10-139.tar.gz \
  && cd pefile-1.2.10-139 \
  && python setup.py build \
  && python setup.py install \
  && rm -rf /pefile-1.2.10-139 \
  && echo "Grab gosu for easy step-down from root..." \
  && gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && echo "Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Cuckoo Sandbox and remove install dir after to conserve space
RUN git clone git://github.com/cuckoobox/cuckoo.git \
      && chown -R cuckoo:cuckoo /cuckoo \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY conf/reporting.conf /cuckoo/conf/reporting.conf

VOLUME ["/cuckoo/conf"]

WORKDIR /cuckoo/web

EXPOSE 80

CMD ["/usr/bin/supervisord"]
