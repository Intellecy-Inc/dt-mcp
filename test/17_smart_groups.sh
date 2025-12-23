#!/bin/bash
# Test: get_smart_groups, get_smart_group_contents
# Smart group operations
# Requires: TEST_DB_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_DB_UUID" ]; then
  echo "ERROR: Set TEST_DB_UUID environment variable"
  exit 1
fi

echo "=== Testing get_smart_groups ==="
call_tool "get_smart_groups" '{"database":"'"$TEST_DB_UUID"'"}'

echo ""
echo "=== Testing get_smart_group_contents ==="
if [ -n "$TEST_SMART_GROUP_UUID" ]; then
  call_tool "get_smart_group_contents" '{"uuid":"'"$TEST_SMART_GROUP_UUID"'"}'
else
  echo "Skipped: Set TEST_SMART_GROUP_UUID to test get_smart_group_contents"
fi
