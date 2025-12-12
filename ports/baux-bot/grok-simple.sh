#!/bin/bash
# Simple GROK API interface - takes question as argument or stdin

API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"

if [[ -z "$API_KEY" ]]; then
    echo "Error: No GROK API key found"
    exit 1
fi

# Get input
if [[ -p /dev/stdin ]]; then
    QUESTION=$(cat)
else
    QUESTION="$1"
fi

if [[ -z "$QUESTION" ]]; then
    echo "Error: No question provided"
    exit 1
fi

# Make API call
RESPONSE=$(curl -s https://api.x.ai/v1/chat/completions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"grok-2-1212\",
    \"messages\": [
      {
        \"role\": \"system\",
        \"content\": \"You are Grok helping build Roxanne Cyberdeck OS. Be direct, technical, and helpful.\"
      },
      {
        \"role\": \"user\",
        \"content\": \"$QUESTION\"
      }
    ],
    \"temperature\": 0.3,
    \"max_tokens\": 1000
  }")

# Extract content
CONTENT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null)

if [[ -n "$CONTENT" && "$CONTENT" != "null" ]]; then
    echo "$CONTENT"
else
    echo "API Error: $RESPONSE"
fi
