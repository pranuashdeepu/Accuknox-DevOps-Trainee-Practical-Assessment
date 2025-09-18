#!/usr/bin/env bash
URL=${1:-http://localhost:4499/}
EXPECTED=${2:-200}
TIMEOUT=${3:-5}

if [ -z "$URL" ]; then
  echo "Usage: $0 <url> [expected_http_code] [timeout_seconds]"
  exit 2
fi

code=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$TIMEOUT" "$URL") || code=000

if [ "$code" -eq "$EXPECTED" ]; then
  echo "UP - $URL responded with $code"
  exit 0
else
  echo "DOWN - $URL responded with $code (expected $EXPECTED)"
  exit 1
fi
