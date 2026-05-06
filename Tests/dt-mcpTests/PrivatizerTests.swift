//
//  PrivatizerTests.swift
//  dt-mcp tests
//
//  Uses non-singleton instances backed by a temp config dir so tests never
//  touch the user's real ~/.config/dt-mcp.
//

import Testing
import Foundation
@testable import dt_mcp

@MainActor
@Suite("Privatizer — PII tokenization and record privatization")
struct PrivatizerTests {

  /// Build a fresh Privatizer bound to a throwaway temp dir so tests are
  /// hermetic and share no state with each other or the user's install. The
  /// returned TempConfigDir must stay in scope for the test's lifetime — its
  /// deinit removes the directory.
  func makePrivatizer() -> (Privatizer, TempConfigDir) {
    let tmp = TempConfigDir()
    let config = ConfigManager(configDir: tmp.url)
    let cache = TokenCache(configDir: tmp.url)
    return (Privatizer(config: config, cache: cache), tmp)
  }

  // MARK: - isPrivate: tag detection

  @Test("isPrivate detects the PRIVATE tag case-insensitively", arguments: [
    ["PRIVATE"],
    ["private"],
    ["Private"],
    ["work", "PRIVATE", "2026"]
  ])
  func isPrivateDetected(_ tags: [String]) {
    let (p, _tmp) = makePrivatizer()
    #expect(p.isPrivate(tags) == true)
  }

  @Test("isPrivate returns false for non-PRIVATE tag sets", arguments: [
    [],
    ["work"],
    ["priv"],           // substring, not full tag
    ["PRIVATE-NOT"],    // prefix match should not count
    ["archived", "2026"]
  ])
  func isPrivateNotDetected(_ tags: [String]) {
    let (p, _tmp) = makePrivatizer()
    #expect(p.isPrivate(tags) == false)
  }

  @Test("isPrivate on record dict reads the tags field")
  func isPrivateOnRecord() {
    let (p, _tmp) = makePrivatizer()
    #expect(p.isPrivate(["tags": ["PRIVATE"]] as [String: Any]) == true)
    #expect(p.isPrivate(["tags": ["work"]] as [String: Any]) == false)
    #expect(p.isPrivate(["name": "no tags key"] as [String: Any]) == false)
  }

  // MARK: - Email tokenization

  @Test("email is replaced by a [EM:xxxxxxxx] token")
  func emailTokenized() {
    let (p, _tmp) = makePrivatizer()
    let out = p.privatize("contact me at alice@example.com please")
    #expect(out.contains("[EM:"))
    #expect(!out.contains("alice@example.com"))
  }

  @Test("same email produces the same token (correlation preserved)")
  func emailDeterministic() {
    let (p, _tmp) = makePrivatizer()
    let t1 = p.encodeEmail("alice@example.com")
    let t2 = p.encodeEmail("ALICE@example.com")  // case-insensitive normalization
    #expect(t1 == t2)
  }

  @Test("different emails produce different tokens")
  func emailDistinct() {
    let (p, _tmp) = makePrivatizer()
    let a = p.encodeEmail("alice@example.com")
    let b = p.encodeEmail("bob@example.com")
    #expect(a != b)
  }

  // MARK: - SSN / Credit card tokenization

  @Test("SSN matching 3-2-4 pattern is tokenized")
  func ssnTokenized() {
    let (p, _tmp) = makePrivatizer()
    let out = p.privatize("SSN: 123-45-6789.")
    #expect(out.contains("[SS:"))
    #expect(!out.contains("123-45-6789"))
  }

  @Test("credit card number is tokenized")
  func cardTokenized() {
    let (p, _tmp) = makePrivatizer()
    let out = p.privatize("Card 4111-1111-1111-1111 expires soon")
    #expect(out.contains("[CC:"))
    #expect(!out.contains("4111-1111-1111-1111"))
  }

  // MARK: - Non-PII should not be over-tokenized (guard against false positives)

  @Test("text without PII is returned unchanged")
  func nonPIIUnchanged() {
    let (p, _tmp) = makePrivatizer()
    let plain = "The quick brown fox jumped over a lazy dog."
    #expect(p.privatize(plain) == plain)
  }

  // MARK: - stripMetadata

  @Test("stripMetadata removes sensitive fields and keeps core identity")
  func stripMetadataRemovesPII() {
    let (p, _tmp) = makePrivatizer()
    let record: [String: Any] = [
      "uuid": "abc-123",
      "name": "Paper.pdf",
      "tags": ["research"],
      "path": "/Users/someone/Databases/x.dtBase2",
      "url": "https://private.example/doc",
      "comment": "sensitive note",
      "creationDate": "2026-01-01",
      "modificationDate": "2026-02-01",
      "customMetadata": ["author": "Me"]
    ]
    let out = p.stripMetadata(record)
    // Kept
    #expect(out["uuid"] as? String == "abc-123")
    #expect(out["name"] as? String == "Paper.pdf")
    // Stripped
    #expect(out["path"] == nil)
    #expect(out["url"] == nil)
    #expect(out["comment"] == nil)
    #expect(out["creationDate"] == nil)
    #expect(out["modificationDate"] == nil)
    #expect(out["customMetadata"] == nil)
  }

  // MARK: - privatizeRecord

  @Test("privatizeRecord marks writeProtected and tokenizes plainText")
  func privatizeRecordHappy() {
    let (p, _tmp) = makePrivatizer()
    let record: [String: Any] = [
      "uuid": "abc",
      "name": "Notes",
      "tags": ["PRIVATE"],
      "plainText": "Email alice@example.com about the invoice",
      "path": "/private/path"
    ]
    let out = p.privatizeRecord(record)
    #expect(out["writeProtected"] as? Bool == true)
    #expect(out["path"] == nil)
    let text = out["plainText"] as? String ?? ""
    #expect(text.contains("[EM:"))
    #expect(!text.contains("alice@example.com"))
  }

  // MARK: - checkWritePermission

  @Test("checkWritePermission throws on PRIVATE-tagged records")
  func writePermissionDeniedForPrivate() {
    let (p, _tmp) = makePrivatizer()
    #expect(throws: MCPError.self) {
      try p.checkWritePermission(uuid: "abc", tags: ["PRIVATE"])
    }
  }

  @Test("checkWritePermission succeeds for non-PRIVATE records")
  func writePermissionAllowedForNonPrivate() throws {
    let (p, _tmp) = makePrivatizer()
    try p.checkWritePermission(uuid: "abc", tags: ["work"])
    try p.checkWritePermission(uuid: "abc", tags: [])
  }

  // MARK: - normalizePhone

  @Test("phone normalization strips non-digits and adds +", arguments: [
    ("+1-555-123-4567", "+15551234567"),
    ("(555) 123-4567",  "+5551234567"),
    ("+44 20 7946 0958", "+442079460958"),
    ("5551234",         "+5551234")
  ])
  func phoneNormalized(input: String, expected: String) {
    let (p, _tmp) = makePrivatizer()
    #expect(p.normalizePhone(input) == expected)
  }
}
