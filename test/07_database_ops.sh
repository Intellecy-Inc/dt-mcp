#!/bin/bash
# Test: get_database, verify_database, optimize_database
# Database operations
# Requires: TEST_DB_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_DB_UUID" ]; then
  echo "ERROR: Set TEST_DB_UUID environment variable"
  exit 1
fi

echo "=== Testing get_database ==="
call_tool "get_database" '{"uuid":"'"$TEST_DB_UUID"'"}'

echo ""
echo "=== Testing verify_database ==="
call_tool "verify_database" '{"uuid":"'"$TEST_DB_UUID"'"}'

echo ""
echo "=== Testing optimize_database ==="
call_tool "optimize_database" '{"uuid":"'"$TEST_DB_UUID"'"}'
