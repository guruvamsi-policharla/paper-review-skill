---
description: Review LaTeX papers for correctness, clarity, and consistency
---

Load the Paper Review skill and systematically review a LaTeX paper.

## Workflow

### Step 1: Check for --update-skill flag

If $ARGUMENTS contains `--update-skill`:

1. Determine install location by checking which exists:
   - Local: `.opencode/skills/paper-review/`
   - Global: `~/.config/opencode/skills/paper-review/`

2. Run the appropriate install command:
   ```bash
   # For local installation
   curl -fsSL https://raw.githubusercontent.com/guruvamsi-policharla/paper-review-skill/main/install.sh | bash

   # For global installation
   curl -fsSL https://raw.githubusercontent.com/guruvamsi-policharla/paper-review-skill/main/install.sh | bash -s -- --global
   ```

3. Output success message and stop (do not continue to other steps).

### Step 2: Load paper-review skill

```
skill({ name: 'paper-review' })
```

### Step 3: Identify review scope from user request

Analyze $ARGUMENTS to determine:
- **Specific sections** to review (if user specified) or all sections
- **Priority focus** (technical correctness, notation, clarity, etc.)
- **Paper location** (current directory by default)

### Step 4: Execute the review following SKILL.md

The skill defines a 4-phase review process:

1. **Phase 1: Discovery** - Parse LaTeX structure, find all sections
2. **Phase 2: Build Overview** - Extract context from intro + technical overview
3. **Phase 3: Section Review** - Review each section with overview as context
4. **Phase 4: Report Generation** - Generate report.md with all findings

Read the prompts from:
- `prompts/overview-builder.md` - For building paper overview
- `prompts/section-reviewer.md` - For reviewing individual sections

### Step 5: Generate report

Create `report.md` in the paper directory with:
- Executive summary
- Paper overview
- Detailed section reviews (Critical/Major/Minor/Suggestions)
- Summary statistics
- Prioritized action items

### Step 6: Summarize

```
=== Paper Review Complete ===

Sections reviewed: <count>
Issues found: <critical> critical, <major> major, <minor> minor, <suggestions> suggestions

Report saved to: report.md

Top issues:
1. <most critical issue>
2. <second most critical>
3. <third most critical>
```

<user-request>
$ARGUMENTS
</user-request>
