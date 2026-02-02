# Paper Review Skill

A systematic, agent-agnostic skill for reviewing academic computer science papers in LaTeX format. Designed to work with any LLM-based coding agent (Claude, GPT, Codex, etc.).

## Overview

This skill automates comprehensive paper review by:

1. **Parsing** LaTeX structure to discover all sections
2. **Building context** from introduction/overview sections
3. **Parallel reviewing** each section with shared context
4. **Generating** a structured `report.md` with categorized issues

```
┌─────────────────────────────────────────────────────────────────┐
│                     MAIN ORCHESTRATOR                           │
│  1. Parse LaTeX → Find sections                                 │
│  2. Build Paper Overview (intro + technical overview)           │
│  3. Dispatch parallel section reviews                           │
│  4. Aggregate → report.md                                       │
└─────────────────────────────────────────────────────────────────┘
         │
         ├────────────┬────────────┬────────────┬────────────┐
         ▼            ▼            ▼            ▼            ▼
    [Methods]    [Results]   [Related]   [Theory]    [Appendix]
     Review       Review      Review      Review       Review
```

## Quick Start

### Basic Usage

Navigate to your paper's directory (containing `.tex` files) and invoke:

```
Review this paper following the paper-review skill
```

Or with a specific agent:

```bash
# With OpenCode
opencode "Review this paper following the paper-review skill"

# With Claude
claude "Review this paper following the paper-review skill"

# With Codex/GPT
# Load the paper-review.md as context and run in the paper directory
```

### Review Specific Sections

```
Review only the Methods and Results sections following the paper-review skill
```

### Prioritize Certain Checks

```
Review this paper following the paper-review skill, prioritizing technical correctness in proofs
```

## File Structure

```
paper-review-skill/
├── paper-review.md              # Main orchestrator skill
├── prompts/
│   ├── overview-builder.md      # Extracts paper context
│   └── section-reviewer.md      # Reviews individual sections
└── README.md                    # This file
```

## What Gets Reviewed

### Review Criteria

| Check Type | Description |
|------------|-------------|
| **Technical Correctness** | Mathematical errors, logical fallacies, proof gaps, unsupported claims |
| **Notation Consistency** | Symbols matching definitions, no undefined notation, consistent usage |
| **Writing Clarity** | Ambiguous statements, undefined terms, unclear explanations |
| **Structure/Flow** | Logical organization, appropriate transitions, completeness |

### Issue Severity Levels

| Severity | Description | Examples |
|----------|-------------|----------|
| **Critical** | May indicate incorrectness | Math errors, proof gaps, invalid claims |
| **Major** | Significant quality impact | Missing details, unclear key concepts, notation conflicts |
| **Minor** | Should be fixed | Typos, minor clarity issues, redundancy |
| **Suggestions** | Optional improvements | Style, additional examples, alternative phrasings |

## Output

The skill generates `report.md` in your paper directory:

```markdown
# Paper Review Report

**Generated:** 2024-01-15 14:30
**Paper:** "Efficient Algorithms for Widget Optimization"
**Sections Reviewed:** 8 of 10

## Executive Summary
[High-level assessment]

## Paper Overview
[Extracted from intro + technical overview]

## Detailed Section Reviews

### 1. Introduction
#### Critical Issues
- [C1] Contribution 2 claims "first algorithm" but [Citation X] presents similar...

#### Major Issues
- [M1] Problem definition on line 45 is ambiguous...

[... continues for each section ...]

## Summary Statistics
| Severity | Count |
|----------|-------|
| Critical | 2     |
| Major    | 7     |
| Minor    | 15    |
| Suggestions | 8  |

## Prioritized Action Items
1. Fix proof gap in Theorem 3 (Critical)
2. Clarify notation for $\alpha$ vs $\alpha'$ (Major)
...
```

## How It Works

### Phase 1: Discovery

The skill scans for LaTeX structure:

```latex
% Finds main document
\documentclass{article}

% Resolves includes
\input{sections/intro}
\input{sections/methods}
\include{appendix}

% Extracts section hierarchy
\section{Introduction}
\subsection{Contributions}
\section{Methods}
...
```

### Phase 2: Context Building

Identifies overview sections:
- Introduction (always)
- Technical Overview / Overview / Our Approach (if present)
- Background / Preliminaries (for notation)

Extracts:
- Paper goals and contributions
- Methodology summary  
- **Notation dictionary** (critical for consistency checking)
- Key claims and theorems
- Evaluation strategy

### Phase 3: Parallel Review

Each section is reviewed independently with:
- Full Paper Overview as context
- Section-type-specific review criteria
- Detailed prompt from `section-reviewer.md`

### Phase 4: Aggregation

Combines all reviews into `report.md`:
- Deduplicates cross-cutting issues
- Identifies notation conflicts across sections
- Prioritizes action items by severity

## Customization

### Reviewing Specific Sections

Tell the agent which sections to focus on:

```
Review only the "Theoretical Analysis" and "Proofs" sections
```

### Adjusting Review Focus

Emphasize certain aspects:

```
Review this paper with extra attention to proof correctness
```

```
Focus the review on reproducibility and experimental methodology
```

### Handling Special Paper Structures

For papers with unusual structure:

```
Review this paper. Note: The "System Design" section serves as the technical overview.
```

## Supported LaTeX Patterns

### Document Structure
- `\documentclass{...}`
- `\input{file}` / `\input{file.tex}`
- `\include{file}`
- `\section{Title}` / `\section*{Title}`
- `\subsection{...}`, `\subsubsection{...}`, `\paragraph{...}`

### Common Macros
- The skill handles standard math notation
- Custom macros in preamble are noted but may need manual expansion

### Multi-file Projects
- Automatically resolves relative paths
- Handles nested includes
- Builds unified section map

## Limitations

- **No PDF parsing**: Requires LaTeX source files
- **No citation verification**: Doesn't check if cited papers exist or are accurate
- **No execution**: Doesn't run code or verify computational claims
- **Context limits**: Very long sections may need to be split

## Best Practices

### For Best Results

1. **Clean LaTeX**: Well-structured LaTeX with clear `\section{}` commands works best
2. **Meaningful section names**: "Methods" is better than "Section 3"
3. **Defined notation**: Papers with explicit notation sections get better consistency checking

### Interpreting Results

- **Critical issues**: Investigate immediately - may indicate real errors
- **Major issues**: Plan to address before submission
- **Minor issues**: Fix during final polish
- **Suggestions**: Consider but don't feel obligated

### Iterating

After making changes, you can re-run:

```
Re-review only the sections I modified: Methods, Results
```

## Example Session

```
User: Review this paper following the paper-review skill

Agent: I'll review your paper systematically.

**Phase 1: Discovery**
Found main.tex with 8 sections across 5 files:
1. Introduction [intro.tex]
2. Related Work [related.tex]
3. Technical Overview [overview.tex]
4. Methods [methods.tex]
5. Theoretical Analysis [theory.tex]
6. Experiments [experiments.tex]
7. Discussion [discussion.tex]
8. Conclusion [conclusion.tex]

**Phase 2: Building Paper Overview**
Extracting context from Introduction and Technical Overview...
- Found 4 contributions
- Extracted 23 notation definitions
- Identified 3 main theorems to verify

**Phase 3: Reviewing Sections**
Reviewing all 8 sections in parallel...
[Progress updates]

**Phase 4: Generating Report**
Review complete! Found:
- 1 Critical issue
- 5 Major issues  
- 12 Minor issues
- 6 Suggestions

Report saved to: report.md

The critical issue is in Theorem 2 (theory.tex:145) - there's a proof gap 
where the inequality doesn't hold for negative values. Would you like me 
to elaborate on any specific issue?
```

## Contributing

This skill is designed to be extended. Ideas for improvement:

- Additional section type classifiers
- Domain-specific review criteria (ML, systems, theory)
- Integration with reference managers
- Automated fix suggestions

## License

MIT License - Use freely for your paper reviewing needs.
