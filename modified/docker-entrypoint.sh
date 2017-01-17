#!/bin/sh

set -e

setDefaults() {
  export ES_HOST=${ES_HOST:="$(env | grep ELASTIC.*PORT_9200_TCP_ADDR= | sed -e 's|.*=||')"}
  export ES_PORT=${ES_PORT:="$(env | grep ELASTIC.*PORT_9200_TCP_PORT= | sed -e 's|.*=||')"}
  export MONGO_HOST=${MONGO_HOST:="$(env | grep MONGO.*PORT_.*_TCP_ADDR= | sed -e 's|.*=||')"}
  export MONGO_TCP_PORT=${MONGO_TCP_PORT:="$(env | grep MONGO.*PORT_.*_TCP_PORT= | sed -e 's|.*=||')"}
  export POSTGRES_HOST=${POSTGRES_HOST:="$(env | grep POSTGRES.*PORT_.*_TCP_ADDR= | sed -e 's|.*=||')"}
  export POSTGRES_TCP_PORT=${POSTGRES_TCP_PORT:="$(env | grep POSTGRES.*PORT_.*_TCP_PORT= | sed -e 's|.*=||')"}
  env | grep -E "^ES.*|^MONGO_HOST|^MONGO_TCP_PORT|^POSTGRES.*|^RESULTSERVER" | sort -n
}

es_url() {
    local auth

    auth=""
    if [ -n "$ES_USER" ]; then
        auth="$ES_USER"
        if [ -n "$ES_PASS" ]; then
            auth="$auth:$ES_PASS"
        fi
        auth="$auth@"
    fi

    if [ -z "$SHIELD" ]
    then
    	: # Not using X-Pack Shield.
    else
      if [ $SHIELD == "true" ]; then
          code=$(curl --write-out "%{http_code}\n" --silent --output /dev/null "http://${ES_HOST}:${ES_PORT}/")

          if [ $code != 401 ]; then
              echo "Shield does not seem to be running"
              exit 1
          fi
      fi
    fi

    echo "http://${auth}${ES_HOST}:${ES_PORT}"
}

# Wait for elasticsearch to start. It requires that the status be either
# green or yellow.
waitForElasticsearch() {
  echo -n "===> Waiting on elasticsearch($(es_url)) to start..."
  i=0;
  while [ $i -le 60 ]; do
    health=$(curl --silent "$(es_url)/_cat/health" | awk '{print $4}')
    if [[ "$health" == "green" ]] || [[ "$health" == "yellow" ]]
    then
      echo
      echo "Elasticsearch is ready!"
      return 0
    fi

    echo -n '.'
    sleep 1
    i=$((i+1));
  done

  echo
  echo >&2 'Elasticsearch is not running or is not healthy.'
  echo >&2 "Address: $(es_url)"
  echo >&2 "$health"
  exit 1
}

# Wait for. Params: host, port, service
waitFor() {
    echo -n "===> Waiting for ${3}(${1}:${2}) to start..."
    i=1
    while [ $i -le 20 ]; do
        if nc -vz ${1} ${2} 2>/dev/null; then
            echo "${3} is ready!"
            return 0
        fi

        echo -n '.'
        sleep 1
        i=$((i+1))
    done

    echo
    echo >&2 "${3} is not available"
    echo >&2 "Address: ${1}:${2}"
}

setUpCuckoo(){
  echo "===> Use default ports and hosts if not specified..."
  setDefaults
  echo
  echo "===> Update /cuckoo/conf/reporting.conf if needed..."
  /update_conf.py
  echo
  # Wait until all services are started
  if [ ! "$ES_HOST" == "" ]; then
  	waitForElasticsearch
  fi
  echo
  if [ ! "$MONGO_HOST" == "" ]; then
  	waitFor ${MONGO_HOST} ${MONGO_TCP_PORT} MongoDB
  fi
  echo
  if [ ! "$POSTGRES_HOST" == "" ]; then
  	waitFor ${POSTGRES_HOST} ${POSTGRES_TCP_PORT} Postgres
  fi
}

# Add cuckoo as command if needed
if [ "${1:0:1}" = '-' ]; then
  setUpCuckoo
  # Change the ownership of /cuckoo to cuckoo
  chown -R cuckoo:cuckoo /cuckoo
  cd /cuckoo/

  set -- python cuckoo.py "$@"
fi

# Drop root privileges if we are running cuckoo-daemon
if [ "$1" = 'daemon' -a "$(id -u)" = '0' ]; then
  shift
  # If not set default to 0.0.0.0
  export RESULTSERVER=${RESULTSERVER:=0.0.0.0}
  setUpCuckoo
  # Change the ownership of /cuckoo to cuckoo
  chown -R cuckoo:cuckoo /cuckoo
  cd /cuckoo

  set -- su-exec cuckoo /sbin/tini -- python cuckoo.py "$@"

elif [ "$1" = 'submit' -a "$(id -u)" = '0' ]; then
  shift
  setUpCuckoo
  # Change the ownership of /cuckoo to cuckoo
  chown -R cuckoo:cuckoo /cuckoo
  cd /cuckoo/utils

  set -- su-exec cuckoo /sbin/tini -- python submit.py "$@"

elif [ "$1" = 'process' -a "$(id -u)" = '0' ]; then
  shift
  setUpCuckoo
  # Change the ownership of /cuckoo to cuckoo
  chown -R cuckoo:cuckoo /cuckoo
  cd /cuckoo/utils

  set -- su-exec cuckoo /sbin/tini -- python process.py "$@"

elif [ "$1" = 'api' -a "$(id -u)" = '0' ]; then
  setUpCuckoo
  # Change the ownership of /cuckoo to cuckoo
  chown -R cuckoo:cuckoo /cuckoo
  cd /cuckoo/utils

  set -- su-exec cuckoo /sbin/tini -- python api.py --host 0.0.0.0 --port 1337

elif [ "$1" = 'web' -a "$(id -u)" = '0' ]; then
  setUpCuckoo
  if [[ -z "$ES_HOST" ]] && [[ -z "$MONGO_HOST" ]]; then
    echo >&2 "[ERROR] Elasticsearch or MongoDB cannot be found. Please link mongo and try again..."
    exit 1
  fi
  # Change the ownership of /cuckoo to cuckoo
  chown -R cuckoo:cuckoo /cuckoo
  cd /cuckoo/web
  su-exec cuckoo python manage.py migrate
  set -- su-exec cuckoo /sbin/tini -- python manage.py runserver 0.0.0.0:31337

elif [ "$1" = 'distributed' -a "$(id -u)" = '0' ]; then
  shift
  # Change the ownership of /cuckoo to cuckoo
  chown -R cuckoo:cuckoo /cuckoo
  cd /cuckoo/distributed

  set -- su-exec cuckoo /sbin/tini -- python app.py "$@"

elif [ "$1" = 'stats' -a "$(id -u)" = '0' ]; then
  shift
  # Change the ownership of /cuckoo to cuckoo
  chown -R cuckoo:cuckoo /cuckoo
  cd /cuckoo/utils

  set -- su-exec cuckoo /sbin/tini -- python stats.py "$@"

elif [ "$1" = 'help' -a "$(id -u)" = '0' ]; then
  setUpCuckoo
  # Change the ownership of /cuckoo to cuckoo
  chown -R cuckoo:cuckoo /cuckoo
  cd /cuckoo

  set -- su-exec cuckoo /sbin/tini -- python cuckoo.py --help
fi

exec "$@"
