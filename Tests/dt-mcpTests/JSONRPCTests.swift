//
//  JSONRPCTests.swift
//  dt-mcp tests
//
//  Every MCP request and response flows through these Codable types, so the
//  round-trip must not lose data — for any AnyCodable payload, with any of the
//  three JSON-RPC id forms.
//

import Testing
import Foundation
@testable import dt_mcp

@Suite("JSON-RPC envelope and AnyCodable round-trip")
struct JSONRPCTests {

  let encoder: JSONEncoder = {
    let e = JSONEncoder()
    e.outputFormatting = [.sortedKeys]
    return e
  }()
  let decoder = JSONDecoder()

  // MARK: - AnyCodable: happy paths

  @Test("AnyCodable round-trips a string")
  func anyCodableString() throws {
    let original = AnyCodable("hello")
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(AnyCodable.self, from: data)
    #expect(decoded.value as? String == "hello")
  }

  @Test("AnyCodable round-trips a nested dict with mixed value types")
  func anyCodableNestedDict() throws {
    let original = AnyCodable([
      "name": "dt-mcp",
      "version": "0.6.2",
      "enabled": true,
      "count": 42
    ] as [String: Any])
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(AnyCodable.self, from: data)
    let dict = decoded.value as? [String: Any]
    #expect(dict?["name"] as? String == "dt-mcp")
    #expect(dict?["enabled"] as? Bool == true)
  }

  @Test("AnyCodable round-trips an array")
  func anyCodableArray() throws {
    let original = AnyCodable(["a", "b", "c"])
    let data = try encoder.encode(original)
    let decoded = try decoder.decode(AnyCodable.self, from: data)
    let arr = decoded.value as? [Any]
    #expect((arr?[0] as? String) == "a")
    #expect((arr?[2] as? String) == "c")
  }

  @Test("AnyCodable round-trips null as NSNull")
  func anyCodableNull() throws {
    let data = "null".data(using: .utf8)!
    let decoded = try decoder.decode(AnyCodable.self, from: data)
    #expect(decoded.value is NSNull)
  }

  // MARK: - JSONRPCRequest: id forms

  @Test("request decodes with integer id")
  func requestIntId() throws {
    let json = #"{"jsonrpc":"2.0","id":1,"method":"tools/list"}"#
    let req = try decoder.decode(JSONRPCRequest.self, from: Data(json.utf8))
    #expect(req.method == "tools/list")
    if case .int(let n) = req.id! { #expect(n == 1) } else { Issue.record("expected int id") }
  }

  @Test("request decodes with string id")
  func requestStringId() throws {
    let json = #"{"jsonrpc":"2.0","id":"abc","method":"ping"}"#
    let req = try decoder.decode(JSONRPCRequest.self, from: Data(json.utf8))
    if case .string(let s) = req.id! { #expect(s == "abc") } else { Issue.record("expected string id") }
  }

  @Test("request decodes a notification (id absent)")
  func requestNotification() throws {
    let json = #"{"jsonrpc":"2.0","method":"initialized"}"#
    let req = try decoder.decode(JSONRPCRequest.self, from: Data(json.utf8))
    #expect(req.id == nil)
    #expect(req.method == "initialized")
  }

  // MARK: - JSONRPCResponse: shapes

  @Test("successful response encodes with result and no error field")
  func successResponse() throws {
    let resp = JSONRPCResponse(
      id: .int(7),
      result: AnyCodable(["ok": true] as [String: Any]),
      error: nil
    )
    let data = try encoder.encode(resp)
    let json = String(data: data, encoding: .utf8) ?? ""
    #expect(json.contains("\"id\":7"))
    #expect(json.contains("\"result\""))
  }

  @Test("error response encodes with error field")
  func errorResponse() throws {
    let resp = JSONRPCResponse(
      id: .int(8),
      result: nil,
      error: JSONRPCError(code: -32601, message: "Method not found", data: nil)
    )
    let data = try encoder.encode(resp)
    let json = String(data: data, encoding: .utf8) ?? ""
    #expect(json.contains("\"code\":-32601"))
    #expect(json.contains("Method not found"))
  }

  // MARK: - Bad paths

  @Test("decoding a malformed request throws")
  func decodeMalformed() {
    let bad = Data(#"{ this is not json"#.utf8)
    #expect(throws: (any Error).self) {
      try decoder.decode(JSONRPCRequest.self, from: bad)
    }
  }

  @Test("decoding a request missing method throws")
  func decodeMissingMethod() {
    let json = Data(#"{"jsonrpc":"2.0","id":1}"#.utf8)
    #expect(throws: (any Error).self) {
      try decoder.decode(JSONRPCRequest.self, from: json)
    }
  }
}
