FROM openjdk:11

COPY target/otel-app-1.0.jar .
COPY opentelemetry-javaagent-all .
ENTRYPOINT [ "java", "-javaagent:opentelemetry-javaagent-all.jar", "-jar", "otel-app-1.0.jar" ]
