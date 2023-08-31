#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | x(c+b)"
  exit 0
}
hdr() {
  echo "-----------------------------"
  echo "$1..."
}
c() {
  hdr "clean"
  docker compose down -v --remove-orphans
  mvn clean
  rm -rf target
}
cc() {
  hdr "delete"
  c
  rm -f aws-opentelemetry-agent.jar
  docker rm -f otel-j-app > /dev/null 2>&1
  docker image rm -f otel-j-app
  docker image prune -f
}
i() {
  hdr "initialize"
  docker network inspect m2m > /dev/null 2>&1 || {
      echo docker network create m2m
      docker network create m2m
  }
}
otel-agent() {
  hdr "validate agent"
  if [[ ! -e target/aws-opentelemetry-agent.jar ]]; then
    if [[ -e aws-opentelemetry-agent.jar ]]; then
      echo "...copy existing agent"
      cp aws-opentelemetry-agent.jar target
    else
      echo "...download agent"
      #tag="v1.26.0"
      gh release download $tag -p aws-opentelemetry-agent.jar --repo aws-observability/aws-otel-java-instrumentation --dir target
      cp target/aws-opentelemetry-agent.jar .
    fi
  fi
}
b() {
  hdr "build"
  mvn package -Dmaven.test.skip=true
  otel-agent
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
echo
echo ../hello.sh j
#./run.sh x; echo '-----'; docker exec -it otel-j-app bash -c 'cat /otel.properties'; sleep 5; echo '-----'; ../hello.sh j 3
