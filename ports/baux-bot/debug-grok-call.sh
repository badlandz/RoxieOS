#!/bin/bash
# Debug the GROK call in hybrid script

API_KEY="${GROK_API_KEY:-${GROK_KEY:-}}"

if [[ -z "$API_KEY" ]]; then
    echo "No API key"
    exit 1
fi

# Simulate the query_grok function
question="How can I improve error handling?"
context="Short test context"

prompt="You are an expert AI assistant for Roxanne Cyberdeck OS development.

PROJECT CONTEXT:
$context

QUESTION: $question

Provide detailed, technical, actionable advice."

echo "Prompt length: ${#prompt}"
echo "API Key length: ${#API_KEY}"

# Test the curl call
response=$(curl -s -w "\nHTTP_STATUS:%{http_code}" https://api.x.ai/v1/chat/completions \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"grok-2-1212\",
    \"messages\": [
      {
        \"role\": \"system\",
        \"content\": \"You are Grok, expert in FreeBSD, tmux, AI systems, and cyberdeck development.\"
      },
      {
        \"role\": \"user\",
        \"content\": \"$prompt\"
      }
    ],
    \"temperature\": 0.3,
    \"max_tokens\": 1500
  }")

echo "Full response:"
echo "$response"
