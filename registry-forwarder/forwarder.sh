#!/bin/sh -e

# LOCAL_PORT    (optional) Port that is listened to. Default: 80.
# REGISTRY_PORT (optional) Docker registry's port. Default: 5000.

LOCAL_PORT=${LOCAL_PORT:-80}
REGISTRY_PORT=${REGISTRY_PORT:-5000}

# Find an unused port.
while true; do
    INTERNAL_PORT=$(shuf -i 2000-65000 -n 1)
    $(ncat -v localhost $INTERNAL_PORT 2>&1 | grep -q refused) && break
done

ncat -k -l -p "$LOCAL_PORT" -c "ncat localhost $INTERNAL_PORT" &
NCAT_PID=$!

ssh -N -L "$INTERNAL_PORT":127.0.0.1:"$REGISTRY_PORT" docker-registry &
SSH_PID=$!

on_kill() {
    killall -q ncat ssh
}
trap on_kill INT TERM EXIT

wait $NCAT_PID $SSH_PID
