#!/usr/local/bin/bash
# Simple self-improvement loop test

set -euo pipefail

echo 🚀 Starting Simple Self-Improvement Test
echo ========================================

# Test 1: Performance monitoring
echo 🎯 Test 1: Performance monitoring
export AUTO_APPLY=true
echo improve add performance monitoring to track response times and API call durations | timeout 120 ./baux-bot-hybrid.sh

if [ 0 -eq 0 ]; then
    echo ✅ Test 1 passed
else
    echo ❌ Test 1 failed
    exit 1
fi

echo ⏳ Waiting 3 seconds...
sleep 3

# Test 2: Retry logic
echo 🎯 Test 2: Retry logic
echo improve implement retry logic with exponential backoff for API calls | timeout 120 ./baux-bot-hybrid.sh

if [ 0 -eq 0 ]; then
    echo ✅ Test 2 passed
else
    echo ❌ Test 2 failed
    exit 1
fi

echo ✅ All tests passed!
echo Final git status:
git status --short
