FROM openjdk:11

COPY target/otel-app-1.0.jar .
COPY target/aws-opentelemetry-agent.jar .
ENTRYPOINT [ "java", "-javaagent:aws-opentelemetry-agent.jar", "-jar", "otel-app-1.0.jar" ]
