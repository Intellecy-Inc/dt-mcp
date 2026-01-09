//
//  ImageProcessor.swift
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
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

// MARK: - Image Processor

/// Processes images for privacy: strips EXIF metadata and scales to max dimension
struct ImageProcessor {

  /// Target max base64 size in characters (~50KB fits in Claude Code's token limit)
  private static let maxBase64Size = 50_000

  /// Quality levels to try (high to low)
  private static let qualityLevels: [Double] = [0.8, 0.6, 0.4, 0.25]

  /// Process an image: strip EXIF, scale, and adaptively compress to fit size limit
  /// - Parameters:
  ///   - data: Original image data
  ///   - maxDimension: Maximum width or height in pixels
  /// - Returns: Processed image as base64-encoded JPEG, and final dimensions
  static func processImage(data: Data, maxDimension: Int) throws -> (base64: String, width: Int, height: Int) {
    guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
      throw MCPError.imageProcessingFailed("Could not create image source")
    }

    guard let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
      throw MCPError.imageProcessingFailed("Could not create CGImage")
    }

    // Calculate new dimensions maintaining aspect ratio
    let originalWidth = cgImage.width
    let originalHeight = cgImage.height
    let (newWidth, newHeight) = calculateScaledDimensions(
      width: originalWidth,
      height: originalHeight,
      maxDimension: maxDimension
    )

    // Scale the image
    let scaledImage = try scaleImage(cgImage, to: CGSize(width: newWidth, height: newHeight))

    // Try progressively lower quality until under size limit
    for quality in qualityLevels {
      let jpegData = try createJPEGWithoutEXIF(from: scaledImage, quality: quality)
      let base64 = jpegData.base64EncodedString()

      if base64.count <= maxBase64Size {
        return (base64, newWidth, newHeight)
      }
    }

    // If still too large at lowest quality, use the lowest quality result anyway
    let jpegData = try createJPEGWithoutEXIF(from: scaledImage, quality: qualityLevels.last!)
    let base64 = jpegData.base64EncodedString()

    return (base64, newWidth, newHeight)
  }

  /// Calculate scaled dimensions maintaining aspect ratio
  private static func calculateScaledDimensions(width: Int, height: Int, maxDimension: Int) -> (Int, Int) {
    if width <= maxDimension && height <= maxDimension {
      return (width, height)
    }

    let aspectRatio = Double(width) / Double(height)

    if width > height {
      let newWidth = min(width, maxDimension)
      let newHeight = Int(Double(newWidth) / aspectRatio)
      return (newWidth, newHeight)
    }
    else {
      let newHeight = min(height, maxDimension)
      let newWidth = Int(Double(newHeight) * aspectRatio)
      return (newWidth, newHeight)
    }
  }

  /// Scale a CGImage to the specified size
  private static func scaleImage(_ image: CGImage, to size: CGSize) throws -> CGImage {
    let width = Int(size.width)
    let height = Int(size.height)

    guard let colorSpace = image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB) else {
      throw MCPError.imageProcessingFailed("Could not determine color space")
    }

    guard let context = CGContext(
      data: nil,
      width: width,
      height: height,
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: colorSpace,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    ) else {
      throw MCPError.imageProcessingFailed("Could not create graphics context")
    }

    context.interpolationQuality = .high
    context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))

    guard let scaledImage = context.makeImage() else {
      throw MCPError.imageProcessingFailed("Could not create scaled image")
    }

    return scaledImage
  }

  /// Create JPEG data from CGImage without any EXIF metadata
  private static func createJPEGWithoutEXIF(from image: CGImage, quality: Double) throws -> Data {
    let data = NSMutableData()

    guard let destination = CGImageDestinationCreateWithData(
      data as CFMutableData,
      UTType.jpeg.identifier as CFString,
      1,
      nil
    ) else {
      throw MCPError.imageProcessingFailed("Could not create image destination")
    }

    // Set compression quality, explicitly exclude all metadata
    let options: [CFString: Any] = [
      kCGImageDestinationLossyCompressionQuality: quality
    ]

    CGImageDestinationAddImage(destination, image, options as CFDictionary)

    guard CGImageDestinationFinalize(destination) else {
      throw MCPError.imageProcessingFailed("Could not finalize image")
    }

    return data as Data
  }
}
