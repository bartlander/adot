FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build-env
WORKDIR /app
COPY ./src ./
RUN dotnet publish otel-n-test/*.csproj -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
EXPOSE 1113
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "otel-n-test.dll"]
