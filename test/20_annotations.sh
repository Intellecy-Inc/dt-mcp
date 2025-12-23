#!/bin/bash
# Test: get_annotations
# Annotation operations
# Requires: TEST_RECORD_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_RECORD_UUID" ]; then
  echo "ERROR: Set TEST_RECORD_UUID environment variable"
  exit 1
fi

echo "=== Testing get_annotations ==="
call_tool "get_annotations" '{"uuid":"'"$TEST_RECORD_UUID"'"}'
