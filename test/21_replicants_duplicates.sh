#!/bin/bash
# Test: get_replicants, get_duplicates
# Replicant and duplicate detection
# Requires: TEST_RECORD_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_RECORD_UUID" ]; then
  echo "ERROR: Set TEST_RECORD_UUID environment variable"
  exit 1
fi

echo "=== Testing get_replicants ==="
call_tool "get_replicants" '{"uuid":"'"$TEST_RECORD_UUID"'"}'

echo ""
echo "=== Testing get_duplicates ==="
call_tool "get_duplicates" '{"uuid":"'"$TEST_RECORD_UUID"'"}'
