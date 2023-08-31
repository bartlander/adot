#Experiments in OTEL & ADOT Intrumentation for Java & dotNet

References:
* https://github.com/build-on-aws/instrumenting-java-apps-using-opentelemetry
* https://github.com/aws-observability/aws-otel-java-instrumentation/
* https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation
* https://github.com/aws-observability/aws-otel-dotnet
* https://www.mytechramblings.com/posts/getting-started-with-opentelemetry-metrics-and-dotnet-part-2/
* https://aws-otel.github.io/docs/introduction

Prereqs:
  * java 11
  * dotnet 6
  * tested on Linux

# Collector

Either run
  * the **c-localj** OTEL collector using Jaeger - see local (browse results at http://localhost:3000/explore -> Search)
  * the **c-localt** OTEL collector using Tempo - see local (browse results at http://localhost:3000/explore -> Search)
    * not configure for /v1/logs support (traces and metrics ok).
    * [Error] EventSource=OpenTelemetry-Exporter-OpenTelemetryProtocol, Message=Exporter failed send data to collector to http://collector:4318/v1/logs endpoint. Data will not be sent. Exception: System.Net.Http.HttpRequestException: Response status code does not indicate success: 404 (Not Found).
      at System.Net.Http.HttpResponseMessage.EnsureSuccessStatusCode()
      at OpenTelemetry.Exporter.OpenTelemetryProtocol.Implementation.ExportClient.BaseOtlpHttpExportClient`1.SendExportRequest(TRequest request, CancellationToken cancellationToken)
      * see logs from 'docker cp otel-n-app:/log .'
  * the **c-aws** ADOT collector - see aws (browse to X-Ray Traces or Metrics in Cloudwatch)
    * Create a "Zero Spend Budget" to keep within the "Free Plan" using  https://us-east-1.console.aws.amazon.com/billing/home#/budgets/
    * Create an access key using https://us-east-1.console.aws.amazon.com/iamv2/home?region=ap-southeast-2#/users/details/<user>?section=security_credentials
    * Using region: ap-southeast-2
    * Create a default local profile with region/access key using *aws cli*

# Local

Browse to http://localhost:3000/explore -> Explore ->
  * Jaeger -> Search -> Service Name
  * Prometheus -> Select metric 

## AWS Metrics

https://us-east-1.console.aws.amazon.com/cloudwatch/home?region=us-east-1#metricsV2:graph=~()
* All metrics -> OTeLib -> ... -> Source

# Client app

## java (port 1111)
- auto and manual instrumentation

### metrics

Source
```
{
    "metrics": [
        [ "otel-j-app", "custom.metric.number.of.exec", "OTelLib", "io.opentelemetry.metrics.hello", { "id": "m1" } ]
    ],
    "sparkline": true,
    "view": "gauge",
    "stacked": false,
    "region": "ap-southeast-2",
    "liveData": true,
    "yAxis": {
        "left": {
            "min": 0,
            "max": 10
        }
    },
    "stat": "Sum",
    "period": 30,
    "setPeriodToTimeRange": false,
    "trend": true
}
```

## dotnet (port 1112)
- auto instrumentation

### metrics

Source
```
{
    "metrics": [
        [ "otel-n-app", "http.server.duration", "OTelLib", "OpenTelemetry.Instrumentation.AspNetCore", { "id": "m1" } ]
    ],
    "sparkline": true,
    "view": "gauge",
    "stacked": false,
    "region": "ap-southeast-2",
    "liveData": true,
    "yAxis": {
        "left": {
            "min": 0,
            "max": 10
        }
    },
    "stat": "Sum",
    "period": 30,
    "setPeriodToTimeRange": false,
    "trend": true
}
```

### issue

When using AWS ADOT collector
    * [Error] EventSource=OpenTelemetry-Exporter-OpenTelemetryProtocol, Message=Exporter failed send data to collector to http://collector:4318/v1/logs endpoint. Data will not be sent. Exception: System.Net.Http.HttpRequestException: Response status code does not indicate success: 404 (Not Found).


## dotnetm (post 1113)
- manual instrumentation

#Test

with: ./hello.sh
