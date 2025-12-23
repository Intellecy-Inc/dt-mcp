#!/bin/bash
# Test: search
# Search for records in DEVONthink
# Requires: TEST_DB_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

echo "=== Testing search (all databases) ==="
call_tool "search" '{"query":"test"}'

echo ""
echo "=== Testing search (specific database) ==="
if [ -n "$TEST_DB_UUID" ]; then
  call_tool "search" '{"query":"test","database":"'"$TEST_DB_UUID"'"}'
else
  echo "Skipped: Set TEST_DB_UUID to test database-specific search"
fi
