#!/bin/bash
# Test Claude API call

# Mock Claude API response
mock_response='{
  "content": [
    {
      "text": "This is a test response from Claude.",
      "type": "text"
    }
  ],
  "id": "msg_123",
  "model": "claude-3-5-sonnet-20241022",
  "role": "assistant",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "type": "message",
  "usage": {
    "input_tokens": 10,
    "output_tokens": 8
  }
}'

echo "Testing jq parsing..."
echo "$mock_response" | jq -r '.content[0].text' 2>/dev/null
echo "jq exit code: $?"
