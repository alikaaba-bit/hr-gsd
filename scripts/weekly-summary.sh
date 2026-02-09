#!/bin/bash

# Weekly Summary Generator Script
# This script can be run manually or via cron

# Configuration
API_URL="${API_URL:-http://localhost:3000}"
ENDPOINT="/api/weekly-summary"

# Optional: specify a specific week
WEEK_START="$1"  # Pass as first argument, e.g., ./weekly-summary.sh 2026-02-03

echo "Generating weekly summary..."
echo "API URL: $API_URL"

if [ -n "$WEEK_START" ]; then
  echo "Week: $WEEK_START"
  curl -s "${API_URL}${ENDPOINT}?weekStart=${WEEK_START}" | jq .
else
  echo "Week: Current week"
  curl -s "${API_URL}${ENDPOINT}" | jq .
fi

echo ""
echo "Done!"