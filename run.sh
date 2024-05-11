#!/bin/bash

# Source environment variables
source .env

# Function to download files if they don't exist
download_if_not_exists() {
    if [ ! -e "$1" ]; then
        curl -o "$1" "$2" -q
    fi
}

if [ ! -e "${FLINK_FOLDER}.tar" ]; then
    echo "Downloading Flink archive..."
    download_if_not_exists "${FLINK_FOLDER}.tar" "https://archive.apache.org/dist/flink/${FLINK_FOLDER}/${FLINK_FOLDER}-bin-scala_${SCALA_VERSION}.tgz"
fi

if [ ! -d "./${FLINK_FOLDER}" ]; then
    tar -xvzf ${FLINK_FOLDER}.tar
    echo "Copying Flink dependencies..."
    cp -r ${FLINK_FOLDER}/opt/flink-table-planner*.jar ${FLINK_FOLDER}/lib
    cp -r ${FLINK_FOLDER}/lib/flink-table-planner-loader*.jar ${FLINK_FOLDER}/opt

    download_if_not_exists "${FLINK_FOLDER}/lib/flink-table-api-scala_${LIB_VERSION}.jar" "https://repo1.maven.org/maven2/org/apache/flink/flink-table-api-scala_${SCALA_VERSION}/${FLINK_VERSION}/flink-table-api-scala_${LIB_VERSION}.jar"
    download_if_not_exists "${FLINK_FOLDER}/lib/flink-table-api-scala-bridge_${LIB_VERSION}.jar" "https://repo1.maven.org/maven2/org/apache/flink/flink-table-api-scala-bridge_${SCALA_VERSION}/${FLINK_VERSION}/flink-table-api-scala-bridge_${LIB_VERSION}.jar"
    download_if_not_exists "${FLINK_FOLDER}/lib/flink-sql-client-${FLINK_SQL}.jar" "https://repo1.maven.org/maven2/org/apache/flink/flink-sql-client/${FLINK_SQL}/flink-sql-client-${FLINK_SQL}.jar"

    echo "Flink setup completed."
else
    echo "Flink directory exists. Skipping setup."
fi

# Restart Docker Compose
docker-compose down && docker-compose up -d
echo "Zeppelin setup completed."
