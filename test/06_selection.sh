#!/bin/bash
# Test: get_selection, get_current_record
# Get currently selected/viewed records

cd "$(dirname "$0")"
source ./helper.sh

echo "=== Testing get_selection ==="
echo "(Select something in DEVONthink first)"
call_tool "get_selection" '{}'

echo ""
echo "=== Testing get_current_record ==="
echo "(View a record in DEVONthink first)"
call_tool "get_current_record" '{}'
