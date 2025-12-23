#!/bin/bash
# Test: get_trash
# Trash operations (NOT testing empty_trash - destructive)
# Requires: TEST_DB_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_DB_UUID" ]; then
  echo "ERROR: Set TEST_DB_UUID environment variable"
  exit 1
fi

echo "=== Testing get_trash ==="
call_tool "get_trash" '{"database":"'"$TEST_DB_UUID"'"}'

# Note: empty_trash is intentionally not tested as it's destructive
echo ""
echo "(empty_trash not tested - destructive operation)"
