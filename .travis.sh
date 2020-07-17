#!/bin/bash

# setup a redis sentinel
CONF=$(mktemp)

cat > "$CONF" <<EOF
sentinel monitor default_service 127.0.0.1 6379 1
sentinel down-after-milliseconds default_service 3200
sentinel failover-timeout default_service 10000
sentinel parallel-syncs default_service 1
EOF

redis-server "$CONF" --sentinel &
trap "kill -INT $!" EXIT

# run tests
tox
