FROM openjdk:8-jdk-alpine

WORKDIR /app

COPY /frodo/frodo-core/target/frodo-core-1.1.33.jar /app/
COPY outout_log.json /app/

CMD ["java", "-Xms512M", "-Xmx2G", "-jar", "frodo-core-1.1.33.jar", \
    "--file=outout_log.json", \
    "--source-db=mysql", "--replay-to=mysql", "--port=3306", "--host=172.18.0.4", "--username=aaa", "--password=Grxrrxyrx11", \
    "--log-level=info", "--database=test", \
    "--concurrency=64", "--time=1000", "--task=task1", "--rate-factor=1"]