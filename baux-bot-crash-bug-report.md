# BAUX-BOT Crash Bug Report
**Issue:** baux-bot crashes to bash prompt after successful AI routing

## Incident Report

**Date:** December 10, 2025
**Version:** BAUX BOT v6.4-dev-f8236ef8
**Platform:** FreeBSD .133 (x300 laptop)
**Deployment:** `./install.sh -f` (force reinstall)

## Reproduction Steps

1. Start BAUX: `baux`
2. In tmux pane: `baux-bot`
3. Ask question: "so what isn't rock solid in baux yet"
4. Bot routes correctly to Gemini: "🔍 RESEARCH QUERY - Routing to GEMINI..."
5. Bot crashes back to bash prompt with no response

## Expected Behavior

- Bot should route to Gemini API
- Receive response from Gemini
- Display response: "BAUX BOT: [gemini response]"
- Continue interactive session

## Actual Behavior

- Routing message displays correctly
- No API response received
- Immediate crash to bash prompt
- No error messages visible
- Debug logging added but not yet tested

## Technical Details

### Routing Logic (Working)
```bash
# Query analysis successful
is_research > is_coding → Routes to Gemini
Routing message: "🔍 RESEARCH QUERY - Routing to GEMINI..."
```

### API Call (Likely Failing)
```bash
# ask_gemini() function
response=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$GEMINI_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"contents\": [{
      \"parts\": [{\"text\": \"$prompt\"}]
    }]
  }" | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null)
```

### Response Processing (Crash Point)
```bash
if [[ -n "$response" && "$response" != "null" ]]; then
  echo "$response"  # ← Likely crash here
  update_rate_limit "gemini"
  log_usage "gemini" "research"
else
  echo "Gemini API quota exceeded or call failed - falling back to Ollama"
  ask_ollama "$prompt"
fi
```

## Debug Information Added

**Added to main response handler:**
```bash
# Debug: log the response before echoing
log "Response received: ${response:0:100}..."
echo -e "BAUX BOT: $response"
log "Response echoed successfully"
```

**Check logs after next test:**
```bash
tail -f ~/.baux-bot/chatlogs/current.log
```

## Possible Causes

### 1. API Response Issues
- Gemini API returning malformed JSON
- jq parsing failing silently
- Response contains special characters causing echo failure

### 2. Rate Limiting
- API quota exceeded
- Rate limit counters malfunctioning

### 3. Script Logic Error
- Conditional logic failing
- Variable scoping issues
- set -euo pipefail causing exit on error

### 4. Network/SSL Issues
- curl failing silently
- SSL certificate problems
- DNS resolution issues

## Test Cases to Verify

### API Key Validation
```bash
# Check if GEMINI_API_KEY is set
echo "$GEMINI_API_KEY" | head -c 10
```

### Manual API Test
```bash
# Test Gemini API directly
curl -v -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$GEMINI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"contents": [{"parts": [{"text": "test"}]}]}'
```

### JQ Parsing Test
```bash
# Test response parsing
echo '{"candidates": [{"content": {"parts": [{"text": "test response"}]}}]}' | jq -r '.candidates[0].content.parts[0].text'
```

## Mitigation Steps

### Immediate
1. Test with debug logging enabled
2. Check API key validity
3. Test manual API calls
4. Verify network connectivity

### Short-term
1. Add more robust error handling
2. Implement fallback logic for API failures
3. Add timeout handling for API calls
4. Improve response validation

### Long-term
1. Implement circuit breaker pattern
2. Add API health monitoring
3. Create offline fallback mode
4. Implement response caching

## Status

**Priority:** HIGH (Blocking AI functionality)
**Assignee:** Next debugging session
**ETA:** After workflow implementation
**Risk:** Users cannot access AI assistance features

## Related Issues

- RAG rebuilding on every launch (mesh persistence issue)
- Version identification confusion (workflow issue)
- Port installation failures (deployment pipeline issue)

---

**Next Action:** Test with debug logging enabled to identify exact failure point.</content>
<filePath>baux-bot-crash-bug-report.md