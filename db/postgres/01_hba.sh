#!/bin/bash
set -e

cat >> "$PGDATA/pg_hba.conf" <<EOF
host all all 172.18.0.0/16 scram-sha-256
EOF