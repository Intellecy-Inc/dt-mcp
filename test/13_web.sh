#!/bin/bash
# Test: create_bookmark, download_url, download_markdown
# Web operations
# Requires: TEST_DB_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_DB_UUID" ]; then
  echo "ERROR: Set TEST_DB_UUID environment variable"
  exit 1
fi

TEST_URL="https://www.example.com"

echo "=== Testing create_bookmark ==="
call_tool "create_bookmark" '{"url":"'"$TEST_URL"'","name":"Example Bookmark","database":"'"$TEST_DB_UUID"'"}'

echo ""
echo "=== Testing download_url ==="
call_tool "download_url" '{"url":"'"$TEST_URL"'","database":"'"$TEST_DB_UUID"'"}'

echo ""
echo "=== Testing download_markdown ==="
call_tool "download_markdown" '{"url":"'"$TEST_URL"'","database":"'"$TEST_DB_UUID"'"}'
