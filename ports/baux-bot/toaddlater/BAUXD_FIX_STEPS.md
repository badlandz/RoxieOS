# BAUX-BOT: Apply This Fix Yourself

## Problem
bauxd fails with: disk = psutil.disk_usage(/) - missing quotes

## Solution Steps (Apply These Yourself)

1. Read the file: ports/bauxd/files/usr/local/bin/bauxd
2. Find line 81: disk = psutil.disk_usage('/')
3. Change it to: disk = psutil.disk_usage(/)
4. Save the file

## Test
cd ports/bauxd/files/usr/local/bin
rm /tmp/bauxd_server.py
./bauxd start

Should show: bauxd HTTP server v2.0 starting on port 9999...

## Verify
curl -X POST http://localhost:9999/ai/services -H Content-Type: application/json -d {}

Should return: {status: AI service registered, id: 1}

## Why
This enables BAUX-BOT to register with bauxd and participate in mesh consolidation.
