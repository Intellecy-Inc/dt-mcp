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

  /// Sci-hub mirror domains to try in order
  private static let scihubMirrors = [
    "sci-hub.se",
    "sci-hub.ru",
    "sci-hub.st",
    "sci-hub.ee",
    "sci-hub.ren"
  ]

  /// Download a PDF from sci-hub using a DOI and import into DEVONthink
  func downloadPDFFromDOI(doi: String, databaseUUID: String, destinationUUID: String?, name: String?) throws -> [String: Any] {
    // Create temp file path
    let tempDir = FileManager.default.temporaryDirectory
    let sanitizedDOI = doi.replacingOccurrences(of: "/", with: "_")
    let tempPath = tempDir.appendingPathComponent("\(sanitizedDOI).pdf")

    let semaphore = DispatchSemaphore(value: 0)
    var html: String?
    var workingMirror: String?
    var lastError: String?

    // Try each mirror until one works
    for mirror in Self.scihubMirrors {
      let scihubURL = "https://\(mirror)/\(doi)"
      guard let pageURL = URL(string: scihubURL) else { continue }

      var pageContent: String?
      var fetchError: Error?

      let pageTask = URLSession.shared.dataTask(with: pageURL) { data, response, error in
        if let error = error {
          fetchError = error
        } else if let data = data {
          pageContent = String(data: data, encoding: .utf8)
        }
        semaphore.signal()
      }
      pageTask.resume()
      _ = semaphore.wait(timeout: .now() + 10)

      if fetchError == nil, let content = pageContent, !content.isEmpty {
        html = content
        workingMirror = mirror
        break
      } else {
        lastError = fetchError?.localizedDescription ?? "No content"
      }
    }

    guard let pageHTML = html, let mirror = workingMirror else {
      throw MCPError.appleScriptError("Failed to reach any sci-hub mirror. Last error: \(lastError ?? "unknown")")
    }

    // Parse HTML to find PDF URL (look for embed or iframe with PDF)
    var pdfURLString: String?

    // Try to find PDF URL in embed tag
    if let range = pageHTML.range(of: #"<embed[^>]+src="([^"]+\.pdf[^"]*)""#, options: .regularExpression) {
      let match = String(pageHTML[range])
      if let srcRange = match.range(of: #"src="([^"]+)""#, options: .regularExpression) {
        var src = String(match[srcRange])
        src = src.replacingOccurrences(of: "src=\"", with: "").replacingOccurrences(of: "\"", with: "")
        pdfURLString = src
      }
    }

    // Try iframe if embed didn't work
    if pdfURLString == nil, let range = pageHTML.range(of: #"<iframe[^>]+src="([^"]+)""#, options: .regularExpression) {
      let match = String(pageHTML[range])
      if let srcRange = match.range(of: #"src="([^"]+)""#, options: .regularExpression) {
        var src = String(match[srcRange])
        src = src.replacingOccurrences(of: "src=\"", with: "").replacingOccurrences(of: "\"", with: "")
        pdfURLString = src
      }
    }

    // Try button onclick pattern
    if pdfURLString == nil, let range = pageHTML.range(of: #"location\.href\s*=\s*'([^']+\.pdf[^']*)'"#, options: .regularExpression) {
      let match = String(pageHTML[range])
      if let urlRange = match.range(of: #"'([^']+)'"#, options: .regularExpression) {
        var url = String(match[urlRange])
        url = url.replacingOccurrences(of: "'", with: "")
        pdfURLString = url
      }
    }

    // Try object tag with data attribute (sci-hub's current format)
    // Matches: <object type = "application/pdf" data = "/path/to/file.pdf#fragment">
    if pdfURLString == nil, let range = pageHTML.range(of: #"<object[^>]+data\s*=\s*"([^"]+)""#, options: .regularExpression) {
      let match = String(pageHTML[range])
      if let dataRange = match.range(of: #"data\s*=\s*"([^"]+)""#, options: .regularExpression) {
        var data = String(match[dataRange])
        // Extract URL from data="..."
        if let quoteStart = data.firstIndex(of: "\"") {
          data = String(data[data.index(after: quoteStart)...])
          if let quoteEnd = data.firstIndex(of: "\"") {
            data = String(data[..<quoteEnd])
          }
        }
        // Remove URL fragment (e.g., #navpanes=0&view=FitH)
        if let fragmentIndex = data.firstIndex(of: "#") {
          data = String(data[..<fragmentIndex])
        }
        pdfURLString = data
      }
    }

    guard var pdfURL = pdfURLString else {
      throw MCPError.appleScriptError("Could not find PDF URL on sci-hub page. The paper may not be available.")
    }

    // Fix relative URLs using the working mirror
    if pdfURL.hasPrefix("//") {
      pdfURL = "https:" + pdfURL
    } else if pdfURL.hasPrefix("/") {
      pdfURL = "https://\(mirror)" + pdfURL
    }

    // Download the PDF
    guard let downloadURL = URL(string: pdfURL) else {
      throw MCPError.appleScriptError("Invalid PDF URL: \(pdfURL)")
    }

    var downloadError: Error?
    var pdfData: Data?

    let downloadTask = URLSession.shared.dataTask(with: downloadURL) { data, response, error in
      if let error = error {
        downloadError = error
      } else {
        pdfData = data
      }
      semaphore.signal()
    }
    downloadTask.resume()
    _ = semaphore.wait(timeout: .now() + 60)

    if let error = downloadError {
      throw MCPError.appleScriptError("Failed to download PDF: \(error.localizedDescription)")
    }

    guard let data = pdfData, data.count > 1000 else {
      throw MCPError.appleScriptError("Downloaded file is too small or empty - PDF may not be available")
    }

    // Verify it's actually a PDF
    let pdfHeader = Data([0x25, 0x50, 0x44, 0x46]) // %PDF
    guard data.prefix(4) == pdfHeader else {
      throw MCPError.appleScriptError("Downloaded file is not a valid PDF")
    }

    // Write to temp file
    try data.write(to: tempPath)

    // Import to DEVONthink
    let record = try importFile(path: tempPath.path, to: databaseUUID, destinationUUID: destinationUUID, name: name)

    // Clean up temp file
    try? FileManager.default.removeItem(at: tempPath)

    return record
  }

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
