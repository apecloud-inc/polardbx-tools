FROM openjdk:8-jdk-alpine

RUN apk add --no-cache build-base make bash
RUN apk update && apk add --no-cache maven curl python3 python3-dev py3-pip

WORKDIR /app

COPY . /app

WORKDIR /app/frodo
RUN chmod +x build.sh
RUN ./build.sh

