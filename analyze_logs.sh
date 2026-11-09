#!/usr/bin/env bash

log_file="access.log"

> "$log_file"

for ((i = 0; i < 60; i++)); do
    cat >> "$log_file" <<'EOF'
192.168.1.10 - - [15/Aug/2026:10:15:32] "GET /api/users HTTP/1.1" 200
192.168.1.10 - - [15/Aug/2026:10:15:33] "GET /api/users HTTP/1.1" 200
10.0.0.5 - - [15/Aug/2026:10:15:34] "POST /api/login HTTP/1.1" 401
10.0.0.5 - - [15/Aug/2026:10:15:35] "GET /api/missing HTTP/1.1" 404
172.16.0.3 - - [15/Aug/2026:10:15:36] "GET /api/health HTTP/1.1" 503
EOF
done

echo "Общее количество запросов:"
awk 'END { print NR }' "$log_file"

echo "Топ-3 IP-адреса:"
grep -Eo '^([0-9]{1,3}\.){3}[0-9]{1,3}[[:space:]]' "$log_file" |
    awk '{ print $1 }' |
    sort |
    uniq -c |
    sort -k1,1nr -k2,2 |
    awk 'NR <= 3'


echo "Количество запросов с кодами 4xx и 5xx:"
awk '
    $NF ~ /^4[0-9]{2}$/ { client_errors++ }
    $NF ~ /^5[0-9]{2}$/ { server_errors++ }
    END {
        print "4xx:", client_errors + 0
        print "5xx:", server_errors + 0
    }
' "$log_file"
