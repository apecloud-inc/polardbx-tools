FROM --platform=linux/amd64 openjdk:8-jdk-alpine

RUN apk add --no-cache build-base make bash
RUN apk update && apk add --no-cache maven curl

WORKDIR /app

COPY . /app

WORKDIR /app/frodo
RUN chmod +x build.sh
RUN ./build.sh

# Set environment variables
ENV JAVA_XMS 512M
ENV JAVA_XMX 2G
ENV JAR_FILE frodo-core-1.1.33.jar
ENV FILE outout_log.json
ENV SOURCE_DB mysql
ENV REPLAY_TO mysql
ENV PORT 3306
ENV HOST 172.18.0.4
ENV USERNAME aaa
ENV PASSWORD Abc123456
ENV LOG_LEVEL info
ENV DATABASE test
ENV CONCURRENCY 64
ENV TIME 1000
ENV TASK task1
ENV RATE_FACTOR 1

# CMD instruction using environment variables
CMD ["java", "-Xms${JAVA_XMS}", "-Xmx${JAVA_XMX}", "-jar", "${JAR_FILE}", \
    "--file=${FILE}", \
    "--source-db=${SOURCE_DB}", "--replay-to=${REPLAY_TO}", "--port=${PORT}", "--host=${HOST}", "--username=${USERNAME}", "--password=${PASSWORD}", \
    "--log-level=${LOG_LEVEL}", "--database=${DATABASE}", \
    "--concurrency=${CONCURRENCY}", "--time=${TIME}", "--task=${TASK}", "--rate-factor=${RATE_FACTOR}"]
