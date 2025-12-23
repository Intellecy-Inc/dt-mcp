#!/bin/bash
# Test: open_database, close_database
# Database open/close operations
# Note: Be careful with these - they affect DEVONthink state

cd "$(dirname "$0")"
source ./helper.sh

echo "=== Testing open_database ==="
if [ -n "$TEST_DB_PATH" ]; then
  call_tool "open_database" '{"path":"'"$TEST_DB_PATH"'"}'
else
  echo "Skipped: Set TEST_DB_PATH to test open_database"
  echo "Example: /Users/you/Documents/Knowledge/Test.dtBase2"
fi

echo ""
echo "=== Testing close_database ==="
if [ -n "$TEST_DB_UUID" ]; then
  echo "WARNING: This will close the test database!"
  echo "Uncomment the line below to test"
  # call_tool "close_database" '{"uuid":"'"$TEST_DB_UUID"'"}'
else
  echo "Skipped: Set TEST_DB_UUID to test close_database"
fi
