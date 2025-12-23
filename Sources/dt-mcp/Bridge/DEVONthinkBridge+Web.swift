//
//  DEVONthinkBridge+Web.swift
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

// MARK: - Web & Link Operations

extension DEVONthinkBridge {

  func createBookmark(url: String, name: String?, databaseUUID: String, destinationUUID: String?) throws -> [String: Any] {
    let nameClause = name != nil ? "name:\"\(escape(name!))\"" : ""
    let destClause: String
    if let destinationUUID = destinationUUID {
      destClause = "set destGroup to get record with uuid \"\(escape(destinationUUID))\""
    }
    else {
      destClause = "set destGroup to incoming group of theDB"
    }

    let props = nameClause.isEmpty ? "URL:\"\(escape(url))\"" : "\(nameClause), URL:\"\(escape(url))\""

    let script = """
    tell application id "DNtp"
      set theDB to get database with uuid "\(escape(databaseUUID))"
      if theDB is missing value then error "Database not found"
      \(destClause)
      set theRecord to create record with {type:bookmark, \(props)} in destGroup
      return {uuid of theRecord, name of theRecord, path of theRecord}
    end tell
    """
    let result = try runAppleScript(script)
    return parseSimpleRecord(result)
  }

  func downloadURL(url: String, databaseUUID: String, destinationUUID: String?) throws -> [String: Any] {
    let destClause: String
    if let destinationUUID = destinationUUID {
      destClause = "set destGroup to get record with uuid \"\(escape(destinationUUID))\""
    }
    else {
      destClause = "set destGroup to incoming group of theDB"
    }

    let script = """
    tell application id "DNtp"
      set theDB to get database with uuid "\(escape(databaseUUID))"
      if theDB is missing value then error "Database not found"
      \(destClause)
      set theRecord to create web document from "\(escape(url))" in destGroup
      return {uuid of theRecord, name of theRecord, path of theRecord}
    end tell
    """
    let result = try runAppleScript(script)
    return parseSimpleRecord(result)
  }

  func downloadMarkdown(url: String, databaseUUID: String, destinationUUID: String?) throws -> [String: Any] {
    let destClause: String
    if let destinationUUID = destinationUUID {
      destClause = "set destGroup to get record with uuid \"\(escape(destinationUUID))\""
    }
    else {
      destClause = "set destGroup to incoming group of theDB"
    }

    let script = """
    tell application id "DNtp"
      set theDB to get database with uuid "\(escape(databaseUUID))"
      if theDB is missing value then error "Database not found"
      \(destClause)
      set theRecord to create Markdown from "\(escape(url))" in destGroup
      return {uuid of theRecord, name of theRecord, path of theRecord}
    end tell
    """
    let result = try runAppleScript(script)
    return parseSimpleRecord(result)
  }

  // MARK: - Link Operations

  func getItemLinks(uuid: String) throws -> [[String: Any]] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set linkList to incoming references of theRecord
      set resultList to {}
      repeat with l in linkList
        set end of resultList to {uuid of l, name of l, path of l}
      end repeat
      return resultList
    end tell
    """
    let result = try runAppleScript(script)
    return parseRecordList(result, keys: ["uuid", "name", "path"])
  }

  func getOutgoingLinks(uuid: String) throws -> [[String: Any]] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set linkList to outgoing references of theRecord
      set resultList to {}
      repeat with l in linkList
        set end of resultList to {uuid of l, name of l, path of l}
      end repeat
      return resultList
    end tell
    """
    let result = try runAppleScript(script)
    return parseRecordList(result, keys: ["uuid", "name", "path"])
  }

  func getItemURL(uuid: String) throws -> String {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      return reference URL of theRecord
    end tell
    """
    let result = try runAppleScript(script)
    return result.stringValue ?? ""
  }
}
