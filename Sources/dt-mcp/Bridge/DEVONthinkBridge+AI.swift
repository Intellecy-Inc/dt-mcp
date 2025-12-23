//
//  DEVONthinkBridge+AI.swift
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

// MARK: - AI/Classification & OCR Operations

extension DEVONthinkBridge {

  func classify(uuid: String) throws -> [[String: Any]] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set classifyResults to classify record theRecord
      set resultList to {}
      repeat with r in classifyResults
        set end of resultList to {uuid of r, name of r, path of r}
      end repeat
      return resultList
    end tell
    """
    let result = try runAppleScript(script)
    return parseRecordList(result, keys: ["uuid", "name", "path"])
  }

  func seeAlso(uuid: String, count: Int?) throws -> [[String: Any]] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set seeAlsoResults to compare record theRecord
      set resultList to {}
      repeat with r in seeAlsoResults
        set end of resultList to {uuid of r, name of r, path of r}
      end repeat
      return resultList
    end tell
    """
    let result = try runAppleScript(script)
    return parseRecordList(result, keys: ["uuid", "name", "path"])
  }

  func summarize(uuid: String) throws -> String {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      return plain text of theRecord
    end tell
    """
    let result = try runAppleScript(script)
    return result.stringValue ?? ""
  }

  func getConcordance(uuid: String) throws -> [String] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set wordList to get concordance of record theRecord
      return wordList
    end tell
    """
    let result = try runAppleScript(script)
    var words: [String] = []
    let count = result.numberOfItems
    guard count > 0 else { return words }
    for i in 1...count {
      if let word = result.atIndex(i)?.stringValue {
        words.append(word)
      }
    }
    return words
  }

  // MARK: - OCR Operations

  func ocrFile(path: String, databaseUUID: String, destinationUUID: String?) throws -> [String: Any] {
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
      set theRecord to ocr file "\(escape(path))" to destGroup
      return {uuid of theRecord, name of theRecord, path of theRecord}
    end tell
    """
    let result = try runAppleScript(script)
    return parseSimpleRecord(result)
  }

  func convertToSearchablePDF(uuid: String) throws -> Bool {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      return convert record theRecord
    end tell
    """
    let result = try runAppleScript(script)
    return result.booleanValue
  }
}
