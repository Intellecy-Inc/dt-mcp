# dt-mcp Test Scripts

Test scripts for all dt-mcp commands (except destructive delete operations).

## Setup

1. Create a test database in DEVONthink named "Test" or similar
2. Run `01_list_databases.sh` to get the database UUID
3. Set environment variables:

```bash
export TEST_DB_UUID="your-test-database-uuid"
```

4. Run `03_create_record.sh` to create a test record, then:

```bash
export TEST_RECORD_UUID="uuid-from-create-record-output"
```

5. Run `09_groups.sh` to create a test group, then:

```bash
export TEST_GROUP_UUID="uuid-from-create-group-output"
```

## Running Tests

### Individual tests:
```bash
cd test
chmod +x *.sh
./01_list_databases.sh
```

### All tests:
```bash
./run_all.sh
```

## Test Files

| Script | Commands Tested |
|--------|-----------------|
| 01_list_databases.sh | list_databases |
| 02_search.sh | search |
| 03_create_record.sh | create_record |
| 04_get_record.sh | get_record, get_record_content |
| 05_update_record.sh | update_record |
| 06_selection.sh | get_selection, get_current_record |
| 07_database_ops.sh | get_database, verify_database, optimize_database |
| 08_tags.sh | get_tags, set_record_tags, add_record_tags, remove_record_tags |
| 09_groups.sh | create_group, get_record_children |
| 10_move_duplicate.sh | move_record, duplicate_record, replicate_record |
| 11_import_export.sh | import_file, export_record |
| 12_ai_features.sh | classify, see_also, summarize, get_concordance |
| 13_web.sh | create_bookmark, download_url, download_markdown |
| 14_links.sh | get_incoming_links, get_outgoing_links, get_item_url |
| 15_windows.sh | get_windows, open_record, open_window |
| 16_reminders.sh | get_reminders, set_reminder, clear_reminder |
| 17_smart_groups.sh | get_smart_groups, get_smart_group_contents |
| 18_metadata.sh | get_custom_metadata, set_custom_metadata |
| 19_trash.sh | get_trash |
| 20_annotations.sh | get_annotations |
| 21_replicants_duplicates.sh | get_replicants, get_duplicates |
| 22_ocr.sh | ocr_file, convert_to_searchable_pdf |
| 23_open_close_database.sh | open_database, close_database |

## Not Tested (Destructive)

- `delete_record` - Moves record to trash
- `empty_trash` - Permanently deletes items
