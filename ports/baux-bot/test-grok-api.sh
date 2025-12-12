#!/bin/bash
# Test GROK API directly

API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"

if [[ -z "$API_KEY" ]]; then
    echo "No API key"
    exit 1
fi

echo "Testing GROK API..."

RESPONSE=$(curl -s https://api.x.ai/v1/chat/completions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "grok-2-1212",
    "messages": [{"role": "user", "content": "Hello test"}],
    "temperature": 0.3
  }')

echo "Response:"
echo "$RESPONSE"

echo
echo "Extracted content:"
echo "$RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null || echo "Parse error"
