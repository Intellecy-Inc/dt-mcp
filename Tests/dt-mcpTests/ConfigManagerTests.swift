//
//  ConfigManagerTests.swift
//  dt-mcp tests
//

import Testing
import Foundation
@testable import dt_mcp

@MainActor
@Suite("ConfigManager — defaults, persistence, database exclusion")
struct ConfigManagerTests {

  // MARK: - Happy paths

  @Test("fresh config has privacy mode off and an auto-generated key")
  func defaultsOnFreshInstall() {
    let tmp = TempConfigDir()
    let cfg = ConfigManager(configDir: tmp.url)
    #expect(cfg.privacyMode == false)
    #expect(!cfg.encryptionKey.isEmpty, "encryption key should be auto-generated on first run")
    #expect(cfg.excludedDatabases.isEmpty)
  }

  @Test("encryption key persists across reloads in the same dir")
  func encryptionKeyStable() {
    let tmp = TempConfigDir()
    let first = ConfigManager(configDir: tmp.url)
    let keyA = first.encryptionKey
    let second = ConfigManager(configDir: tmp.url)
    #expect(second.encryptionKey == keyA)
  }

  @Test("exclude then isExcluded = true")
  func excludeHappy() {
    let tmp = TempConfigDir()
    let cfg = ConfigManager(configDir: tmp.url)
    let uuid = "DB-ABC-123"
    #expect(cfg.isExcluded(uuid) == false)
    cfg.excludeDatabase(uuid)
    #expect(cfg.isExcluded(uuid) == true)
    #expect(cfg.excludedDatabases.contains(uuid))
  }

  @Test("excluded databases persist across instances")
  func exclusionPersists() {
    let tmp = TempConfigDir()
    let first = ConfigManager(configDir: tmp.url)
    first.excludeDatabase("SECRET-DB")
    let second = ConfigManager(configDir: tmp.url)
    #expect(second.isExcluded("SECRET-DB"))
  }

  @Test("include removes the uuid from the exclusion list")
  func includeRemoves() {
    let tmp = TempConfigDir()
    let cfg = ConfigManager(configDir: tmp.url)
    cfg.excludeDatabase("DB-X")
    cfg.includeDatabase("DB-X")
    #expect(cfg.isExcluded("DB-X") == false)
  }

  @Test("privacy mode toggle persists")
  func privacyModeTogglePersists() {
    let tmp = TempConfigDir()
    let cfg = ConfigManager(configDir: tmp.url)
    cfg.privacyMode = true
    let reloaded = ConfigManager(configDir: tmp.url)
    #expect(reloaded.privacyMode == true)
  }

  // MARK: - Bad paths

  @Test("excluding the same uuid twice does not duplicate it")
  func excludeIsIdempotent() {
    let tmp = TempConfigDir()
    let cfg = ConfigManager(configDir: tmp.url)
    cfg.excludeDatabase("DB-Y")
    cfg.excludeDatabase("DB-Y")
    #expect(cfg.excludedDatabases.filter { $0 == "DB-Y" }.count == 1)
  }

  @Test("including a uuid that was never excluded is a no-op")
  func includeUnknownIsNoop() {
    let tmp = TempConfigDir()
    let cfg = ConfigManager(configDir: tmp.url)
    cfg.includeDatabase("DB-NEVER-EXCLUDED")
    #expect(cfg.excludedDatabases.isEmpty)
  }

  @Test("isExcluded returns false for the empty string")
  func isExcludedEmptyString() {
    let tmp = TempConfigDir()
    let cfg = ConfigManager(configDir: tmp.url)
    #expect(cfg.isExcluded("") == false)
  }
}
