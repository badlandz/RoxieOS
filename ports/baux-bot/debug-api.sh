#!/bin/bash
# Debug the API call

PAYLOAD='{"question": "What are the three layers?", "context": "Three layers: bbase, baux, bwm"}'
QUESTION="What are the three layers?"
CONTEXT="Three layers: bbase, baux, bwm"
API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"

echo "QUESTION: $QUESTION"
echo "CONTEXT: $CONTEXT"
echo

SYSTEM_CONTENT="You are Grok helping build Roxanne Cyberdeck OS. You have access to the current project context. Be direct, technical, and helpful.

PROJECT CONTEXT:
$CONTEXT

Based on this context, answer the user's question."

echo "SYSTEM_CONTENT: $SYSTEM_CONTENT"
echo

# Show the curl command
echo "API CALL:"
curl -v -s https://api.x.ai/v1/chat/completions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "grok-2-1212",
    "messages": [
      {"role": "system", "content": "'"$SYSTEM_CONTENT"'"},
      {"role": "user", "content": "'"$QUESTION"'"}
    ],
    "temperature": 0.3,
    "max_tokens": 1000
  }' 2>&1 | head -20
