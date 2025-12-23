#!/bin/bash
# Test: create_group, get_record_children
# Group operations
# Requires: TEST_DB_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_DB_UUID" ]; then
  echo "ERROR: Set TEST_DB_UUID environment variable"
  exit 1
fi

echo "=== Testing create_group ==="
call_tool "create_group" '{"name":"Test Group","database":"'"$TEST_DB_UUID"'"}'

echo ""
echo "=== Testing get_record_children (on root) ==="
if [ -n "$TEST_GROUP_UUID" ]; then
  call_tool "get_record_children" '{"uuid":"'"$TEST_GROUP_UUID"'"}'
else
  echo "Skipped: Set TEST_GROUP_UUID to test get_record_children"
fi
