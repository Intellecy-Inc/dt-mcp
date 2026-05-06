//
//  EscapeTests.swift
//  dt-mcp tests
//

import Testing
@testable import dt_mcp

@Suite("DEVONthinkBridge.escape — AppleScript injection boundary")
struct EscapeTests {
  let bridge = DEVONthinkBridge()

  // MARK: - Happy paths: safe strings pass through unchanged

  @Test("empty string")
  func emptyString() {
    #expect(bridge.escape("") == "")
  }

  @Test("ASCII with no special chars is unchanged", arguments: [
    "hello",
    "plain query text",
    "uuid-41758C2A-1C84-4B25",
    "path/to/something.pdf",
    "user@example.com",
    "with spaces and (parens)"
  ])
  func asciiPassthrough(_ input: String) {
    #expect(bridge.escape(input) == input)
  }

  @Test("unicode passes through untouched")
  func unicode() {
    #expect(bridge.escape("café ☕ 日本語") == "café ☕ 日本語")
  }

  // MARK: - Bad paths: AppleScript-meaningful chars must be encoded

  @Test("single backslash is doubled")
  func backslash() {
    #expect(bridge.escape(#"\"#) == #"\\"#)
  }

  @Test("double quote is backslash-escaped")
  func doubleQuote() {
    #expect(bridge.escape("\"") == "\\\"")
  }

  @Test("literal newline is encoded as \\n (not left as LF)")
  func newline() {
    let out = bridge.escape("\n")
    #expect(out == "\\n")
    // The actual LF character must not survive — that is the bug the
    // previous escape() had that allowed AppleScript injection.
    #expect(!out.contains("\n"))
  }

  @Test("literal carriage return is encoded as \\r")
  func carriageReturn() {
    let out = bridge.escape("\r")
    #expect(out == "\\r")
    #expect(!out.contains("\r"))
  }

  @Test("literal tab is encoded as \\t")
  func tab() {
    let out = bridge.escape("\t")
    #expect(out == "\\t")
    #expect(!out.contains("\t"))
  }

  @Test("order is backslash-first so newline escapes aren't doubled")
  func escapeOrder() {
    // If escape() ran newline-before-backslash, "\n" would become "\\n"
    // and then the backslash pass would turn it into "\\\\n" — 4 chars.
    // Correct behaviour: backslash first (no-op on bare LF), then LF → \n.
    #expect(bridge.escape("\n") == "\\n")  // 2 chars: \ n
  }

  @Test("injection payload from the hardening fix is fully encoded")
  func injectionPayload() {
    // Literal LF + "end tell" is the attack that the old escape() missed.
    let payload = "foo\"\nend tell\ntell application \"Finder\"\nempty trash"
    let out = bridge.escape(payload)
    // After escape: no raw newlines, no unescaped quotes.
    #expect(!out.contains("\n"))
    #expect(!out.contains("\r"))
    // Every " must be preceded by \. Walk the string and verify.
    var prev: Character = " "
    for ch in out {
      if ch == "\"" {
        #expect(prev == "\\", "unescaped quote at position in: \(out)")
      }
      prev = ch
    }
  }

  @Test("combined special characters all encode correctly")
  func combined() {
    let input = "a\\b\"c\nd\re\tf"
    let expected = #"a\\b\"c\nd\re\tf"#
    #expect(bridge.escape(input) == expected)
  }

  @Test("escape is idempotent on already-safe output (no double-encoding)")
  func idempotenceOnSafeOutput() {
    // Pure-ASCII strings with no special chars should survive any number
    // of escape passes. This is the invariant for names/UUIDs.
    let safe = "just-a-plain-uuid-string"
    #expect(bridge.escape(bridge.escape(safe)) == safe)
  }
}
