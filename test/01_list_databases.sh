#!/bin/bash
# Test: list_databases
# Lists all open DEVONthink databases

cd "$(dirname "$0")"
source ./helper.sh

echo "=== Testing list_databases ==="
call_tool "list_databases" "{}"
