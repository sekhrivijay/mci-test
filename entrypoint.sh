#!/bin/bash

set -e

exec gunicorn --bind :8080 --workers 1 --threads 8 --timeout 0 main:app