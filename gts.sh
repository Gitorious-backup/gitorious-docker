#!/bin/bash

set -e

case "$1" in
  init)
    /srv/gitorious/docker/init.sh
    ;;
  start)
    /srv/gitorious/docker/start.sh
    ;;
  *)
    "$@"
    ;;
esac
