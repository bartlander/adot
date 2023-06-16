#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | x(c+b)"
  exit 0
}
c() {
  echo "clean..."
  #docker rm -f otel-app > /dev/null 2>&1
  docker compose down -v
  docker image rm otel-app
  mvn clean
  rm -rf target
}
b() {
  echo "build..."
  #docker rm -f otel-app > /dev/null 2>&1
  docker compose down -v
  mvn package -Dmaven.test.skip=true
  if [[ ! -e target/opentelemetry-javaagent-all.jar ]]; then
    #tag="v1.26.0"
    gh release download $tag -p aws-opentelemetry-agent.jar --repo aws-observability/aws-otel-java-instrumentation --dir target
    #gh release download $tag -p aws-opentelemetry-agent.jar --repo aws-observability/aws-otel-java-instrumentation --output target/opentelemetry-javaagent-all.jar
    #curl -L https://github.com/aws-observability/aws-otel-java-instrumentation/releases/download/v1.26.0/aws-opentelemetry-agent.jar --output target/opentelemetry-javaagent-all.jar
  fi
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
echo curl -X GET http://localhost:8888/hello
