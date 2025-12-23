#!/bin/bash
# Test: ocr_file, convert_to_searchable_pdf
# OCR operations
# Requires: TEST_DB_UUID, TEST_PDF_UUID environment variables

cd "$(dirname "$0")"
source ./helper.sh

if [ -z "$TEST_DB_UUID" ]; then
  echo "ERROR: Set TEST_DB_UUID environment variable"
  exit 1
fi

echo "=== Testing ocr_file ==="
if [ -n "$TEST_IMAGE_PATH" ]; then
  call_tool "ocr_file" '{"path":"'"$TEST_IMAGE_PATH"'","database":"'"$TEST_DB_UUID"'"}'
else
  echo "Skipped: Set TEST_IMAGE_PATH to test ocr_file"
fi

echo ""
echo "=== Testing convert_to_searchable_pdf ==="
if [ -n "$TEST_PDF_UUID" ]; then
  call_tool "convert_to_searchable_pdf" '{"uuid":"'"$TEST_PDF_UUID"'"}'
else
  echo "Skipped: Set TEST_PDF_UUID to test convert_to_searchable_pdf"
fi
