# BAUX-BOT Bug Report: RAG Auto-Summary Trigger Bug

## Bug Summary
**Issue:** baux-bot incorrectly triggers RAG rebuild and auto-summary after every user interaction, even when no repository changes occurred.

**Severity:** High (breaks user experience, makes bot appear "crashed")

**Status:** RESOLVED ✅

## Root Cause
The RAG change detection logic used a faulty `find` command condition that always evaluated to true, causing constant RAG rebuilds and unwanted auto-summaries.

### Faulty Code (Line 668)
```bash
if find "$SRC_ROOT" -newer "$RAG_DIR/current.txt" -print -quit >/dev/null 2>&1; then
    log "$SRC_ROOT changed — rebuilding RAG"
    build_rag
    # ... auto-summary code ...
```

### Problem Analysis
- `find` with `-print -quit` returns exit code 0 whenever the source directory exists
- This happens regardless of whether any files are actually newer than the RAG file
- The condition always triggered, causing unwanted RAG rebuilds and auto-summaries

## Impact
- **User Experience:** Every query followed by unwanted repo change summary
- **Performance:** Unnecessary RAG rebuilds consuming resources
- **Confusion:** Made the bot appear broken/crashed when it was actually working

## Solution
### Fixed Code
```bash
if [[ $(find "$SRC_ROOT" -newer "$RAG_DIR/current.txt" -print -quit 2>/dev/null) ]]; then
    log "$SRC_ROOT changed — rebuilding RAG"
    build_rag
    # ... auto-summary code ...
```

### Explanation
- Capture `find`'s output instead of relying on exit code
- Check if output is non-empty (indicating files were found)
- Only trigger RAG rebuild when repository actually has changes

## Testing
### Before Fix
```bash
$ echo "What is 2+2?" | baux-bot
🔍 RESEARCH QUERY - Routing to GEMINI...
BAUX BOT (auto): [Unwanted repo summary appears]
```

### After Fix
```bash
$ echo "What is 2+2?" | baux-bot
🔍 RESEARCH QUERY - Routing to GEMINI...
[Clean response without auto-summary]
```

## Files Modified
- `/usr/local/bin/baux-bot` (line 668 condition fixed)

## Verification
- ✅ Auto-summaries only appear when repo actually changes
- ✅ RAG rebuilds are triggered appropriately
- ✅ All backend routing works cleanly
- ✅ No performance impact from unnecessary rebuilds

## Prevention
- **Code Review:** Always verify conditional logic with external commands
- **Testing:** Test edge cases where conditions should not trigger
- **Documentation:** Document complex conditional logic clearly

## Related Issues
- None - this was an isolated logic error in the RAG system

---

**Resolution Date:** December 11, 2025
**Fixed By:** Grok (xAI)
**Verified By:** System testing</content>
<parameter name="filePath">ports/baux-bot/BUG-REPORT.md