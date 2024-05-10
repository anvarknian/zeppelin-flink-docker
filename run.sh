#!/bin/bash

FLINK_VERSION="1.15.4"
SCALA_VERSION="2.12"
FLINK_SQL="1.6.0"

if [ -d "./flink" ]; then
    echo "Flink exists"
else
    curl -o flink.tar https://archive.apache.org/dist/flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-scala_${SCALA_VERSION}.tgz
    tar -xvzf flink.tar
    mv flink-${FLINK_VERSION} ./flink
    cp -r flink/opt/flink-table-planner*.jar flink/lib 
    cp -r flink/lib/flink-table-planner-loader*.jar flink/opt 
    curl -o flink/lib/flink-table-api-scala_${SCALA_VERSION}-${FLINK_VERSION}.jar https://repo1.maven.org/maven2/org/apache/flink/flink-table-api-scala_${SCALA_VERSION}/${FLINK_VERSION}/flink-table-api-scala_${SCALA_VERSION}-${FLINK_VERSION}.jar
    curl -o flink/lib/flink-table-api-scala-bridge_${SCALA_VERSION}-${FLINK_VERSION}.jar https://repo1.maven.org/maven2/org/apache/flink/flink-table-api-scala-bridge_${SCALA_VERSION}/${FLINK_VERSION}/flink-table-api-scala-bridge_${SCALA_VERSION}-${FLINK_VERSION}.jar
    curl -o flink/lib/flink-sql-client-${FLINK_SQL}.jar https://repo1.maven.org/maven2/org/apache/flink/flink-sql-client/${FLINK_SQL}/flink-sql-client-${FLINK_SQL}.jar
fi


docker compose down && docker compose up -d

sleep 60

docker exec --user root  zeppelin sh -c 'rm -rf /opt/zeppelin/interpreter/flink/._zeppelin-flink-0.11.1-2.12.jar'
