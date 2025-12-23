#!/bin/bash
# Test: create_record
# Creates a new record in DEVONthink
# Requires: TEST_DB_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_DB_UUID" ]; then
  echo "ERROR: Set TEST_DB_UUID environment variable"
  exit 1
fi

echo "=== Testing create_record (markdown) ==="
call_tool "create_record" '{"name":"Test Document","type":"markdown","content":"# Test\n\nThis is a test document created by dt-mcp.","database":"'"$TEST_DB_UUID"'","tags":["test","mcp"]}'

echo ""
echo "=== Testing create_record (plain text) ==="
call_tool "create_record" '{"name":"Test Plain Text","type":"txt","content":"This is plain text content.","database":"'"$TEST_DB_UUID"'"}'
