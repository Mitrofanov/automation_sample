#!/bin/bash -e

AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

echo "suchname=$AZ" > /tmp/application.properties

exec java -Dspring.config.location=/tmp/application.properties \
-jar /app.jar

"$@"
