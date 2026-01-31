# Translation Learnings Schema

Learnings files are JSONL (one JSON object per line) stored as `<lang>.jsonl` in this directory. When discovering new mappings or conventions during editing, append a single JSONL line to the appropriate file.

## Entry Types

### mapping

Maps an English term or phrase to its target-language equivalent.

| Key | Required | Description |
|-----|----------|-------------|
| `type` | yes | `"mapping"` |
| `en` | yes | English term or phrase |
| `ja`/`fr` | yes | Target-language equivalent |
| `avoid` | no | Wrong or less natural alternative |
| `domain` | no | Subject area (e.g., `"math"`, `"cryptography"`, `"ai"`) |
| `notes` | no | Extra context |

### style

A convention or rule for writing in the target language. Not a mapping — an instruction.

| Key | Required | Description |
|-----|----------|-------------|
| `type` | yes | `"style"` |
| `rule` | yes | What to do (written in English) |
| `avoid` | no | What not to do |
| `en` | no | English pattern that triggers this rule |
| `domain` | no | Subject area, if specific |
