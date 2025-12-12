#!/bin/bash
# Simple debug

API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"

curl -s https://api.x.ai/v1/chat/completions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "grok-2-1212",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Context: Three layers: bbase, baux, bwm. Question: What are the three layers?"}
    ],
    "temperature": 0.3
  }' | jq .
