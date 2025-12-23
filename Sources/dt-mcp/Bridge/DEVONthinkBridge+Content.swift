//
//  DEVONthinkBridge+Content.swift
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

// MARK: - Tags, Metadata, Reminders, Annotations

extension DEVONthinkBridge {

  // MARK: - Tag Operations

  func getTags(databaseUUID: String) throws -> [[String: Any]] {
    let script = """
    tell application id "DNtp"
      set theDB to get database with uuid "\(escape(databaseUUID))"
      if theDB is missing value then error "Database not found"
      set tagGroup to tags group of theDB
      set resultList to {}
      repeat with tag in children of tagGroup
        set end of resultList to {name of tag, uuid of tag}
      end repeat
      return resultList
    end tell
    """
    let result = try runAppleScript(script)
    return parseRecordList(result, keys: ["name", "uuid"])
  }

  func setRecordTags(uuid: String, tags: [String]) throws -> Bool {
    let tagList = tags.map { "\"\(escape($0))\"" }.joined(separator: ", ")
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set tags of theRecord to {\(tagList)}
      return true
    end tell
    """
    let result = try runAppleScript(script)
    return result.booleanValue
  }

  func addRecordTags(uuid: String, tags: [String]) throws -> Bool {
    let tagList = tags.map { "\"\(escape($0))\"" }.joined(separator: ", ")
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set currentTags to tags of theRecord
      set tags of theRecord to currentTags & {\(tagList)}
      return true
    end tell
    """
    let result = try runAppleScript(script)
    return result.booleanValue
  }

  func removeRecordTags(uuid: String, tags: [String]) throws -> Bool {
    let tagSet = Set(tags)
    let tagList = tagSet.map { "\"\(escape($0))\"" }.joined(separator: ", ")
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set tagsToRemove to {\(tagList)}
      set currentTags to tags of theRecord
      set newTags to {}
      repeat with t in currentTags
        if t is not in tagsToRemove then set end of newTags to (t as string)
      end repeat
      set tags of theRecord to newTags
      return true
    end tell
    """
    let result = try runAppleScript(script)
    return result.booleanValue
  }

  // MARK: - Custom Metadata

  func getCustomMetadata(uuid: String) throws -> [String: Any] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      return custom meta data of theRecord
    end tell
    """
    let result = try runAppleScript(script)
    return parseCustomMetadata(result)
  }

  func setCustomMetadata(uuid: String, key: String, value: String) throws -> Bool {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      add custom meta data "\(escape(value))" for "\(escape(key))" to theRecord
      return true
    end tell
    """
    let result = try runAppleScript(script)
    return result.booleanValue
  }

  // MARK: - Reminder Operations

  func getReminders(uuid: String?) throws -> [[String: Any]] {
    if let uuid = uuid {
      let script = """
      tell application id "DNtp"
        set theRecord to get record with uuid "\(escape(uuid))"
        if theRecord is missing value then error "Record not found"
        set reminderInfo to reminder of theRecord
        if reminderInfo is missing value then return {}
        return {{uuid of theRecord, name of theRecord, due date of reminderInfo as string, alarm of reminderInfo as string}}
      end tell
      """
      let result = try runAppleScript(script)
      return parseRecordList(result, keys: ["uuid", "name", "reminderDate", "alarm"])
    }
    else {
      var allReminders: [[String: Any]] = []
      let dbScript = """
      tell application id "DNtp"
        set dbList to {}
        repeat with db in databases
          set end of dbList to uuid of db
        end repeat
        return dbList
      end tell
      """
      let dbResult = try runAppleScript(dbScript)
      let count = dbResult.numberOfItems
      guard count > 0 else { return allReminders }

      for i in 1...count {
        guard let dbUUID = dbResult.atIndex(i)?.stringValue else { continue }
        let script = """
        tell application id "DNtp"
          set theDB to get database with uuid "\(escape(dbUUID))"
          set resultList to {}
          set counter to 0
          repeat with r in every record of theDB
            if counter >= 20 then exit repeat
            set reminderInfo to reminder of r
            if reminderInfo is not missing value then
              set end of resultList to {uuid of r, name of r, due date of reminderInfo as string, alarm of reminderInfo as string}
              set counter to counter + 1
            end if
          end repeat
          return resultList
        end tell
        """
        if let result = try? runAppleScript(script) {
          let reminders = parseRecordList(result, keys: ["uuid", "name", "reminderDate", "alarm"])
          allReminders.append(contentsOf: reminders)
        }
        if allReminders.count >= 50 { break }
      }
      return allReminders
    }
  }

  func setReminder(uuid: String, date: String, alarm: Bool) throws -> Bool {
    let alarmType = alarm ? "notification" : "no alarm"
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      add reminder {schedule:once, due date:date "\(escape(date))", alarm:\(alarmType)} to theRecord
      return true
    end tell
    """
    let result = try runAppleScript(script)
    return result.booleanValue
  }

  func clearReminder(uuid: String) throws -> Bool {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set reminder of theRecord to missing value
      return true
    end tell
    """
    let result = try runAppleScript(script)
    return result.booleanValue
  }

  // MARK: - Annotations

  func getAnnotations(uuid: String) throws -> [[String: Any]] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set a to annotation of theRecord
      if a is missing value then return {}
      return {{uuid of a, name of a, path of a}}
    end tell
    """
    let result = try runAppleScript(script)
    return parseRecordList(result, keys: ["uuid", "name", "path"])
  }

  // MARK: - Replicants & Duplicates

  func getReplicants(uuid: String) throws -> [[String: Any]] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set parentList to parents of theRecord
      set resultList to {}
      repeat with p in parentList
        set end of resultList to {uuid of p, name of p, path of p, location of p}
      end repeat
      return resultList
    end tell
    """
    let result = try runAppleScript(script)
    return parseRecordList(result, keys: ["uuid", "name", "path", "location"])
  }

  func getDuplicates(uuid: String) throws -> [[String: Any]] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set dupList to duplicates of theRecord
      set resultList to {}
      repeat with d in dupList
        set end of resultList to {uuid of d, name of d, path of d, location of d}
      end repeat
      return resultList
    end tell
    """
    let result = try runAppleScript(script)
    return parseRecordList(result, keys: ["uuid", "name", "path", "location"])
  }

  // MARK: - Import/Export

  func importFile(path: String, to databaseUUID: String, destinationUUID: String?, name: String?) throws -> [String: Any] {
    let nameClause = name != nil ? "name \"\(escape(name!))\"" : ""
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
      set importedRecord to import "\(escape(path))" \(nameClause) to destGroup
      return {uuid of importedRecord, name of importedRecord, path of importedRecord}
    end tell
    """
    let result = try runAppleScript(script)
    return parseSimpleRecord(result)
  }

  func exportRecord(uuid: String, to path: String) throws -> Bool {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      export record theRecord to "\(escape(path))"
      return true
    end tell
    """
    let result = try runAppleScript(script)
    return result.booleanValue
  }
}
