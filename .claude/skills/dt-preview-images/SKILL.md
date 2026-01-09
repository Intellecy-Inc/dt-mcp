---
name: dt-preview-images
description: Preview and analyze an image from DEVONthink. Use when user wants to see, view, analyze, or describe an image.
---

# Preview Images

Preview and analyze images from DEVONthink with privacy protection.

## Instructions

1. If the user provides an image name, first search for it: `search` with `kind:image` and the name
2. Call `preview_images` with `confirmed: false` to get metadata and EXIF info
3. Show the user:
   - Image name and dimensions
   - Any EXIF data found (author, GPS, camera, etc.)
   - Warning: "A scaled version will be sent to Anthropic"
4. Ask: "Do you want me to analyze this image?"
5. Only after user confirms, call `preview_images` with `confirmed: true`
6. Describe what you see in the image - NEVER output the base64 data

## Privacy Features

- EXIF metadata is stripped before sending
- Images are scaled to max 512px
- Adaptive compression keeps size under 50KB
- PRIVATE-tagged images respect `private_images` config setting
