#!/bin/bash

echo "Starting base services: Eureka Service Discovery & Configuration Server"

docker-compose -f docker-compose-base.yml up -d --remove-orphans

echo "Waiting for Configuration Server to become available..."

until $(curl --output /dev/null --silent --head --fail http://localhost:8082/env); do
    printf '.'
    sleep 0.5
done

echo ""
echo "The Configuration Server has started."
echo "Starting remaining services..."

docker-compose -f docker-compose-services.yml up -d

echo "Have fun with Elsie-Dee!"
