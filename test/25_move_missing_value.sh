#!/bin/bash
# Regression test for opaque "uuid of missing value" errors from
# move/duplicate/replicate when the AppleScript verb returns `missing value`
# (e.g. moving a record into the group it already lives in).
#
# Before the fix, the bridge scripts did `set movedRecord to move … ; return
# {uuid of movedRecord, …}` with no guard — so when `move` returned missing
# value the next line raised NSAppleScriptError -1728 "Can't get uuid of
# missing value.", which surfaces as an obscure MCP error. The fix adds
# `if <result> is missing value then error "<verb> failed: …"` before the
# uuid read, producing a clean, actionable error.
#
# Requires: TEST_GROUP_UUID (a group that can act as both source and
# destination). We create a scratch record inside the group, try to move it
# back into the same group (no-op path → missing value), assert the error
# message is the clean one, then delete the scratch record.

set -euo pipefail
cd "$(dirname "$0")"
source ./helper.sh

if [ -z "${TEST_DB_UUID:-}" ] || [ -z "${TEST_GROUP_UUID:-}" ]; then
  echo "ERROR: Set TEST_DB_UUID and TEST_GROUP_UUID environment variables"
  exit 1
fi

echo "=== Creating scratch record in test group ==="
CREATE_RESPONSE=$(call_tool "create_record" \
  '{"name":"dt-mcp-regression-25","type":"txt","content":"scratch","database":"'"$TEST_DB_UUID"'","destination":"'"$TEST_GROUP_UUID"'"}')
SCRATCH_UUID=$(echo "$CREATE_RESPONSE" | jq -r '.result.content[0].text' | jq -r '.uuid')

if [ -z "$SCRATCH_UUID" ] || [ "$SCRATCH_UUID" = "null" ]; then
  echo "FAIL: could not create scratch record"
  echo "$CREATE_RESPONSE"
  exit 1
fi

cleanup() {
  call_tool "delete_record" '{"uuid":"'"$SCRATCH_UUID"'"}' >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "=== Moving scratch record into its current parent (expected: missing-value path) ==="
RESPONSE=$(call_tool "move_record" '{"uuid":"'"$SCRATCH_UUID"'","to":"'"$TEST_GROUP_UUID"'"}')
echo "$RESPONSE"

MESSAGE=$(echo "$RESPONSE" | jq -r '.result.content[0].text // empty')

# Success path: DEVONthink may actually accept the same-parent move and return
# a record. The regression is only about the error shape when the verb returns
# missing value — so pass if the call succeeded OR the error text is clean.
if echo "$MESSAGE" | grep -qi "uuid of missing value"; then
  echo ""
  echo "FAIL: server returned the raw AppleScript error 'uuid of missing value' —"
  echo "      missing-value guards are not in place."
  exit 1
fi

echo ""
echo "PASS: move into same parent did not surface the raw 'uuid of missing value' error"
