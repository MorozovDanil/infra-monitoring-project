#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <URL>" >&2
    exit 1
fi

url="$1"

http_code=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 20 "$url")
curl_exit=$?

if [ "$curl_exit" -eq 0 ] && [ "$http_code" = "200" ]; then
    echo "API доступен"
    exit 0
else
    echo "API недоступен, код ответа: $http_code"
    exit 1
fi
