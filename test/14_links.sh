#!/bin/bash
# Test: get_incoming_links, get_outgoing_links, get_item_url
# Link operations
# Requires: TEST_RECORD_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_RECORD_UUID" ]; then
  echo "ERROR: Set TEST_RECORD_UUID environment variable"
  exit 1
fi

echo "=== Testing get_incoming_links ==="
call_tool "get_incoming_links" '{"uuid":"'"$TEST_RECORD_UUID"'"}'

echo ""
echo "=== Testing get_outgoing_links ==="
call_tool "get_outgoing_links" '{"uuid":"'"$TEST_RECORD_UUID"'"}'

echo ""
echo "=== Testing get_item_url ==="
call_tool "get_item_url" '{"uuid":"'"$TEST_RECORD_UUID"'"}'
