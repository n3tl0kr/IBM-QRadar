#!/bin/bash

# Parameters passed from QRadar
serverAddress=$1         # PagerDuty API endpoint (fixed)
apiKey=$2                # PagerDuty API key (fixed)
qidName=$3               # QidMap Name (dynamic)
qidDescription=$4        # QidMap Description (dynamic)
severity=$5              # QRadar Event Severity (dynamic)
relevance=$6             # QRadar Event Relevance (dynamic)
credibility=$7           # QRadar Event Credibility (dynamic)
logSource=$8             # Log Source Identifier (dynamic, data source)
sourceIp=$9              # Source IP (dynamic, affected host)
username=${10}           # Username (dynamic)
proxyAddress=${11}       # Proxy address (fixed)

# Ensure that CA bundle is copied from /etc/pki/tls/certs/ca-bundle.crt
# $ cp /etc/pki/tls/certs/ca-bundle.crt /home/customactionuser/

caBundlePath="/home/customactionuser/ca-bundle.crt"

# PagerDuty Priority IDs (replace with your actual IDs from PagerDuty)
P1_ID="XXXXXXX"
P2_ID="XXXXXXX"
P3_ID="XXXXXXX"
P4_ID="XXXXXXX"
P5_ID="XXXXXXX"

# Handle missing/null values
for var in qidName qidDescription severity relevance credibility logSource sourceIp username; do
  eval "val=\$$var"
  if [ -z "$val" ] || [ "$val" == "{}" ] || [ "$val" == "null" ]; then
    eval "$var=Unknown"
  fi
done
for var in severity relevance credibility; do
  eval "val=\$$var"
  if ! [[ "$val" =~ ^[0-9]+$ ]]; then
    eval "$var=0"
  fi
done

# Calculate PagerDuty severity, priority ID, and label
if [ "$severity" -ge 8 ]; then
    pd_severity="critical"
    pd_priority_id="$P1_ID"
    priority_label="P1"
elif [ "$severity" -ge 5 ]; then
    pd_severity="error"
    pd_priority_id="$P2_ID"
    priority_label="P2"
elif [ "$severity" -ge 2 ]; then
    pd_severity="warning"
    pd_priority_id="$P3_ID"
    priority_label="P3"
elif [ "$severity" -ge 1 ]; then
    pd_severity="info"
    pd_priority_id="$P4_ID"
    priority_label="P4"
else
    pd_severity="info"
    pd_priority_id="$P5_ID"
    priority_label="P5"
fi

summary="QRadar ${priority_label} Escalation: ${qidName} at ${sourceIp}"

payload=$(printf '{
    "routing_key": "%s",
    "event_action": "trigger",
    "payload": {
        "summary": "%s",
        "severity": "%s",
        "source": "%s",
        "custom_details": {
            "QID Description": "%s",
            "Username": "%s",
            "Log Source": "%s"
        },
        "priority": {"id": "%s"}
    }
}' "$apiKey" "$summary" "$pd_severity" "$logSource" "$qidDescription" "$username" "$logSource" "$pd_priority_id")

# Send the request using curl, capturing both response body and HTTP code
http_response=$(curl -s -w "HTTPSTATUS:%{http_code}" --proxy "$proxyAddress" --cacert "$caBundlePath" -X POST \
-H "Content-Type: application/json" \
-d "$payload" \
"$serverAddress/v2/enqueue")

http_body=$(echo "$http_response" | sed -e 's/HTTPSTATUS\:.*//g')
http_code=$(echo "$http_response" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

if [ "$http_code" == "202" ]; then
    echo "Offense severity $severity converted to $pd_severity with priority $pd_priority_id"
    echo "Success: $pd_severity Alert sent to PagerDuty."
else
    echo "Error: Failed to send alert to PagerDuty."
    echo "HTTP Response Code: $http_code"
    echo "Response Body:"
    echo "$http_body"
fi


