#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | x(c+b)"
  exit 0
}
c() {
  echo "clean..."
  docker rm -f otel-n-app > /dev/null 2>&1
  docker image rm otel-n-app
  dotnet clean src/src.sln
  find . -type d \( -name obj -o -name bin \) -exec rm -rf {} \;
  #docker compose down -v
  rm -rf target log
}
cc() {
  c
  rm -f otel-dotnet-auto-install.sh
}
otel-agent() {
  if [[ ! -e target/otel-dotnet-auto-install.sh ]]; then
    if [[ -e ../tmp/otel-dotnet-auto-install.sh ]]; then
      cp ../tmp/otel-dotnet-auto-install.sh target
    else
      #tag=v0.7.0
      gh release download $tag -p otel-dotnet-auto-install.sh --repo open-telemetry/opentelemetry-dotnet-instrumentation --dir target
      mkdir -p ../tmp
      cp target/otel-dotnet-auto-install.sh ../tmp
    fi
    OTEL_DOTNET_AUTO_HOME="target/otel-dotnet-auto" sh target/otel-dotnet-auto-install.sh
  fi
}
b() {
  echo "build..."
  docker rm -f otel-n-app > /dev/null 2>&1
  docker compose down -v
  dotnet publish src/src.sln -o target
  #dotnet target/otel-n-app.dll --urls "http://localhost:8889"
  otel-agent
  docker compose up -d
  #docker exec -it otel-n-app bash
  #docker cp otel-n-app:/log .
}
x() {
  c
  b
}

$cmd

sleep 2
docker ps
echo
echo ../hello.sh n
