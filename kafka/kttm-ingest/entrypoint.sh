#!/usr/bin/env bash

cat <<EOT >> /tmp/client.properties
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-256
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
username="user1" password=$KAFKA_PASSWORD;
EOT

kafka-topics.sh \
  --command-config /tmp/client.properties \
  --bootstrap-server "$KAFKA_SERVERS" \
  --create --topic "$KAFKA_TOPIC"

export KAFKA_OPTS="-Dfile.encoding=UTF-8"

cd /tmp || exit
curl -O https://static.imply.io/example-data/kttm-nested-v2/kttm-nested-v2-2019-08-25.json.gz
zcat ./kttm-nested-v2-2019-08-25.json.gz | \
  kafka-console-producer.sh \
  --producer.config /tmp/client.properties \
  --broker-list "$KAFKA_SERVERS" --topic "$KAFKA_TOPIC"
