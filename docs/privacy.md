# Privacy

Having an LLM/AI work with your documents means these are sent to the LLM provider's servers. Your data, potentially private, goes off-site. You may not want that.

DEVONthink's built-in chat does NOT send original documents to the LLM—metadata is stripped and images are processed. Look up DEVONthink's help on "AI Explained" for details. 
DEVONthink's treatment of documents before they are part of an AI query is well done - this MCP server does not yet come close to that level of anonymization, you do well to consider that before use. 

Whereas DEVONthink's chat removes PII and other sensitive information, dt-mcp's strategy is to replace it with a unique text string that is encoded with a local key. So the private info remains part of the contents that potentially can be searched locally since you, the user, has the encryption key. However, keep in mind that even then your query remains unencrypted.

**This MCP server now offers the `PRIVATE` tag:**

| Document Type | What Gets Sent to LLM |
|---------------|----------------------|
| Regular documents | Full content as-is |
| `PRIVATE`-tagged documents | Anonymized content with PII tokenized |

## How PRIVATE Tag Works

Tag any document with `PRIVATE` (case-insensitive) in DEVONthink, and when accessed via this MCP:

1. **PII is tokenized** - sensitive data is replaced with HMAC-encoded tokens:
   - Emails → `[EM:xxxxxxxx]`
   - Phone numbers → `[PH:xxxxxxxx]`
   - Credit cards → `[CC:xxxxxxxx]`
   - SSN → `[SS:xxxxxxxx]`
   - Account numbers/IDs → `[NN:xxxxxxxx]`

2. **Metadata is stripped** - author, dates, paths, URLs, comments are removed

3. **Tokens are correlatable** - the LLM can still understand "these 3 emails are from the same person" without seeing the actual address

4. **Tokens are decodable** - original values are stored locally in `~/.config/dt-mcp/token_cache.json` for later retrieval

5. **Write-protected** - the AI cannot modify, delete, move, or change metadata on PRIVATE-tagged documents

## What Stays Local

- Actual email addresses, phone numbers, SSNs, credit cards
- DEVONthink searches (run locally with real values)
- Token-to-original mappings

## Configuration Files

Located in `~/.config/dt-mcp/`:

| File | Purpose |
|------|---------|
| `config.json` | Encryption key (auto-generated on first run), phone patterns |
| `token_cache.json` | Maps tokens back to original values for later retrieval |

## What Goes to LLM

- Tokenized content (meaningless without local key)
- Document names and non-PII text

## Token Tools

These tools allow working with privacy tokens:

| Tool | Purpose |
|------|---------|
| `encode_value` | Encode a PII value to get its token. Use to search PRIVATE docs for known values. |
| `decode_token` | Decode a single token back to original value |
| `decode_tokens` | Batch decode multiple tokens |
| `clear_token_cache` | Clear all cached token mappings |

### encode_value Types

| Type | Token Format | Example |
|------|-------------|---------|
| `email` | `[EM:xxxx]` | john@example.com → `[EM:a1b2c3d4]` |
| `phone` | `[PH:xxxx]` | +1-555-123-4567 → `[PH:e5f6g7h8]` |
| `ssn` | `[SS:xxxx]` | 123-45-6789 → `[SS:i9j0k1l2]` |
| `card` | `[CC:xxxx]` | 4111-1111-1111-1111 → `[CC:m3n4o5p6]` |
| `number` | `[NN:xxxx]` | 987654321 → `[NN:q7r8s9t0]` |

### Example: Verify a token matches a known value

```
1. You see [SS:a1b2c3d4] in a PRIVATE document
2. encode_value("123-45-6789", type: "ssn") → [SS:a1b2c3d4]
3. Tokens match → confirms the SSN in the document is 123-45-6789
```

**Note:** You cannot search DEVONthink for tokens. DEVONthink indexes original content, not tokenized content. Tokenization only happens when content is read and sent to the LLM.

## Privacy Mode

A global toggle that strips metadata from ALL documents (not just PRIVATE-tagged).

### Enable/Disable

```
set_privacy_mode(enabled: true)   # Enable
set_privacy_mode(enabled: false)  # Disable
get_privacy_mode()                # Check status
```

### What Gets Stripped

| Stripped | Kept |
|----------|------|
| author | name |
| path | uuid |
| URL | tags |
| comment | content |
| dates (creation, modification) | |
| custom metadata | |

### Privacy Mode vs PRIVATE Tag

| Feature | Privacy Mode | PRIVATE Tag |
|---------|--------------|-------------|
| Scope | All documents | Tagged documents only |
| Metadata | Stripped | Stripped |
| Content | Unchanged | Tokenized (PII replaced) |
| Write protection | No | Yes |

Use **Privacy Mode** for general metadata reduction. Use **PRIVATE tag** for sensitive documents requiring PII tokenization and write protection.

**Note:** Privacy Mode only strips metadata. Content of non-PRIVATE documents (including any PII like emails, phone numbers, SSN) is sent unchanged to the LLM.

## Database Exclusion

Hide entire databases from MCP completely. Excluded databases are invisible to the AI.

### Tools

| Tool | Purpose |
|------|---------|
| `exclude_database` | Add database UUID to exclusion list |
| `include_database` | Remove database UUID from exclusion list |
| `list_excluded_databases` | Show currently excluded database UUIDs |

### What Happens

When a database is excluded:

- **Hidden from list_databases** - the database doesn't appear in the list
- **Search results filtered** - records from excluded databases are not returned
- **Direct access blocked** - any operation on records in excluded databases returns an error
- **Creates records blocked** - cannot import, create, or download to excluded databases

### Example

```
# Exclude a database
exclude_database(uuid: "ABC123...")

# The AI can no longer:
# - See the database in list_databases
# - Find any records from that database in search results
# - Access any record from that database directly
# - Create new records in that database

# Re-include the database
include_database(uuid: "ABC123...")
```

### Configuration

Excluded databases are stored in `~/.config/dt-mcp/config.json` under `excluded_databases` (array of UUIDs).

### Use Case

"Some databases the AI should never see at all" - financial records, medical data, legal documents, etc.

## Image Handling

Control what image data leaves your machine. Images require explicit confirmation before being sent.

### Two-Step Confirmation

The `preview_images` tool uses a two-step flow:

1. **First call** - Returns metadata (dimensions, size) and any EXIF data found (author, GPS, camera, etc.)
2. **Second call with `confirmed: true`** - Returns actual image data for AI analysis

The AI must ask: "Do you want me to analyze this image? (A scaled version will be sent to Anthropic)"

This ensures you know what private EXIF data exists and can decide whether to send the image.

### Image Processing

When images are retrieved:

- **Scaled** - Maximum dimension 512px (configurable)
- **EXIF stripped** - No GPS, camera info, author, or other metadata
- **Adaptive compression** - JPEG quality adjusted (0.8 → 0.25) to fit under 50KB for Claude Code

### Configuration

In `~/.config/dt-mcp/config.json`:

```json
{
  "image_handling": {
    "private_images": "thumbnail",
    "max_dimension": 512
  }
}
```

### Private Image Modes

For PRIVATE-tagged images, the `private_images` setting controls behavior:

| Mode | Behavior |
|------|----------|
| `thumbnail` (default) | Returns scaled/stripped image when confirmed |
| `text_only` | Only metadata, never actual image data |
| `blocked` | No access at all (error on attempt) |

### Tool

| Tool | Description |
|------|-------------|
| `preview_images` | Preview image with confirmation flow |

### What Gets Sent

| Data Type | Sent to LLM |
|-----------|-------------|
| Filename | Yes |
| Dimensions | Yes |
| File size | Yes |
| EXIF data | No (stripped) |
| Full resolution | No (scaled) |
| GPS coordinates | No (stripped) |

### Use Case

"AI can't see my photos without asking first" - the confirmation flow ensures you're aware when images are being sent.
