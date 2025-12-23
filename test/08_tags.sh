#!/bin/bash
# Test: get_tags, set_record_tags, add_record_tags, remove_record_tags
# Tag operations
# Requires: TEST_DB_UUID, TEST_RECORD_UUID environment variables

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_DB_UUID" ] || [ -z "$TEST_RECORD_UUID" ]; then
  echo "ERROR: Set TEST_DB_UUID and TEST_RECORD_UUID environment variables"
  exit 1
fi

echo "=== Testing get_tags ==="
call_tool "get_tags" '{"database":"'"$TEST_DB_UUID"'"}'

echo ""
echo "=== Testing set_record_tags ==="
call_tool "set_record_tags" '{"uuid":"'"$TEST_RECORD_UUID"'","tags":["tag1","tag2","test"]}'

echo ""
echo "=== Testing add_record_tags ==="
call_tool "add_record_tags" '{"uuid":"'"$TEST_RECORD_UUID"'","tags":["newtag"]}'

echo ""
echo "=== Testing remove_record_tags ==="
call_tool "remove_record_tags" '{"uuid":"'"$TEST_RECORD_UUID"'","tags":["tag1"]}'
