#!/bin/bash
# Test: classify, see_also, summarize, get_concordance
# AI and analysis features
# Requires: TEST_RECORD_UUID environment variable

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_RECORD_UUID" ]; then
  echo "ERROR: Set TEST_RECORD_UUID environment variable"
  exit 1
fi

echo "=== Testing classify ==="
call_tool "classify" '{"uuid":"'"$TEST_RECORD_UUID"'"}'

echo ""
echo "=== Testing see_also ==="
call_tool "see_also" '{"uuid":"'"$TEST_RECORD_UUID"'","count":5}'

echo ""
echo "=== Testing summarize ==="
call_tool "summarize" '{"uuid":"'"$TEST_RECORD_UUID"'"}'

echo ""
echo "=== Testing get_concordance ==="
call_tool "get_concordance" '{"uuid":"'"$TEST_RECORD_UUID"'"}'
