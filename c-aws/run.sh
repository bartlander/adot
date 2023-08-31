#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | x(c+b)"
  exit 0
}
c() {
  echo "clean..."
  docker compose down -v --remove-orphans
}
cc() {
  c
  docker rm -f collector > /dev/null 2>&1
}
i() {
    docker network inspect m2m > /dev/null 2>&1 || {
        echo docker network create m2m
        docker network create m2m
    }
}
b() {
  echo "build..."
  docker compose up -d
}
x() {
  c
  i
  b
}

$cmd

sleep 2
docker ps
echo docker logs collector -f
