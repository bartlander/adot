FROM mcr.microsoft.com/dotnet/aspnet:6.0

#ARG OTEL_VERSION=0.7.0
#ADD https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/download/v${OTEL_VERSION}/otel-dotnet-auto-install.sh otel-dotnet-auto-install.sh
#RUN apt-get update && apt-get install -y unzip && apt-get -y install curl && iputils-ping
#RUN OTEL_DOTNET_AUTO_HOME="/otel-dotnet-auto" sh otel-dotnet-auto-install.sh

COPY target .

ENTRYPOINT ["dotnet", "otel-n-app.dll", "--urls", "http://0.0.0.0:1112" ]
