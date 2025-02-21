#!/bin/sh

# Default values
DEFAULT_CHECK_INTERVAL=60
DEFAULT_INFLUX_URL="http://influxdb:8086"
DEFAULT_INFLUX_TOKEN="YOUR_AUTH_TOKEN"
DEFAULT_INFLUX_ORG="my-org"
DEFAULT_INFLUX_BUCKET="internet-check"

CHECK_INTERVAL=${CHECK_INTERVAL:-$DEFAULT_CHECK_INTERVAL}
INFLUX_URL=${INFLUX_URL:-$DEFAULT_INFLUX_URL}
INFLUX_TOKEN=${INFLUX_TOKEN:-$DEFAULT_INFLUX_TOKEN}
INFLUX_ORG=${INFLUX_ORG:-$DEFAULT_INFLUX_ORG}
INFLUX_BUCKET=${INFLUX_BUCKET:-$DEFAULT_INFLUX_BUCKET}

echo "Интервал проверки: $CHECK_INTERVAL секунд"
echo "InfluxDB URL: $INFLUX_URL"
echo "InfluxDB Token: $INFLUX_TOKEN"
echo "InfluxDB Organization: $INFLUX_ORG"
echo "InfluxDB Bucket: $INFLUX_BUCKET"

while true; do
  TIMESTAMP=$(date +%s)
  if ping -c 1 google.com &> /dev/null
  then
    STATUS="UP"
  else
    STATUS="DOWN"
  fi

  # Send to InfluxDB
  curl -i -XPOST "$INFLUX_URL/api/v2/write?org=$INFLUX_ORG&bucket=$INFLUX_BUCKET" \
    --header "Authorization: Token $INFLUX_TOKEN" \
    --data-raw "internet_status,host=$(hostname) status=\"$STATUS\" $TIMESTAMP"

  # Waiting
  sleep $CHECK_INTERVAL
done