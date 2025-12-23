#!/bin/bash
# Test: import_file, export_record
# Import and export operations
# Requires: TEST_DB_UUID, TEST_RECORD_UUID environment variables

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_DB_UUID" ]; then
  echo "ERROR: Set TEST_DB_UUID environment variable"
  exit 1
fi

# Create a test file to import
TEST_FILE="/tmp/dt_mcp_test_import.txt"
echo "This is a test file for import" > "$TEST_FILE"

echo "=== Testing import_file ==="
call_tool "import_file" '{"path":"'"$TEST_FILE"'","database":"'"$TEST_DB_UUID"'","name":"Imported Test File"}'

echo ""
echo "=== Testing export_record ==="
if [ -n "$TEST_RECORD_UUID" ]; then
  EXPORT_PATH="/tmp/dt_mcp_test_export.txt"
  call_tool "export_record" '{"uuid":"'"$TEST_RECORD_UUID"'","path":"'"$EXPORT_PATH"'"}'
  echo "Exported to: $EXPORT_PATH"
else
  echo "Skipped: Set TEST_RECORD_UUID to test export_record"
fi

# Cleanup
rm -f "$TEST_FILE"
