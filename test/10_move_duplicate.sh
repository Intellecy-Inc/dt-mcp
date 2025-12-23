#!/bin/bash
# Test: move_record, duplicate_record, replicate_record
# Record movement and duplication
# Requires: TEST_RECORD_UUID, TEST_GROUP_UUID environment variables

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_RECORD_UUID" ] || [ -z "$TEST_GROUP_UUID" ]; then
  echo "ERROR: Set TEST_RECORD_UUID and TEST_GROUP_UUID environment variables"
  exit 1
fi

echo "=== Testing duplicate_record ==="
call_tool "duplicate_record" '{"uuid":"'"$TEST_RECORD_UUID"'"}'

echo ""
echo "=== Testing replicate_record ==="
call_tool "replicate_record" '{"uuid":"'"$TEST_RECORD_UUID"'","to":"'"$TEST_GROUP_UUID"'"}'

echo ""
echo "=== Testing move_record ==="
if [ -n "$TEST_DUPLICATE_UUID" ]; then
  call_tool "move_record" '{"uuid":"'"$TEST_DUPLICATE_UUID"'","to":"'"$TEST_GROUP_UUID"'"}'
else
  echo "Skipped: Set TEST_DUPLICATE_UUID to test move_record"
fi
