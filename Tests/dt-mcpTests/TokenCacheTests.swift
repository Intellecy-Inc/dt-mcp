//
//  TokenCacheTests.swift
//  dt-mcp tests
//

import Testing
import Foundation
@testable import dt_mcp

@MainActor
@Suite("TokenCache — token/original round-trip & persistence")
struct TokenCacheTests {

  // MARK: - Happy paths

  @Test("store then decode returns the original value")
  func storeAndDecode() {
    let tmp = TempConfigDir()
    let cache = TokenCache(configDir: tmp.url)
    cache.store("[EM:deadbeef]", original: "alice@example.com")
    #expect(cache.decode("[EM:deadbeef]") == "alice@example.com")
  }

  @Test("decodeAll returns a map for known tokens and omits unknown ones")
  func decodeAllMixed() {
    let tmp = TempConfigDir()
    let cache = TokenCache(configDir: tmp.url)
    cache.store("[EM:aaaa]", original: "a@x")
    cache.store("[EM:bbbb]", original: "b@x")
    let out = cache.decodeAll(["[EM:aaaa]", "[EM:bbbb]", "[EM:ffff]"])
    #expect(out["[EM:aaaa]"] == "a@x")
    #expect(out["[EM:bbbb]"] == "b@x")
    #expect(out["[EM:ffff]"] == nil)
  }

  @Test("persistence: a new instance pointed at the same dir reads prior state")
  func persistence() {
    let tmp = TempConfigDir()
    let first = TokenCache(configDir: tmp.url)
    first.store("[PH:1234]", original: "+15551234567")
    // Simulate process restart by creating a second instance on the same dir.
    let second = TokenCache(configDir: tmp.url)
    #expect(second.decode("[PH:1234]") == "+15551234567")
  }

  // MARK: - Bad paths

  @Test("decoding an unknown token returns nil")
  func decodeUnknown() {
    let tmp = TempConfigDir()
    let cache = TokenCache(configDir: tmp.url)
    #expect(cache.decode("[EM:nonexistent]") == nil)
  }

  @Test("clear() empties the cache and returns the previous size")
  func clear() {
    let tmp = TempConfigDir()
    let cache = TokenCache(configDir: tmp.url)
    cache.store("[EM:1]", original: "x")
    cache.store("[EM:2]", original: "y")
    let cleared = cache.clear()
    #expect(cleared == 2)
    #expect(cache.decode("[EM:1]") == nil)
    #expect(cache.decode("[EM:2]") == nil)
  }

  @Test("clear() on an empty cache returns 0")
  func clearEmpty() {
    let tmp = TempConfigDir()
    let cache = TokenCache(configDir: tmp.url)
    #expect(cache.clear() == 0)
  }

  @Test("fresh cache in a new dir has no data (no leakage across instances)")
  func isolationAcrossDirs() {
    let tmpA = TempConfigDir()
    let a = TokenCache(configDir: tmpA.url)
    a.store("[EM:secret]", original: "leak@x")
    let tmpB = TempConfigDir()
    let b = TokenCache(configDir: tmpB.url)
    #expect(b.decode("[EM:secret]") == nil)
  }
}
