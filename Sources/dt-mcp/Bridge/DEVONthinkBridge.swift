//
//  DEVONthinkBridge.swift
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

// MARK: - DEVONthink Bridge (AppleScript-based)

class DEVONthinkBridge {

  func runAppleScript(_ script: String) throws -> NSAppleEventDescriptor {
    var error: NSDictionary?
    guard let appleScript = NSAppleScript(source: script) else {
      throw MCPError.appleScriptFailed
    }

    let result = appleScript.executeAndReturnError(&error)
    if let error = error {
      let msg = error.description
      FileHandle.standardError.write(Data("[dt-mcp] AppleScript error: \(msg)\n".utf8))
      throw MCPError.appleScriptError(msg)
    }
    return result
  }

  var isRunning: Bool {
    let script = """
    tell application "System Events"
      set isRunning to exists (processes where name is "DEVONthink")
    end tell
    return isRunning
    """
    do {
      let result = try runAppleScript(script)
      return result.booleanValue
    }
    catch {
      return false
    }
  }

  // MARK: - Helpers

  func escape(_ str: String) -> String {
    // Order matters: backslash first so we don't double-escape the escapes we
    // introduce below. Newlines/returns/tabs must be encoded as their AppleScript
    // escape sequences; leaving them raw ends the current string literal and
    // allows arbitrary script to be appended (injection via tool argument).
    return str.replacingOccurrences(of: "\\", with: "\\\\")
              .replacingOccurrences(of: "\"", with: "\\\"")
              .replacingOccurrences(of: "\n", with: "\\n")
              .replacingOccurrences(of: "\r", with: "\\r")
              .replacingOccurrences(of: "\t", with: "\\t")
  }

  func parseRecordList(_ descriptor: NSAppleEventDescriptor, keys: [String]) -> [[String: Any]] {
    var result: [[String: Any]] = []
    let count = descriptor.numberOfItems
    guard count > 0 else { return result }
    for i in 1...count {
      guard let item = descriptor.atIndex(i) else { continue }
      var entry: [String: Any] = [:]
      for (index, key) in keys.enumerated() {
        entry[key] = item.atIndex(index + 1)?.stringValue ?? ""
      }
      result.append(entry)
    }
    return result
  }

  func parseSimpleRecord(_ descriptor: NSAppleEventDescriptor) -> [String: Any] {
    return [
      "uuid": descriptor.atIndex(1)?.stringValue ?? "",
      "name": descriptor.atIndex(2)?.stringValue ?? "",
      "path": descriptor.atIndex(3)?.stringValue ?? ""
    ]
  }

  func parseRecord(_ descriptor: NSAppleEventDescriptor) -> [String: Any] {
    guard descriptor.numberOfItems >= 16 else {
      FileHandle.standardError.write(Data("[dt-mcp] parseRecord: expected 16 fields, got \(descriptor.numberOfItems)\n".utf8))
      return ["uuid": "", "name": "", "error": "Malformed record descriptor"]
    }

    var tags: [String] = []
    if let tagsDesc = descriptor.atIndex(5), tagsDesc.numberOfItems > 0 {
      for i in 1...tagsDesc.numberOfItems {
        if let tag = tagsDesc.atIndex(i)?.stringValue {
          tags.append(tag)
        }
      }
    }

    return [
      "uuid": descriptor.atIndex(1)?.stringValue ?? "",
      "name": descriptor.atIndex(2)?.stringValue ?? "",
      "path": descriptor.atIndex(3)?.stringValue ?? "",
      "location": descriptor.atIndex(4)?.stringValue ?? "",
      "tags": tags,
      "rating": descriptor.atIndex(6)?.int32Value ?? 0,
      "label": descriptor.atIndex(7)?.int32Value ?? 0,
      "flagged": descriptor.atIndex(8)?.booleanValue ?? false,
      "unread": descriptor.atIndex(9)?.booleanValue ?? false,
      "wordCount": descriptor.atIndex(10)?.int32Value ?? 0,
      "characterCount": descriptor.atIndex(11)?.int32Value ?? 0,
      "pageCount": descriptor.atIndex(12)?.int32Value ?? 0,
      "creationDate": descriptor.atIndex(13)?.stringValue ?? "",
      "modificationDate": descriptor.atIndex(14)?.stringValue ?? "",
      "comment": descriptor.atIndex(15)?.stringValue ?? "",
      "url": descriptor.atIndex(16)?.stringValue ?? ""
    ]
  }

  func parseCustomMetadata(_ descriptor: NSAppleEventDescriptor) -> [String: Any] {
    var result: [String: Any] = [:]
    guard descriptor.numberOfItems > 0 else { return result }
    for i in 1...descriptor.numberOfItems {
      guard let item = descriptor.atIndex(i),
            let key = item.atIndex(1)?.stringValue else { continue }
      let value = item.atIndex(2)?.stringValue ?? ""
      result[key] = value
    }
    return result
  }

  // MARK: - Privacy Helpers

  func getRecordTags(uuid: String) throws -> [String] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      return tags of theRecord
    end tell
    """
    let result = try runAppleScript(script)
    var tags: [String] = []
    let count = result.numberOfItems
    guard count > 0 else { return tags }
    for i in 1...count {
      if let tag = result.atIndex(i)?.stringValue {
        tags.append(tag)
      }
    }
    return tags
  }
}
