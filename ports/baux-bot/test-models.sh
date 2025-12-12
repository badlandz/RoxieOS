#!/bin/bash
# Test different Ollama models for BAUX-BOT optimization

set -euo pipefail

MODELS=("smollm2:135m" "llama3.2:3b")
TEST_QUESTIONS=(
    "What is Roxanne?"
    "How can I improve error handling in BAUX-BOT?"
    "What are the three layers of the architecture?"
    "Suggest a new feature for cyberdeck development"
)

echo "🧪 BAUX-BOT Model Optimization Test"
echo "===================================="

for model in "${MODELS[@]}"; do
    echo
    echo "🔬 Testing model: $model"
    echo "------------------------"
    
    for question in "${TEST_QUESTIONS[@]}"; do
        echo
        echo "Question: $question"
        echo "Response:"
        
        # Time the response
        start_time=$(date +%s.%3N)
        response=$(echo "$question" | ollama run "$model" --nowordwrap 2>/dev/null || echo "ERROR")
        end_time=$(date +%s.%3N)
        
        # Calculate response time
        response_time=$(echo "$end_time - $start_time" | bc 2>/dev/null || echo "0")
        
        echo "$response"
        echo "⏱️  Time: ${response_time}s"
        echo "---"
    done
done

echo
echo "📊 Model Comparison Complete"
