#!/bin/bash

cmd=${1:-usage}
usage() {
  echo "$0 b(uild) | c(lean) | i(nit)"
  exit 0
}
i() {
  echo "docker pull mcr.microsoft.com/dotnet/sdk:6.0"
  echo "docker pull mcr.microsoft.com/dotnet/samples"
  echo "docker run -it --rm -p 8000:80 --name aspnetcore_sample mcr.microsoft.com/dotnet/samples:aspnetapp"
  #dotnet new webapi -o otel-app
  #dotnet new sln; dotnet sln add otel-app
  echo "cd otel-app; dotnet restore; dotnet publish -o target"
  #dotnet publish -c Release -o out
}
c() {
  echo "clean..."
  #docker rm -f otel-app > /dev/null 2>&1
  docker compose down -v
  docker image rm otel-app
  rm -rf target
}
b() {
  echo "build..."
  #docker rm -f otel-app > /dev/null 2>&1
  docker compose down -v
  if [[ ! -e target/otel-dotnet-auto-install.sh ]]; then
    curl -L https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/download/v0.7.0/otel-dotnet-auto-install.sh --output target/otel-dotnet-auto-install.sh
    sh target/otel-dotnet-auto-install.sh
    cp -r $HOME/.otel-dotnet-auto target
  fi
  cd src
  #dotnet new webapi -o otel-app; dotnet new sln; dotnet sln add otel-app;
  dotnet restore; dotnet publish -o ../target
  cd -
  docker compose up -d
}

$cmd

sleep 2
docker ps
echo
echo curl -X GET http://localhost:8888/hello
