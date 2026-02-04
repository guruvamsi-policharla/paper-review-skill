# Paper Review Skill

Systematic LaTeX paper review for correctness, clarity, and consistency. Builds a high-level overview from introduction/technical overview sections, then reviews each section in parallel with shared context.

Works with **OpenCode**, **Claude Code**, and **OpenAI Codex**.

## Install

Global installation (available in all projects):

```bash
curl -fsSL https://raw.githubusercontent.com/guruvamsi-policharla/paper-review-skill/main/install.sh | bash
```

Local installation (current project only):

```bash
curl -fsSL https://raw.githubusercontent.com/guruvamsi-policharla/paper-review-skill/main/install.sh | bash -s -- --local
```

Install for a specific tool only:

```bash
# OpenCode only
curl -fsSL https://raw.githubusercontent.com/guruvamsi-policharla/paper-review-skill/main/install.sh | bash -s -- --opencode

# Claude Code only
curl -fsSL https://raw.githubusercontent.com/guruvamsi-policharla/paper-review-skill/main/install.sh | bash -s -- --claude

# OpenAI Codex only
curl -fsSL https://raw.githubusercontent.com/guruvamsi-policharla/paper-review-skill/main/install.sh | bash -s -- --codex
```

## Usage

**Important:** Run this skill from the directory containing your LaTeX source files (`.tex` files).

```bash
cd /path/to/your/paper
```

Then use the `/paper-review` command (OpenCode/Claude Code) or `$paper-review` (Codex):

```
# OpenCode / Claude Code
/paper-review review this paper

# OpenAI Codex
$paper-review review this paper
```

Review specific sections:

```
/paper-review review only the Methods and Results sections
```

Prioritize certain checks:

```
/paper-review focus on proof correctness
```

### Updating

To update to the latest version, re-run the install command.

## Tips for Best Results

### Paper Structure

- **Use clear section names**: "Methods" works better than "Section 3"
- **Define notation explicitly**: Papers with a notation/preliminaries section get better consistency checking
- **Use `\section{}` commands**: The skill parses LaTeX structure to find sections

### Multi-file Projects

The skill automatically resolves `\input{}` and `\include{}` commands, so splitting your paper across multiple `.tex` files works fine. Just run from the directory containing your main file.

### What to Review

- **Full review**: Just say "review this paper" for a complete analysis
- **Targeted review**: Specify sections if you only changed part of the paper
- **Focused review**: Ask to prioritize specific aspects (proofs, clarity, notation)

### Iterating on Feedback

After making changes based on the review:

```
/paper-review re-review the Methods section
```

### Large Papers

For very long papers, consider reviewing a few sections at a time to get more detailed feedback.

## Structure

The installer adds skills to the appropriate locations:

```
# OpenCode
.opencode/skills/paper-review/    # or ~/.config/opencode/skills/paper-review/
.opencode/command/paper-review.md # or ~/.config/opencode/command/paper-review.md

# Claude Code
.claude/skills/paper-review/      # or ~/.claude/skills/paper-review/

# OpenAI Codex
.agents/skills/paper-review/      # or ~/.agents/skills/paper-review/
```

Skill contents:

```
paper-review/
├── SKILL.md                  # Main orchestrator
└── prompts/
    ├── overview-builder.md   # Extracts paper context
    └── section-reviewer.md   # Reviews individual sections
```

## What Gets Reviewed

| Check Type | Description |
|------------|-------------|
| Technical Correctness | Math errors, proof gaps, unsupported claims |
| Notation Consistency | Symbols matching definitions, undefined notation |
| Writing Clarity | Ambiguous statements, undefined terms |
| Structure/Flow | Logical organization, transitions, completeness |

## Issue Severity

| Severity | Description |
|----------|-------------|
| **Critical** | May indicate incorrectness (math errors, proof gaps) |
| **Major** | Significant quality impact (missing details, notation conflicts) |
| **Minor** | Should be fixed (typos, minor clarity issues) |
| **Suggestions** | Optional improvements (style, examples) |

## Output

Generates `report.md` in your paper directory with:

- Executive summary
- Paper overview (goals, contributions, notation dictionary)
- Detailed section reviews with categorized issues
- Summary statistics
- Prioritized action items

## How It Works

1. **Discovery** - Parses LaTeX structure, resolves `\input{}` and `\include{}`
2. **Overview Building** - Extracts context from Introduction + Technical Overview
3. **Parallel Review** - Reviews each section with shared overview context
4. **Report Generation** - Aggregates findings into structured report

## License

MIT
