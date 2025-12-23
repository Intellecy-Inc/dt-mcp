#!/bin/bash
# Test: get_windows, open_record, open_window
# Window operations
# Requires: TEST_RECORD_UUID, TEST_DB_UUID environment variables

cd "$(dirname "$0")"
source ./helper.sh

echo "=== Testing get_windows ==="
call_tool "get_windows" '{}'

echo ""
echo "=== Testing open_window ==="
if [ -n "$TEST_DB_UUID" ]; then
  call_tool "open_window" '{"database":"'"$TEST_DB_UUID"'"}'
else
  call_tool "open_window" '{}'
fi

echo ""
echo "=== Testing open_record ==="
if [ -n "$TEST_RECORD_UUID" ]; then
  call_tool "open_record" '{"uuid":"'"$TEST_RECORD_UUID"'"}'
else
  echo "Skipped: Set TEST_RECORD_UUID to test open_record"
fi
