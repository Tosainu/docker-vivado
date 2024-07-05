#!/bin/sh

set -e

if [ -n "$REUID" ] && [ -n "$REGID" ]; then
  groupadd --gid "$REGID" vivado
  useradd --shell /bin/bash --uid "$REUID" --gid vivado --create-home vivado
  if tty="$(tty)"; then
    chown vivado "$tty"
  fi
  unset REUID REGID
  export HOME=~vivado
  exec setpriv --reuid=vivado --regid=vivado --init-groups "$@"
else
  exec "$@"
fi
