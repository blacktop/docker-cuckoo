#!/usr/bin/env python

import os
import sys
import ConfigParser

reporting_cfg = ConfigParser.ConfigParser()
cuckoo_cfg = ConfigParser.ConfigParser()

reporting_cfg.read("/cuckoo/conf/reporting.conf")
with open("/cuckoo/conf/reporting.conf", 'w') as cfile:
    if os.environ.get('MONGO_HOST'):
        reporting_cfg.set('mongodb', 'enabled', True)
        reporting_cfg.set('mongodb', 'hosts', os.environ['MONGO_HOST'])
    reporting_cfg.write(cfile)

cuckoo_cfg.read("/cuckoo/conf/cuckoo.conf")
with open("/cuckoo/conf/cuckoo.conf", 'w') as cfile:
    if os.environ.get('RESULTSERVER'):
        cuckoo_cfg.set('resultserver', 'ip', os.environ['RESULTSERVER'])
    cuckoo_cfg.write(cfile)

sys.exit()
