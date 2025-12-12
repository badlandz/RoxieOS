# BAUX-BOT Performance Optimization Instructions

## Critical Performance Issues Identified

### 1. Context Size Management (HIGH PRIORITY)
- Problem: RAG context is 1409 lines (~48KB) rebuilt on every query
- Impact: Massive context sent to AI models, causing timeouts and high costs
- Solution: Implement 8000 token limit with incremental updates

### 2. File Scanning Inefficiency (HIGH PRIORITY)  
- Problem: Scans entire directories then limits to 20 files
- Impact: Unnecessary I/O operations on every context rebuild
- Solution: Limit scanning before processing, use find with head

### 3. No Incremental Context Updates (MEDIUM PRIORITY)
- Problem: Full context rebuild on every query
- Impact: Slow response times, unnecessary work
- Solution: Only rebuild when files actually change

### 4. Missing Retry Logic (MEDIUM PRIORITY)
- Problem: Single API attempts with fixed timeouts
- Impact: Failures on temporary network issues
- Solution: Exponential backoff retry mechanism

## Implementation Priority

1. Phase 1: Context size limits + efficient scanning
2. Phase 2: Incremental updates + retry logic

## Success Criteria

- Context size stays under 8000 tokens
- Response times improve by 50%
- No more timeout failures
- Git safety maintained
- Self-improvement loop remains stable
