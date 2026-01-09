# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.1] - 2025-01-09

### Added
- Image handling with `preview_images` tool
- Two-step confirmation flow (metadata first, then image data)
- EXIF stripping (GPS, camera, author removed before sending)
- EXIF preview in metadata response
- Adaptive compression (quality 0.8 → 0.25) to fit Claude Code limits
- Private image modes: `thumbnail`, `text_only`, `blocked`
- `image_handling` config section

## [0.5.0] - 2025-01-08

### Added
- Database exclusion feature
- `exclude_database`, `include_database`, `list_excluded_databases` tools
- Excluded databases hidden from all operations
- `/dt-exclude`, `/dt-include`, `/dt-exclusions` skills

## [0.4.0] - 2025-01-07

### Added
- Privacy mode toggle (`set_privacy_mode`, `get_privacy_mode`)
- Metadata stripping for all documents when enabled

## [0.3.0] - 2025-01-06

### Added
- Token encoding/decoding tools
- `encode_value`, `decode_token`, `decode_tokens`, `clear_token_cache`

## [0.2.0] - 2025-01-05

### Added
- PRIVATE tag support for document anonymization
- PII tokenization (emails, phones, SSN, credit cards)
- Write protection for PRIVATE-tagged documents

## [0.1.0] - 2024-12-24

### Added
- Initial release
- 44 MCP tools for DEVONthink integration
- Database operations: list, open, close, verify, optimize
- Record management: create, read, update, delete, move, duplicate, replicate
- Content access in plain text, Markdown, and HTML formats
- Tag operations: get, set, add, remove
- Custom metadata support
- AI features: classify, see also, summarize, concordance
- Web capture: bookmarks, web archives, Markdown conversion
- OCR: import with OCR, convert to searchable PDF
- Links: item URLs, incoming/outgoing references
- Reminders and smart groups
- Window management
- Universal binary (Intel + Apple Silicon)
- Signed and notarized by Apple
