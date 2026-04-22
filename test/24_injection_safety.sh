#!/bin/bash
# Regression test for AppleScript injection via unescaped newline in tool arguments.
#
# Sends a search query containing a literal newline plus what would be a
# standalone AppleScript statement if the enclosing string literal ever broke.
# With a correct escape() the newline is encoded as \n inside the AppleScript
# string literal and DEVONthink treats the whole payload as a search term,
# returning normally (empty or whatever matches). With a broken escape() the
# script source is malformed and AppleScript returns a parse/runtime error,
# which we detect as "isError":true in the JSON-RPC response.
#
# NOTE: we do not try to detect actual code execution — that would require a
# side-effect oracle. We detect the malformed-script signature, which is what
# a naive escape() produces on this input.

set -euo pipefail
cd "$(dirname "$0")"
source ./helper.sh

echo "=== Injection safety: newline in search query ==="

# JSON-escaped payload: literal newline (\n in JSON = real LF in the string),
# followed by a line that would parse as AppleScript if the string literal broke.
PAYLOAD='"injection_test\" \nend tell\ntell application id \"DNtp\"\nreturn \"pwn"'

RESPONSE=$(call_tool "search" '{"query":'"$PAYLOAD"'}')

echo "$RESPONSE"

IS_ERROR=$(echo "$RESPONSE" | jq -r '.result.isError // empty')
if [ "$IS_ERROR" = "true" ]; then
  echo ""
  echo "FAIL: server returned isError=true — escape() likely let the newline through"
  echo "      and AppleScript failed to parse the resulting script."
  exit 1
fi

echo ""
echo "PASS: search with newline-containing query returned a normal response"
