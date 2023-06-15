#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean)"
  exit 0
}
c() {
  echo "clean..."
  #docker rm -f otel-app > /dev/null 2>&1
  docker compose down -v
  mvn clean
}
b() {
  echo "build..."
  #docker rm -f otel-app > /dev/null 2>&1
  docker compose down -v
  mvn package -Dmaven.test.skip=true
  cp dkr-otel/* .  # otel hello
  if [[ ! -e target/opentelemetry-javaagent-all.jar ]]; then
    curl -L https://github.com/aws-observability/aws-otel-java-instrumentation/releases/download/latest/aws-opentelemetry-agent.jar --output target/opentelemetry-javaagent-all.jar
  fi
  docker compose up -d
}

$cmd

sleep 2
docker ps
echo
echo curl -X GET http://localhost:8888/hello
