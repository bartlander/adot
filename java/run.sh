#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | x(c+b)"
  exit 0
}
c() {
  echo "clean..."
  docker rm -f otel-j-app > /dev/null 2>&1
  docker image rm otel-j-app
  #docker compose down -v
  mvn clean
  rm -rf target
}
cc() {
  c
  rm -f aws-opentelemetry-agent.jar
}
otel-agent() {
  if [[ ! -e target/aws-opentelemetry-agent.jar ]]; then
    if [[ -e aws-opentelemetry-agent.jar ]]; then
      cp aws-opentelemetry-agent.jar target
    else
      #tag="v1.26.0"
      gh release download $tag -p aws-opentelemetry-agent.jar --repo aws-observability/aws-otel-java-instrumentation --dir target
      cp target/aws-opentelemetry-agent.jar .
    fi
  fi
}
b() {
  echo "build..."
  #docker rm -f otel-j-app > /dev/null 2>&1
  docker compose down -v
  mvn package -Dmaven.test.skip=true
  otel-agent
  docker compose up -d
}
x() {
  c
  b
}

$cmd

sleep 2
docker ps
echo
echo ../hello.sh j
