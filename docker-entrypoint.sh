#!/usr/bin/env bash
set -euo pipefail

APP_RUN="/opt/flclash/app/AppRun"

if [[ ! -x "${APP_RUN}" ]]; then
  echo "AppRun not found at ${APP_RUN}" >&2
  exit 1
fi

# 启动 DBus daemon
if [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
  eval "$(dbus-launch --sh-syntax)"
  export DBUS_SESSION_BUS_ADDRESS
fi

# 注入 XInitThreads，解决 Flutter 多线程 X11 崩溃
export LD_PRELOAD="/usr/local/lib/xthreads_init.so${LD_PRELOAD:+:$LD_PRELOAD}"

exec "${APP_RUN}" ${FLCLASH_ARGS:-} "$@"
