#!/bin/bash
# Basic GROK API test

API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"

if [[ -z "$API_KEY" ]]; then
    echo "No API key found"
    exit 1
fi

echo "Testing basic GROK API call..."

# Simple test
RESPONSE=$(curl -s https://api.x.ai/v1/chat/completions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "grok-2-1212",
    "messages": [{"role": "user", "content": "Say hello"}],
    "temperature": 0.3
  }')

echo "Raw response:"
echo "$RESPONSE" | jq . 2>/dev/null || echo "$RESPONSE"

echo
echo "Extracted content:"
echo "$RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null || echo "Failed to extract content"
