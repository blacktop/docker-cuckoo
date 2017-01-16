Change Log
==========

All notable changes to this project will be documented in this file.

[2.0] - 2017-01-15
---------------------

### Fixed

-	fixed bad items in requirements.txt

### Added

-	docker-entryporint.sh
-	elasticsearch added to docker-compose.yml
-	postgres added to docker-compose.yml
-	data volume added to docker-compose.yml
-	cuckoo API added to docker-compose.yml
-	tini
-	su-exec
-	circleCI
-	table of contents in README
- docs in the docs folder

### Removed

-	supervisord in favor of entrypoint.sh pattern
- wait-for-it.sh in favor of including in entrypoint.sh itself

### Changed

-	added ability for docker-entryporint to auto-configure cuckoo based on what services have been `--link`ed.
-	moved away from `debian` base image in favor of the smaller `alpine`

[modified] - 2017-01-15
------------------

### Fixed

### Added

-	https://github.com/spender-sandbox/cuckoo-modified
-	added geoip

### Removed

### Changed

[1.2] - 2016-07-31
------------------

### Fixed

### Added

### Removed

-	cuckoosandbox/community was removed because it was failing for some reason
- wait-for-it.sh in favor of including in entrypoint.sh itself

### Changed
