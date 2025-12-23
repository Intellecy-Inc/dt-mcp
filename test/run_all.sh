#!/bin/bash
# Run all dt-mcp tests
#
# Required environment variables:
#   TEST_DB_UUID       - UUID of test database
#   TEST_RECORD_UUID   - UUID of a test record
#   TEST_GROUP_UUID    - UUID of a test group
#
# Optional:
#   TEST_SMART_GROUP_UUID - UUID of a smart group
#   TEST_PDF_UUID         - UUID of a PDF for OCR testing
#   TEST_IMAGE_PATH       - Path to image for OCR testing
#   TEST_DB_PATH          - Path to .dtBase2 file for open_database test

cd "$(dirname "$0")"

echo "================================"
echo "dt-mcp Test Suite"
echo "================================"
echo ""

if [ -z "$TEST_DB_UUID" ]; then
  echo "ERROR: TEST_DB_UUID not set"
  echo ""
  echo "First, run 01_list_databases.sh to get the UUID of your test database"
  echo "Then: export TEST_DB_UUID=<uuid>"
  echo ""
  exit 1
fi

echo "TEST_DB_UUID:     $TEST_DB_UUID"
echo "TEST_RECORD_UUID: ${TEST_RECORD_UUID:-not set}"
echo "TEST_GROUP_UUID:  ${TEST_GROUP_UUID:-not set}"
echo ""

# Run tests in order
for script in [0-9][0-9]_*.sh; do
  echo ""
  echo "========================================"
  echo "Running: $script"
  echo "========================================"
  bash "$script"
  echo ""
  read -p "Press Enter to continue..."
done

echo ""
echo "All tests completed!"
