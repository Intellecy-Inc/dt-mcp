# Examples

## Using Tools

You can call tools directly by name:

> "Call list_databases"

Or simply use natural language - the AI will determine which tool to use:

> "What databases do I have?"

Both achieve the same result. The AI interprets your intent and calls the appropriate dt-mcp tool automatically.

## Simple Interactions

### Find and summarize recent notes

Search your database for notes on a topic and get a quick summary. Assume the database is called 'projects'

> "Search projects for notes about 'project planning' and summarize the key points."

### Create a meeting note

Quickly capture meeting notes directly into DEVONthink with proper tagging.

> "Create a new markdown note in DEVONthink called 'Team Sync 2024-12-24' with tags 'meetings' and 'work'. Include these discussion points: budget review, Q1 goals, hiring timeline."

### Analyze selected document

Work with whatever document you currently have selected in DEVONthink.

> "Look at my currently selected document in DEVONthink and extract all action items or tasks mentioned."

## Cross-Tool Examples

### Import project documentation

Scan a codebase and import relevant docs into DEVONthink.

> "Find all README and markdown files in ~/Projects/myapp and import them into my 'Development' database in DEVONthink."

### Research with web + archive

Combine live web search with your personal knowledge base.

> "Search the web for 'Swift concurrency best practices' and also check what I have in DEVONthink on this topic. Compare the findings."

### Export for version control

Pull content from DEVONthink into your project.

> "Get the API specification document from DEVONthink and save it as docs/api-spec.md in my current project."

### Patent prior art search

When an engineer has a new idea, check it against your patent database for potential conflicts.

> "I have an idea for a 'wireless charging system that uses resonant inductive coupling with automatic frequency tuning to optimize power transfer based on device distance.' Search my 'patents & ip' database for similar patents and tell me if this concept appears to already be covered."

The AI will search your patent database, use DEVONthink's "see also" to find conceptually similar documents, analyze matching patents, and flag potential prior art.

## Quick Reference

Once configured, you can ask Claude questions like:

- "List my DEVONthink databases"
- "Search for documents about machine learning"
- "Show me the contents of [record name]"
- "Create a new markdown note called 'Meeting Notes' in the Inbox"
- "What tags are in my research database?"
- "Find documents similar to this one"
