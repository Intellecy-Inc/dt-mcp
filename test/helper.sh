#!/bin/bash
# Helper functions for dt-mcp tests

DT_MCP="../.build/debug/dt-mcp"

# Initialize and call a tool
call_tool() {
  local tool_name="$1"
  local args="$2"

  echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"'"$tool_name"'","arguments":'"$args"'}}' | $DT_MCP 2>&1 | tail -1 | jq .
}

# Pretty print result
print_result() {
  echo "$1" | jq -r '.result.content[0].text' 2>/dev/null | jq . 2>/dev/null || echo "$1"
}
