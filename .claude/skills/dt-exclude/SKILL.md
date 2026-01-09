---
name: dt-exclude
description: Exclude a DEVONthink database from MCP access. Use when user says exclude, hide, or block a database.
---

# Exclude Database

Exclude a DEVONthink database from MCP access.

## Instructions

1. If the user provides a database name, first call `list_databases` to find the UUID
2. Call `exclude_database` with the UUID
3. Confirm the exclusion was successful
