#!/bin/bash
# Test: perform_smart_rule
# Triggers an existing DEVONthink smart rule. Smart rules are configured in the
# DEVONthink UI — this tool cannot create them.
#
# Requires: TEST_SMART_RULE_NAME (a rule that exists in DEVONthink).
# Optional: TEST_RECORD_UUID (to scope the rule to a single record).

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_SMART_RULE_NAME" ]; then
  echo "ERROR: Set TEST_SMART_RULE_NAME to the name of an existing smart rule in DEVONthink"
  exit 1
fi

echo "=== Testing perform_smart_rule (by name) ==="
if [ -n "$TEST_RECORD_UUID" ]; then
  call_tool "perform_smart_rule" '{"name":"'"$TEST_SMART_RULE_NAME"'","record":"'"$TEST_RECORD_UUID"'"}'
else
  call_tool "perform_smart_rule" '{"name":"'"$TEST_SMART_RULE_NAME"'"}'
fi

echo ""
echo "=== Testing perform_smart_rule (invalid trigger rejected) ==="
call_tool "perform_smart_rule" '{"name":"'"$TEST_SMART_RULE_NAME"'","trigger":"not-a-real-event"}'
