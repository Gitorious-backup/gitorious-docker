#!/bin/bash

set -e

case "$1" in
  init)
    /home/git/init.sh
    ;;
  start)
    /home/git/start.sh
    ;;
  *)
    "$@"
    ;;
esac
