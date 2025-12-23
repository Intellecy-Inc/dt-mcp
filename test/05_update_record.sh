#!/bin/bash
# Test: update_record
# Update record properties
# Requires: TEST_RECORD_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_RECORD_UUID" ]; then
  echo "ERROR: Set TEST_RECORD_UUID environment variable"
  exit 1
fi

echo "=== Testing update_record (name) ==="
call_tool "update_record" '{"uuid":"'"$TEST_RECORD_UUID"'","name":"Updated Test Document"}'

echo ""
echo "=== Testing update_record (comment) ==="
call_tool "update_record" '{"uuid":"'"$TEST_RECORD_UUID"'","comment":"This is a test comment"}'

echo ""
echo "=== Testing update_record (rating) ==="
call_tool "update_record" '{"uuid":"'"$TEST_RECORD_UUID"'","rating":4}'

echo ""
echo "=== Testing update_record (label) ==="
call_tool "update_record" '{"uuid":"'"$TEST_RECORD_UUID"'","label":2}'

echo ""
echo "=== Testing update_record (flagged) ==="
call_tool "update_record" '{"uuid":"'"$TEST_RECORD_UUID"'","flagged":true}'
