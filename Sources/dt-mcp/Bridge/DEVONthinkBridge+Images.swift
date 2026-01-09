//
//  DEVONthinkBridge+Images.swift
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
import ImageIO

// MARK: - Image Operations

extension DEVONthinkBridge {

  /// Image types recognized by DEVONthink
  static let imageTypes = ["picture"]

  /// Check if a record is an image type
  func isImageRecord(uuid: String) throws -> Bool {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      return type of theRecord as string
    end tell
    """

    let result = try runAppleScript(script)
    let recordType = result.stringValue ?? ""
    return Self.imageTypes.contains(recordType)
  }

  /// Get image metadata without fetching the actual image data
  func getImageMetadata(uuid: String) throws -> [String: Any] {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      set recType to type of theRecord as string
      set recName to name of theRecord
      set recSize to size of theRecord
      set dims to dimensions of theRecord
      set recPath to path of theRecord
      return {recType, recName, recSize, item 1 of dims, item 2 of dims, recPath}
    end tell
    """

    let result = try runAppleScript(script)

    return [
      "type": result.atIndex(1)?.stringValue ?? "",
      "name": result.atIndex(2)?.stringValue ?? "",
      "size": result.atIndex(3)?.int32Value ?? 0,
      "width": result.atIndex(4)?.int32Value ?? 0,
      "height": result.atIndex(5)?.int32Value ?? 0,
      "path": result.atIndex(6)?.stringValue ?? ""
    ]
  }

  /// Get the file path for an image record to read its data
  func getImagePath(uuid: String) throws -> String {
    let script = """
    tell application id "DNtp"
      set theRecord to get record with uuid "\(escape(uuid))"
      if theRecord is missing value then error "Record not found"
      return path of theRecord
    end tell
    """

    let result = try runAppleScript(script)
    return result.stringValue ?? ""
  }

  /// Get image data as Data object by reading from the file path
  func getImageData(uuid: String) throws -> Data {
    let path = try getImagePath(uuid: uuid)

    guard !path.isEmpty else {
      throw MCPError.imageProcessingFailed("Could not get image path")
    }

    let url = URL(fileURLWithPath: path)
    do {
      return try Data(contentsOf: url)
    }
    catch {
      throw MCPError.imageProcessingFailed("Could not read image file: \(error.localizedDescription)")
    }
  }

  /// Extract EXIF metadata from image file - shows what private data exists
  func getImageEXIF(path: String) -> [String: String] {
    var exif: [String: String] = [:]

    let url = URL(fileURLWithPath: path)
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
          let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any] else {
      return exif
    }

    // EXIF data
    if let exifDict = properties["{Exif}"] as? [String: Any] {
      if let software = exifDict["Software"] as? String {
        exif["software"] = software
      }
      if let dateOriginal = exifDict["DateTimeOriginal"] as? String {
        exif["dateTaken"] = dateOriginal
      }
      if let userComment = exifDict["UserComment"] as? String {
        exif["comment"] = userComment
      }
    }

    // TIFF data (camera, author)
    if let tiffDict = properties["{TIFF}"] as? [String: Any] {
      if let make = tiffDict["Make"] as? String {
        exif["cameraMake"] = make
      }
      if let model = tiffDict["Model"] as? String {
        exif["cameraModel"] = model
      }
      if let artist = tiffDict["Artist"] as? String {
        exif["author"] = artist
      }
      if let software = tiffDict["Software"] as? String, exif["software"] == nil {
        exif["software"] = software
      }
    }

    // GPS data
    if let gpsDict = properties["{GPS}"] as? [String: Any] {
      if let lat = gpsDict["Latitude"] as? Double,
         let latRef = gpsDict["LatitudeRef"] as? String,
         let lon = gpsDict["Longitude"] as? Double,
         let lonRef = gpsDict["LongitudeRef"] as? String {
        let latSign = latRef == "S" ? "-" : ""
        let lonSign = lonRef == "W" ? "-" : ""
        exif["gpsLocation"] = "\(latSign)\(lat), \(lonSign)\(lon)"
      }
      else if !gpsDict.isEmpty {
        exif["gpsLocation"] = "GPS data present"
      }
    }

    // IPTC data (copyright, caption)
    if let iptcDict = properties["{IPTC}"] as? [String: Any] {
      if let copyright = iptcDict["CopyrightNotice"] as? String {
        exif["copyright"] = copyright
      }
      if let byline = iptcDict["Byline"] as? [String] {
        exif["author"] = byline.joined(separator: ", ")
      }
    }

    return exif
  }
}
