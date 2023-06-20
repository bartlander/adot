#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | x(c+b)"
  exit 0
}
c() {
  echo "clean..."
  #docker rm -f collector > /dev/null 2>&1
  docker compose down -v
}
cc() {
  c
}
b() {
  echo "build..."
  docker compose up -d
}
x() {
  c
  b
}

$cmd

sleep 2
docker ps
