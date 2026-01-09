---
name: dt-include
description: Re-include a previously excluded DEVONthink database. Use when user says include, unhide, or unblock a database.
---

# Include Database

Re-include a previously excluded DEVONthink database in MCP access.

## Instructions

1. If the user provides a database name, first call `list_excluded_databases` to get UUIDs
2. Call `include_database` with the UUID
3. Confirm the database is now accessible
