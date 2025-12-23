#!/bin/bash
# Test: get_reminders, set_reminder, clear_reminder
# Reminder operations
# Requires: TEST_RECORD_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_RECORD_UUID" ]; then
  echo "ERROR: Set TEST_RECORD_UUID environment variable"
  exit 1
fi

echo "=== Testing get_reminders (all) ==="
call_tool "get_reminders" '{}'

echo ""
echo "=== Testing set_reminder ==="
call_tool "set_reminder" '{"uuid":"'"$TEST_RECORD_UUID"'","date":"January 1, 2026","alarm":true}'

echo ""
echo "=== Testing get_reminders (specific record) ==="
call_tool "get_reminders" '{"uuid":"'"$TEST_RECORD_UUID"'"}'

echo ""
echo "=== Testing clear_reminder ==="
call_tool "clear_reminder" '{"uuid":"'"$TEST_RECORD_UUID"'"}'
