//
//  TestHelpers.swift
//  dt-mcp tests
//

import Foundation

/// RAII wrapper for a throwaway config directory. The dir is created on init
/// and removed on deinit — hold `let dir = TempConfigDir()` at test scope and
/// it'll be cleaned up when the test returns (pass or fail).
final class TempConfigDir: @unchecked Sendable {
  let url: URL

  init() {
    url = FileManager.default.temporaryDirectory
      .appendingPathComponent("dt-mcp-test-\(UUID().uuidString)")
    try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
  }

  deinit {
    try? FileManager.default.removeItem(at: url)
  }
}
