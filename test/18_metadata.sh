#!/bin/bash
# Test: get_custom_metadata, set_custom_metadata
# Custom metadata operations
# Requires: TEST_RECORD_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_RECORD_UUID" ]; then
  echo "ERROR: Set TEST_RECORD_UUID environment variable"
  exit 1
fi

echo "=== Testing set_custom_metadata ==="
call_tool "set_custom_metadata" '{"uuid":"'"$TEST_RECORD_UUID"'","key":"testKey","value":"testValue"}'

echo ""
echo "=== Testing get_custom_metadata ==="
call_tool "get_custom_metadata" '{"uuid":"'"$TEST_RECORD_UUID"'"}'
