//
//  JSONRPCTypes.swift
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

// MARK: - JSON-RPC Types

struct JSONRPCRequest: Codable {
  let jsonrpc: String
  let id: RequestID?
  let method: String
  let params: AnyCodable?
}

struct JSONRPCResponse: Codable {
  let jsonrpc: String
  let id: RequestID?
  let result: AnyCodable?
  let error: JSONRPCError?

  init(id: RequestID?, result: AnyCodable?, error: JSONRPCError?) {
    self.jsonrpc = "2.0"
    self.id = id
    self.result = result
    self.error = error
  }
}

struct JSONRPCError: Codable {
  let code: Int
  let message: String
  let data: AnyCodable?
}

enum RequestID: Codable, Equatable {
  case string(String)
  case int(Int)
  case null

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let intVal = try? container.decode(Int.self) {
      self = .int(intVal)
    }
    else if let strVal = try? container.decode(String.self) {
      self = .string(strVal)
    }
    else {
      self = .null
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .string(let s): try container.encode(s)
    case .int(let i): try container.encode(i)
    case .null: try container.encodeNil()
    }
  }
}
