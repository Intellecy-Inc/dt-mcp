//
//  ImageProcessorTests.swift
//  dt-mcp tests
//

import Testing
import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers
@testable import dt_mcp

@Suite("ImageProcessor — scaling, EXIF stripping, adaptive compression")
struct ImageProcessorTests {

  /// Generate a valid PNG of the requested dimensions entirely in memory.
  /// Using ImageIO rather than a fixture keeps the tests hermetic.
  func makePNG(width: Int, height: Int) -> Data {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(
      data: nil,
      width: width,
      height: height,
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: colorSpace,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!
    context.setFillColor(CGColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0))
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    let cgImage = context.makeImage()!

    let data = NSMutableData()
    let dest = CGImageDestinationCreateWithData(
      data as CFMutableData,
      UTType.png.identifier as CFString,
      1,
      nil
    )!
    CGImageDestinationAddImage(dest, cgImage, nil)
    CGImageDestinationFinalize(dest)
    return data as Data
  }

  // MARK: - Happy paths: aspect-ratio-preserving scaling

  @Test("small image below maxDimension is not upscaled")
  func smallImageNotUpscaled() throws {
    let png = makePNG(width: 100, height: 80)
    let (b64, w, h) = try ImageProcessor.processImage(data: png, maxDimension: 512)
    #expect(w == 100)
    #expect(h == 80)
    #expect(!b64.isEmpty)
  }

  @Test("landscape image larger than maxDimension is scaled by width")
  func landscapeScaled() throws {
    // 2:1 aspect. Expect w=512, h=256.
    let png = makePNG(width: 2000, height: 1000)
    let (_, w, h) = try ImageProcessor.processImage(data: png, maxDimension: 512)
    #expect(w == 512)
    #expect(h == 256)
  }

  @Test("portrait image larger than maxDimension is scaled by height")
  func portraitScaled() throws {
    // 1:2 aspect. Expect h=512, w=256.
    let png = makePNG(width: 1000, height: 2000)
    let (_, w, h) = try ImageProcessor.processImage(data: png, maxDimension: 512)
    #expect(w == 256)
    #expect(h == 512)
  }

  @Test("square image scales to maxDimension in both axes")
  func squareScaled() throws {
    let png = makePNG(width: 1024, height: 1024)
    let (_, w, h) = try ImageProcessor.processImage(data: png, maxDimension: 512)
    #expect(w == 512)
    #expect(h == 512)
  }

  @Test("arbitrary non-round aspect ratio is preserved within 1px", arguments: [
    (1600, 900, 512, 512, 288),   // 16:9
    (900, 1600, 512, 288, 512),   // 9:16
    (1000, 750, 512, 512, 384),   // 4:3
    (750, 1000, 512, 384, 512)    // 3:4
  ])
  func arbitraryAspectPreserved(w0: Int, h0: Int, maxDim: Int, expectedW: Int, expectedH: Int) throws {
    let png = makePNG(width: w0, height: h0)
    let (_, w, h) = try ImageProcessor.processImage(data: png, maxDimension: maxDim)
    #expect(abs(w - expectedW) <= 1, "got \(w), expected ~\(expectedW)")
    #expect(abs(h - expectedH) <= 1, "got \(h), expected ~\(expectedH)")
  }

  // MARK: - Happy paths: output format and size budget

  @Test("output is JPEG (starts with FF D8 FF)")
  func outputIsJPEG() throws {
    let png = makePNG(width: 200, height: 200)
    let (b64, _, _) = try ImageProcessor.processImage(data: png, maxDimension: 512)
    let bytes = try #require(Data(base64Encoded: b64))
    #expect(bytes.count >= 3)
    #expect(bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF)
  }

  @Test("output base64 stays under the 50 KB Claude Code budget")
  func outputBelowSizeLimit() throws {
    // Reasonably large input; adaptive compression should get us under 50KB.
    let png = makePNG(width: 1024, height: 1024)
    let (b64, _, _) = try ImageProcessor.processImage(data: png, maxDimension: 512)
    #expect(b64.count <= 50_000, "base64 length was \(b64.count)")
  }

  // MARK: - Happy paths: EXIF stripping
  //
  // Note: CGImageDestination always writes a minimal EXIF IFD (ColorSpace,
  // PixelXDimension, PixelYDimension) regardless of options, so we can't
  // assert the dict is absent — that's incidental, not a privacy leak. The
  // privacy claim in docs/privacy.md is about GPS, camera identity, author,
  // and date-taken. We test that those are gone from real input that had
  // them, not that the entire IFD is empty.

  /// Generate an in-memory JPEG with GPS + camera + author metadata injected,
  /// so we can assert that running it through ImageProcessor strips them.
  func makeJPEGWithSensitiveMetadata(width: Int, height: Int) -> Data {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let ctx = CGContext(
      data: nil, width: width, height: height,
      bitsPerComponent: 8, bytesPerRow: 0,
      space: colorSpace,
      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!
    ctx.setFillColor(CGColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0))
    ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))
    let cgImage = ctx.makeImage()!

    let gps: [String: Any] = [
      kCGImagePropertyGPSLatitude as String: 37.7749,
      kCGImagePropertyGPSLatitudeRef as String: "N",
      kCGImagePropertyGPSLongitude as String: 122.4194,
      kCGImagePropertyGPSLongitudeRef as String: "W"
    ]
    let tiff: [String: Any] = [
      kCGImagePropertyTIFFMake as String: "Canon",
      kCGImagePropertyTIFFModel as String: "EOS R5",
      kCGImagePropertyTIFFArtist as String: "Jane Doe"
    ]
    let exif: [String: Any] = [
      kCGImagePropertyExifDateTimeOriginal as String: "2024:06:15 13:45:20",
      kCGImagePropertyExifUserComment as String: "sensitive note"
    ]
    let metadata: [String: Any] = [
      kCGImagePropertyGPSDictionary as String: gps,
      kCGImagePropertyTIFFDictionary as String: tiff,
      kCGImagePropertyExifDictionary as String: exif
    ]

    let data = NSMutableData()
    let dest = CGImageDestinationCreateWithData(
      data as CFMutableData,
      UTType.jpeg.identifier as CFString,
      1,
      nil
    )!
    CGImageDestinationAddImage(dest, cgImage, metadata as CFDictionary)
    CGImageDestinationFinalize(dest)
    return data as Data
  }

  @Test("sanity: the fixture actually embeds sensitive metadata")
  func fixtureHasSensitiveMetadata() throws {
    // If the fixture helper regresses and doesn't inject the metadata, the
    // stripping test would vacuously pass. Assert the input side first.
    let jpeg = makeJPEGWithSensitiveMetadata(width: 400, height: 400)
    let source = try #require(CGImageSourceCreateWithData(jpeg as CFData, nil))
    let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any]
    #expect(props?[kCGImagePropertyGPSDictionary as String] != nil)
    let tiff = props?[kCGImagePropertyTIFFDictionary as String] as? [String: Any]
    #expect(tiff?[kCGImagePropertyTIFFMake as String] as? String == "Canon")
    #expect(tiff?[kCGImagePropertyTIFFArtist as String] as? String == "Jane Doe")
  }

  @Test("GPS coordinates are stripped from the output")
  func gpsStripped() throws {
    let input = makeJPEGWithSensitiveMetadata(width: 400, height: 400)
    let (b64, _, _) = try ImageProcessor.processImage(data: input, maxDimension: 512)
    let bytes = try #require(Data(base64Encoded: b64))
    let source = try #require(CGImageSourceCreateWithData(bytes as CFData, nil))
    let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any]
    #expect(props?[kCGImagePropertyGPSDictionary as String] == nil,
            "GPS dictionary must be absent from output")
  }

  @Test("camera make/model and artist are stripped from the output")
  func cameraIdentityStripped() throws {
    let input = makeJPEGWithSensitiveMetadata(width: 400, height: 400)
    let (b64, _, _) = try ImageProcessor.processImage(data: input, maxDimension: 512)
    let bytes = try #require(Data(base64Encoded: b64))
    let source = try #require(CGImageSourceCreateWithData(bytes as CFData, nil))
    let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any]
    // TIFF dict itself may or may not exist (CG sometimes writes minimal TIFF);
    // what matters is that the identifying fields are absent.
    let tiff = props?[kCGImagePropertyTIFFDictionary as String] as? [String: Any]
    #expect(tiff?[kCGImagePropertyTIFFMake as String] == nil)
    #expect(tiff?[kCGImagePropertyTIFFModel as String] == nil)
    #expect(tiff?[kCGImagePropertyTIFFArtist as String] == nil)
  }

  @Test("date-taken and user-comment EXIF fields are stripped from the output")
  func datesAndCommentsStripped() throws {
    let input = makeJPEGWithSensitiveMetadata(width: 400, height: 400)
    let (b64, _, _) = try ImageProcessor.processImage(data: input, maxDimension: 512)
    let bytes = try #require(Data(base64Encoded: b64))
    let source = try #require(CGImageSourceCreateWithData(bytes as CFData, nil))
    let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any]
    let exif = props?[kCGImagePropertyExifDictionary as String] as? [String: Any]
    #expect(exif?[kCGImagePropertyExifDateTimeOriginal as String] == nil)
    #expect(exif?[kCGImagePropertyExifUserComment as String] == nil)
  }

  // MARK: - Bad paths

  @Test("empty data throws imageProcessingFailed")
  func emptyThrows() {
    #expect(throws: MCPError.self) {
      _ = try ImageProcessor.processImage(data: Data(), maxDimension: 512)
    }
  }

  @Test("non-image bytes throw imageProcessingFailed")
  func garbageThrows() {
    let junk = Data("this is definitely not an image".utf8)
    #expect(throws: MCPError.self) {
      _ = try ImageProcessor.processImage(data: junk, maxDimension: 512)
    }
  }

  @Test("truncated image header throws imageProcessingFailed")
  func truncatedThrows() {
    // PNG magic bytes only; no actual image chunks after.
    let truncated = Data([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
    #expect(throws: MCPError.self) {
      _ = try ImageProcessor.processImage(data: truncated, maxDimension: 512)
    }
  }
}
