#!/usr/bin/env python

import os
import sys
import ConfigParser

cfg = ConfigParser.ConfigParser()
cfg.read("/cuckoo/conf/reporting.conf")

with open("/cuckoo/conf/reporting.conf", 'w') as cfile:
    if os.environ.get('ES_HOST'):
        cfg.set('elasticsearchdb', 'enabled', True)
        cfg.set('elasticsearchdb', 'hosts', os.environ['ES_HOST'])
    if os.environ.get('MONGO_HOST'):
        cfg.set('mongodb', 'enabled', True)
        cfg.set('mongodb', 'hosts', os.environ['MONGO_HOST'])
    cfg.write(cfile)

cfg.read("/cuckoo/conf/cuckoo.conf")

with open("/cuckoo/conf/cuckoo.conf", 'w') as cfile:
    if os.environ.get('RESULTSERVER'):
        cfg.set('resultserver', 'ip', os.environ['RESULTSERVER'])
    cfg.write(cfile)

sys.exit()
