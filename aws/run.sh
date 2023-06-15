#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean)"
  exit 0
}
c() {
  echo "clean..."
  #docker rm -f collector > /dev/null 2>&1
  docker compose down -v
}
b() {
  echo "build..."
  docker compose up -d
}

$cmd

sleep 2
docker ps
