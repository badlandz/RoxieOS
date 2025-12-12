#!/usr/local/bin/bash
# Test bauxd integration functions

source ./baux-bot-hybrid.sh

echo Testing bauxd functions...
echo 1. Testing discover_ai_services:
discover_ai_services

echo
echo 2. Testing register_with_bauxd:
register_with_bauxd

echo
echo Test complete.
