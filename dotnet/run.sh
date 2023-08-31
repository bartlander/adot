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
  dotnet clean src/src.sln; find . -type d \( -name obj -o -name bin \) -exec rm -rf {} \; > /dev/null 2>&1
  rm -rf target log
}
cc() {
  hdr "delete"
  c
  rm -f otel-dotnet-auto-install.sh
  docker rm -f otel-n-app > /dev/null 2>&1
  docker image rm -f otel-n-app
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
  if [[ ! -e target/otel-dotnet-auto-install.sh ]]; then
    if [[ -e ../tmp/otel-dotnet-auto-install.sh ]]; then
      echo "...copy existing agent"
      cp ../tmp/otel-dotnet-auto-install.sh target
    else
      echo "...download agent"
      #tag=v0.7.0
      gh release download $tag -p otel-dotnet-auto-install.sh --repo open-telemetry/opentelemetry-dotnet-instrumentation --dir target
      mkdir -p ../tmp
      cp target/otel-dotnet-auto-install.sh ../tmp
    fi
    echo "...iinstall agent"
    OTEL_DOTNET_AUTO_HOME="target/otel-dotnet-auto" sh target/otel-dotnet-auto-install.sh
  fi
  cp App.config target
}
b() {
  hdr "build"
  dotnet publish src/src.sln -o target
  #dotnet target/otel-n-app.dll --urls "http://localhost:1112"
  otel-agent
  docker compose up -d
  #docker exec -it otel-n-app bash
  #docker cp otel-n-app:/log .
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
echo ../hello.sh n
