Java app adapted from the excellent tutorial at https://github.com/build-on-aws/instrumenting-java-apps-using-opentelemetry

dotnet app adapted from above plus https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation

# Collector

Either run
  * a local OTEL collector - see local (browse results at http://localhost:3000/explore -> Search)
  * the AWS ADOT collector - see aws (browse to x-Ray Traces or Metrics in Cloudwatch)

# Client app

Now run

java (port 8888)

dotnet (port 8889)

#Test

with: ./hello.sh

# Issues

  1. dotnet gathers metrics but no logging

```
  See docker cp otel-n-app:/log .
  [2023-06-19T05:30:20.6148099Z] [Error] EventSource=OpenTelemetry-Exporter-OpenTelemetryProtocol, Message=Exporter failed send data to collector to http://collector:5555/ endpoint. Data will not be sent. Exception: Grpc.Core.RpcException: Status(StatusCode="Unimplemented", Detail="unknown service opentelemetry.proto.collector.logs.v1.LogsService")
     at Grpc.Net.Client.Internal.HttpClientCallInvoker.BlockingUnaryCall[TRequest,TResponse](Method`2 method, String host, CallOptions options, TRequest request)
     at Grpc.Core.Interceptors.InterceptingCallInvoker.<BlockingUnaryCall>b__3_0[TRequest,TResponse](TRequest req, ClientInterceptorContext`2 ctx)
     at Grpc.Core.ClientBase.ClientBaseConfiguration.ClientBaseConfigurationInterceptor.BlockingUnaryCall[TRequest,TResponse](TRequest request, ClientInterceptorContext`2 context, BlockingUnaryCallContinuation`2 continuation)
     at Grpc.Core.Interceptors.InterceptingCallInvoker.BlockingUnaryCall[TRequest,TResponse](Method`2 method, String host, CallOptions options, TRequest request)
     at OpenTelemetry.Proto.Collector.Logs.V1.LogsService.LogsServiceClient.Export(ExportLogsServiceRequest request, CallOptions options)
     at OpenTelemetry.Proto.Collector.Logs.V1.LogsService.LogsServiceClient.Export(ExportLogsServiceRequest request, Metadata headers, Nullable`1 deadline, CancellationToken cancellationToken)
     at OpenTelemetry.Exporter.OpenTelemetryProtocol.Implementation.ExportClient.OtlpGrpcLogExportClient.SendExportRequest(ExportLogsServiceRequest request, CancellationToken cancellationToken) 
```
