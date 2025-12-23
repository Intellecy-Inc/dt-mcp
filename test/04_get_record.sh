#!/bin/bash
# Test: get_record, get_record_content
# Get record metadata and content
# Requires: TEST_RECORD_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_RECORD_UUID" ]; then
  echo "ERROR: Set TEST_RECORD_UUID environment variable"
  exit 1
fi

echo "=== Testing get_record ==="
call_tool "get_record" '{"uuid":"'"$TEST_RECORD_UUID"'"}'

echo ""
echo "=== Testing get_record_content (plain) ==="
call_tool "get_record_content" '{"uuid":"'"$TEST_RECORD_UUID"'","format":"plain"}'

echo ""
echo "=== Testing get_record_content (markdown) ==="
call_tool "get_record_content" '{"uuid":"'"$TEST_RECORD_UUID"'","format":"markdown"}'

echo ""
echo "=== Testing get_record_content (html) ==="
call_tool "get_record_content" '{"uuid":"'"$TEST_RECORD_UUID"'","format":"html"}'
