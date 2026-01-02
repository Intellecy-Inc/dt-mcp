# Troubleshooting

## Server not connecting

- Ensure DEVONthink is running
- Check the path in your MCP configuration is correct
- Run `/mcp` in Claude Code to reload servers

## Permission errors

- DEVONthink may prompt for automation permission on first use
- Grant permission in System Settings > Privacy & Security > Automation

## macOS blocking the binary

- Right-click the binary and select "Open"
- Or: `xattr -d com.apple.quarantine /path/to/dt-mcp`
