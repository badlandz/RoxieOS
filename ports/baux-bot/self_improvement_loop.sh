#!/usr/local/bin/bash
# Safe self-improvement loop for BAUX-BOT

set -euo pipefail

MAX_ITERATIONS=5
iteration=1

echo 🚀 Starting BAUX-BOT Self-Improvement Loop
echo ==========================================
echo Max iterations: 
echo AUTO_APPLY: enabled
echo

while [  -le  ]; do
    echo 🔄 Iteration of 
    echo ========================================
    
    # Check git status before starting
    if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
        echo ❌ Git has uncommitted changes - stopping loop for safety
        exit 1
    fi
    
    # Generate improvement suggestion based on iteration
    improvement=
    case  in
        1)
            improvement=add performance monitoring to track response times and API call durations
            ;;
        2) 
            improvement=implement retry logic with exponential backoff for API calls
            ;;
        3)
            improvement=add context size monitoring and warnings when approaching limits
            ;;
        4)
            improvement=optimize file scanning to avoid duplicate work and reduce I/O
            ;;
        5)
            improvement=add self-improvement loop monitoring and automatic stopping conditions
            ;;
    esac
    
    echo 🎯 Improvement target: 
    echo
    
    # Run improvement with auto-apply
    export AUTO_APPLY=true
    echo improve  | timeout 180 ./baux-bot-hybrid.sh
    
    # Check if the command succeeded
    if [ 0 -ne 0 ]; then
        echo ❌ Iteration failed - stopping loop
        exit 1
    fi
    
    # Brief pause between iterations
    echo ⏳ Pausing for 5 seconds before next iteration...
    sleep 5
    
    iteration=1
    echo
done

echo ✅ Self-improvement loop completed successfully!
echo Final git status:
git status --short
