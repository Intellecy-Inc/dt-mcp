# dt-mcp

An MCP (Model Context Protocol) server for [DEVONthink](https://www.devontechnologies.com/apps/devonthink), enabling AI assistants like Claude to interact with your DEVONthink databases.

## Features

- **Database Operations**: List databases, search records, navigate groups
- **Record Management**: Create, read, update, and organize records
- **Content Access**: Get record content in plain text, Markdown, or HTML
- **AI Features**: Classify documents, find similar records, summarize, concordance
- **Web Capture**: Create bookmarks, download web pages as archives or Markdown
- **Metadata**: Tags, labels, ratings, custom metadata, reminders
- **Links**: Item links, incoming/outgoing references

## Requirements

- macOS 14.0 or later
- [DEVONthink 3](https://www.devontechnologies.com/apps/devonthink) or DEVONthink 4
- DEVONthink must be running when using the MCP server

## Installation

### Option 1: Download Pre-built Binary (Recommended)

1. Download the latest release from the [Releases](../../releases) page
2. Verify the download (optional):
   ```bash
   shasum -a 256 -c dt-mcp-vX.Y.Z-macos.zip.sha256
   ```
3. Unzip and move `dt-mcp` to a permanent location, e.g., `/usr/local/bin/` or `~/.local/bin/`
4. The binary is signed and notarized by Apple, so it should run without warnings

### Option 2: Build from Source

Requires Xcode Command Line Tools or Xcode with Swift 5.9+.

```bash
# Clone the repository
git clone https://github.com/intellecy/dt-mcp.git
cd dt-mcp

# Build release binary
swift build -c release

# Binary location: .build/release/dt-mcp
```

## Configuration

### Claude Code

Add to your project's `.mcp.json` or global `~/.claude/mcp.json`:

```json
{
  "mcpServers": {
    "dt-mcp": {
      "command": "/path/to/dt-mcp"
    }
  }
}
```

Then restart Claude Code or run `/mcp` to reload servers.

### Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "dt-mcp": {
      "command": "/path/to/dt-mcp"
    }
  }
}
```

## Available Tools

### Database & Navigation
| Tool | Description |
|------|-------------|
| `list_databases` | List all open DEVONthink databases |
| `search` | Search records with optional database filter |
| `get_record` | Get record metadata by UUID |
| `get_record_content` | Get record content (plain/markdown/html) |
| `get_record_children` | Get children of a group |
| `get_selection` | Get currently selected records |

### Record Management
| Tool | Description |
|------|-------------|
| `create_record` | Create a new record |
| `create_group` | Create a new group |
| `update_record` | Update record properties |
| `move_record` | Move record to another group |
| `delete_record` | Move record to trash |
| `duplicate_record` | Duplicate a record |
| `replicate_record` | Create a replicant |

### Tags & Metadata
| Tool | Description |
|------|-------------|
| `get_tags` | Get all tags in a database |
| `set_record_tags` | Set tags (replaces existing) |
| `add_record_tags` | Add tags to a record |
| `remove_record_tags` | Remove tags from a record |
| `get_custom_metadata` | Get custom metadata |
| `set_custom_metadata` | Set custom metadata |

### AI Features
| Tool | Description |
|------|-------------|
| `classify` | Get classification suggestions |
| `see_also` | Find similar records |
| `summarize` | Get document summary |
| `get_concordance` | Get word concordance |

### Web Operations
| Tool | Description |
|------|-------------|
| `create_bookmark` | Create a bookmark |
| `download_url` | Download URL as web archive |
| `download_markdown` | Download URL as Markdown |

### Links & References
| Tool | Description |
|------|-------------|
| `get_item_url` | Get x-devonthink-item:// URL |
| `get_incoming_links` | Get incoming references |
| `get_outgoing_links` | Get outgoing references |

### Database Operations
| Tool | Description |
|------|-------------|
| `get_database` | Get database details |
| `open_database` | Open a database file |
| `close_database` | Close a database |
| `verify_database` | Verify database integrity |
| `optimize_database` | Optimize database |

### Import/Export & OCR
| Tool | Description |
|------|-------------|
| `import_file` | Import a file into DEVONthink |
| `export_record` | Export record to filesystem |
| `ocr_file` | OCR a file and import |
| `convert_to_searchable_pdf` | Convert to searchable PDF |

### Windows & UI
| Tool | Description |
|------|-------------|
| `get_windows` | List open windows |
| `open_record` | Open record in new tab |
| `open_window` | Open new window |
| `get_current_record` | Get currently viewed record |

### Other
| Tool | Description |
|------|-------------|
| `get_reminders` | Get record reminders |
| `set_reminder` | Set a reminder |
| `clear_reminder` | Remove a reminder |
| `get_smart_groups` | List smart groups |
| `get_smart_group_contents` | Get smart group results |
| `get_trash` | Get trash contents |
| `empty_trash` | Empty database trash |
| `get_annotations` | Get record annotations |
| `get_replicants` | Get record parent locations |
| `get_duplicates` | Find duplicate records |

## Usage Examples

Once configured, you can ask Claude questions like:

- "List my DEVONthink databases"
- "Search for documents about machine learning"
- "Show me the contents of [record name]"
- "Create a new markdown note called 'Meeting Notes' in the Inbox"
- "What tags are in my research database?"
- "Find documents similar to this one"

## Troubleshooting

### Server not connecting
- Ensure DEVONthink is running
- Check the path in your MCP configuration is correct
- Run `/mcp` in Claude Code to reload servers

### Permission errors
- DEVONthink may prompt for automation permission on first use
- Grant permission in System Settings > Privacy & Security > Automation

### macOS blocking the binary
- Right-click the binary and select "Open"
- Or: `xattr -d com.apple.quarantine /path/to/dt-mcp`

## License

Copyright 2025 Intellecy Inc.

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.

## Disclaimer

This project is not affiliated with or endorsed by DEVONtechnologies, LLC. DEVONthink is a registered trademark of DEVONtechnologies.
