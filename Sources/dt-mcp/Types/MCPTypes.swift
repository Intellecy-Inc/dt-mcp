//
//  MCPTypes.swift
//  dt-mcp - MCP Server for DEVONthink
//
//  Copyright © 2025 Intellecy Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  NOTICE: This software integrates with DEVONthink, a product of
//  DEVONtechnologies, LLC. DEVONthink is a registered trademark of
//  DEVONtechnologies. This project is not affiliated with or endorsed
//  by DEVONtechnologies.
//

import Foundation

// MARK: - MCP Protocol Types

struct ServerInfo: Codable {
  let name: String
  let version: String
}

struct ServerCapabilities: Codable {
  let tools: ToolsCapability?
  let resources: ResourcesCapability?
  let prompts: PromptsCapability?
}

struct ToolsCapability: Codable {
  let listChanged: Bool?
}

struct ResourcesCapability: Codable {
  let subscribe: Bool?
  let listChanged: Bool?
}

struct PromptsCapability: Codable {
  let listChanged: Bool?
}

struct InitializeResult: Codable {
  let protocolVersion: String
  let capabilities: ServerCapabilities
  let serverInfo: ServerInfo
}

struct Tool: Codable {
  let name: String
  let description: String
  let inputSchema: [String: AnyCodable]
}

struct ToolsListResult: Codable {
  let tools: [Tool]
}

struct TextContent: Codable {
  let type: String
  let text: String

  init(text: String) {
    self.type = "text"
    self.text = text
  }
}

struct ToolResult: Codable {
  let content: [TextContent]
  let isError: Bool?
}
