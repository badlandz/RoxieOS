PRIORITY 1: Implement context size limits - add MAX_CONTEXT_SIZE=8000 and size tracking
PRIORITY 2: Fix file scanning inefficiency - use find with printf and sort instead of head after scan
PRIORITY 3: Add incremental context updates - only rebuild when files change
PRIORITY 4: Implement retry logic with exponential backoff for API calls
