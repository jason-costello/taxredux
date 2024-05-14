#!/bin/zsh

pg_dump -w "postgres://${USER}:${PASS}@192.168.1.100/tax" --schema-only | grep -v '^--\|^SET\|^SELECT pg_catalog.set_config' > schema.sql