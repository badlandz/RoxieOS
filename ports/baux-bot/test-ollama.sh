#!/bin/bash
echo "Testing Ollama directly..."
echo "Hello" | ollama run smollm2:135m --nowordwrap
echo "Done"
