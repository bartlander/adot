FROM openjdk:11

COPY target/otel-j-app-1.0.jar .
COPY target/aws-opentelemetry-agent.jar .
COPY target/otel.properties .
ENTRYPOINT [ "java", "-javaagent:aws-opentelemetry-agent.jar", "-jar", "otel-j-app-1.0.jar" ]
