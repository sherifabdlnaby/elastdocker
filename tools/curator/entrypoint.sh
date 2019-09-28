#!/bin/sh
set -eu

# Add Crontab
crontab /etc/crontab

# Run Crond
exec tini -s -- crond -fl 8 -d 8