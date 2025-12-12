# BAUX-BOT: Fix bauxd Syntax Error

## Problem
bauxd fails with: disk = psutil.disk_usage(/) - missing quotes

## Solution  
In ports/bauxd/files/usr/local/bin/bauxd line 81:
CHANGE: disk = psutil.disk_usage('/')
TO: disk = psutil.disk_usage("/")

## Test
./bauxd start
curl -X POST http://localhost:9999/ai/services -d "{}"

## Why
POST endpoints needed for BAUX-BOT registration with bauxd
