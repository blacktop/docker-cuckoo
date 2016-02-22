#!/bin/bash

set -e

# first check if we're passing flags, if so
# prepend with sentry
# if [ "${1:0:1}" = '-' ]; then
# 	set -- sentry "$@"
# fi

case "$1" in
	web)
		# Change the ownership of /cuckoo to cuckoo
		chown -R cuckoo:cuckoo /cuckoo

		set -- gosu cuckoo exec `cd web && python manage.py runserver 0.0.0.0:8080`
	;;
	daemon)
		chown -R cuckoo:cuckoo /cuckoo

		set -- gosu cuckoo exec python cuckoo.py
	;;
esac

exec "$@"


# #!/bin/bash
#
# set -e
#
# # Add elasticsearch as command if needed
# if [ "${1:0:1}" = '-' ]; then
# 	set -- elasticsearch "$@"
# fi
#
# # Drop root privileges if we are running elasticsearch
# # allow the container to be started with `--user`
# if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
# 	# Change the ownership of /usr/share/elasticsearch/data to elasticsearch
# 	chown -R elasticsearch:elasticsearch /usr/share/elasticsearch/data
#
# 	set -- gosu elasticsearch "$@"
# 	#exec gosu elasticsearch "$BASH_SOURCE" "$@"
# fi
#
# # As argument is not related to elasticsearch,
# # then assume that user wants to run his own process,
# # for example a `bash` shell to explore this image
# exec "$@"
