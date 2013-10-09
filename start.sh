#!/bin/bash

set -e

echo "~~ Starting Gitorious..."
exec supervisord -n
