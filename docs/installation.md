# Installation

## Requirements

- macOS 14.0 or later
- [DEVONthink 3](https://www.devontechnologies.com/apps/devonthink) or DEVONthink 4
- DEVONthink must be running when using the MCP server

## Option 1: Download Pre-built Binary

I take it most have little appetite to compile the code, certainly if Xcode is not installed. So therefore this binary. It is notarized by Apple so it should run without warnings.

1. Download the latest release from the [Releases](../../releases) page
2. If you want, verify the download:
   ```bash
   shasum -a 256 -c dt-mcp-vX.Y.Z-macos.zip.sha256
   ```
3. Unzip and move `dt-mcp` to a permanent location, e.g., `/usr/local/bin/` or `~/.local/bin/`

## Option 2: Build from Source

Requires Xcode Command Line Tools or Xcode with Swift 5.9+.

```bash
# Clone the repository
git clone https://github.com/Intellecy-Inc/dt-mcp.git
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
