#!/bin/bash

echo "## remove stack"
docker-compose kill
docker-compose rm -f
