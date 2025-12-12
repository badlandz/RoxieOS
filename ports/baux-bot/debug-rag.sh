#!/bin/bash
# Debug RAG building

PROJECT_ROOT="/src/roxanne"
RAG_DIR="./rag"

mkdir -p "$RAG_DIR"

echo "Building RAG..."
rag_file="$RAG_DIR/current.txt"

echo "=== ROXANNE CYBERDECK PROJECT CONTEXT ===" > "$rag_file"
echo "Generated: $(date)" >> "$rag_file"

echo "File created:"
ls -la "$rag_file"
echo "Content:"
cat "$rag_file"
