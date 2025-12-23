//
//  Package.swift
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

// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "dt-mcp",
  platforms: [
    .macOS(.v14)
  ],
  products: [
    .executable(name: "dt-mcp", targets: ["dt-mcp"])
  ],
  targets: [
    .executableTarget(
      name: "dt-mcp",
      path: "Sources/dt-mcp"
    )
  ]
)
