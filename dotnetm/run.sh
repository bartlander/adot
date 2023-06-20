#https://github.com/aws-observability/aws-otel-dotnet/tree/main/integration-test-app

docker rm -f otel-n-test; docker image rm -f aspnetapp; docker image prune -f
docker-compose down
docker build -t aspnetapp .
docker-compose up #--remove-orphans
