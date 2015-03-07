FROM debian:wheezy

MAINTAINER blacktop, https://github.com/blacktop

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

# Install Cuckoo Sandbox Required Dependencies
RUN \
  apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
  echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" \
    | tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
  apt-get -qq update && \
  apt-get install -yq python \
                      adduser \
                      tcpdump \
                      git-core \
                      supervisor \
                      python-pip \
                      python-dev \
                      supervisor \
                      mongodb-org \
                      python-dpkt \
                      python-magic \
                      python-gridfs \
                      python-chardet \
                      build-essential \
                      python-libvirt --no-install-recommends && \
  mkdir -p /data/db && echo '' > /var/log/mongodb/mongod.log && \
  chown -R mongodb /var/log/mongodb/mongod.log /data/db && \
  chgrp mongodb /var/log/mongodb/mongod.log /data/db && \
  pip install --upgrade pip && \
  /usr/local/bin/pip install --upgrade sqlalchemy \
                                       pymongo \
                                       chardet \
                                       jinja2 \
                                       bottle \
                                       pefile \
                                       django \
                                       nose && \
  apt-get purge  -y --auto-remove build-essential python-dev python-pip && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Cuckoo Sandbox and remove install dir after to conserve space
ADD https://pefile.googlecode.com/files/pefile-1.2.10-139.tar.gz /
RUN  \
  git clone git://github.com/cuckoobox/cuckoo.git && \
  tar -zxvf pefile-1.2.10-139.tar.gz && \
  rm pefile-1.2.10-139.tar.gz && \
  cd pefile-1.2.10-139 && \
  python setup.py build && \
  python setup.py install && \
  rm -rf /pefile-1.2.10-139 && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY conf/reporting.conf /cuckoo/conf/reporting.conf

WORKDIR /cuckoo/web

VOLUME ["/cuckoo/conf"]

EXPOSE 80

CMD ["/usr/bin/supervisord"]
