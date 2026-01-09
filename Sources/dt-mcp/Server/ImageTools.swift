//
//  ImageTools.swift
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

// MARK: - Image Tool Handlers

extension MCPServer {

  static let imageTools = ["preview_images"]

  func handleImageTool(name: String, arguments: [String: Any]) throws -> [String: Any]? {
    switch name {
    case "preview_images":
      guard let uuid = arguments["uuid"] as? String else {
        throw MCPError.missingArgument("uuid")
      }

      // Check database exclusion
      let dbUUID = try devonthink.getRecordDatabaseUUID(uuid: uuid)
      if ConfigManager.shared.isExcluded(dbUUID) {
        throw MCPError.databaseExcluded(dbUUID)
      }

      // Check if this is an image record
      let isImage = try devonthink.isImageRecord(uuid: uuid)
      if !isImage {
        throw MCPError.notAnImage(uuid)
      }

      // Get metadata first
      let metadata = try devonthink.getImageMetadata(uuid: uuid)
      let confirmed = arguments["confirmed"] as? Bool ?? false

      // If not confirmed, return metadata + EXIF with confirmation request
      if !confirmed {
        let path = metadata["path"] as? String ?? ""
        let exif = devonthink.getImageEXIF(path: path)

        var result: [String: Any] = [
          "uuid": uuid,
          "name": metadata["name"] ?? "",
          "width": metadata["width"] ?? 0,
          "height": metadata["height"] ?? 0,
          "size": metadata["size"] ?? 0,
          "requires_confirmation": true
        ]

        // Add EXIF data that exists (privacy-relevant info)
        if !exif.isEmpty {
          result["exif_found"] = exif
          result["exif_warning"] = "This metadata will be STRIPPED before sending"
        }

        // Clear message about what happens
        let maxDim = ConfigManager.shared.imageHandling.maxDimension
        result["confirmation_warning"] = "If you confirm, a scaled JPEG (max \(maxDim)px) will be sent to Anthropic's servers. EXIF/GPS data is stripped before sending."

        return formatToolResult(result)
      }

      // Confirmed - check privacy settings for private images
      let tags = try devonthink.getRecordTags(uuid: uuid)
      let isPrivate = Privatizer.shared.isPrivate(tags)

      if isPrivate {
        let imageConfig = ConfigManager.shared.imageHandling
        switch imageConfig.privateImages {
        case "blocked":
          throw MCPError.imageBlocked(uuid)
        case "text_only":
          // Return metadata only even when confirmed
          return formatToolResult([
            "uuid": uuid,
            "name": metadata["name"] ?? "",
            "type": metadata["type"] ?? "",
            "width": metadata["width"] ?? 0,
            "height": metadata["height"] ?? 0,
            "size": metadata["size"] ?? 0,
            "private": true,
            "message": "Image is private. Only metadata is available (text_only mode)."
          ])
        default:
          // "thumbnail" mode - continue to process
          break
        }
      }

      // Get and process the image
      let imageData = try devonthink.getImageData(uuid: uuid)
      let maxDimension = ConfigManager.shared.imageHandling.maxDimension
      let (base64, width, height) = try ImageProcessor.processImage(data: imageData, maxDimension: maxDimension)

      return formatToolResult([
        "uuid": uuid,
        "name": metadata["name"] ?? "",
        "width": width,
        "height": height,
        "format": "jpeg",
        "data": base64
      ])

    default:
      return nil
    }
  }
}
