#!/bin/bash

# Enhance the randomization process (time in epoch to initialize)
RANDOM=$(date +%s)

while [[ true ]]; do

    REQUEST=$(($RANDOM % 5))

    case $REQUEST in
    1)
        curl -k --location --request POST 'http://observability/api/users' \
            --header 'Content-Type: application/json' \
            --data-raw '{"name": "cloud4devs"}'
        ;;
    2)
        curl -k --location --request POST 'http://observability/api/users' \
            --header 'Content-Type: application/json' \
            --data-raw '{"error": "cloud4devs"}'
        ;;
    3)
        curl -k --location --request GET 'http://observability/api/health'
        ;;
    4)
        curl -k --location --request GET 'http://observability/not-found'
        ;;
    *)
        echo ""
        ;;
    esac

    sleep 0.5

done