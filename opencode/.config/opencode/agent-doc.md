# OpenCode Agents Guide

## Overview

| Agent | Model | Purpose |
|-------|-------|---------|
| **Oracle** | claude-opus-4-5 + extended thinking | Senior advisor - architecture, debugging, planning |
| **Librarian** | claude-sonnet-4-5 | Remote repo exploration (GitHub/npm/PyPI) |
| **Review** | default, temp=0.1 | Code review - bugs, security, quality |
| **OpenCode-Expert** | default | OpenCode config & troubleshooting |

All agents are **read-only** - they advise, primary agent acts.

---

## Oracle

Senior engineering advisor with extended thinking (31,999 budget tokens).

### Use For
- Architecture decisions with significant trade-offs
- Complex debugging (race conditions, subtle logic errors)
- Refactor planning before major changes
- Strategic technical decisions
- "Second opinion" from a smarter model

### Don't Use For
- Simple code changes (overkill, slow, expensive)
- Exploratory coding (can't make changes)
- Quick questions (use primary agent)
- Third-party library questions (use Librarian)

### Examples

```
# Good
@oracle Review auth middleware for security issues
@oracle Plan refactor of payment processing module
@oracle Debug this race condition in concurrent requests

# Bad
@oracle What does React useState do?    -> use Librarian
@oracle Add a log statement             -> can't write, use primary
@oracle Fix this typo                   -> overkill, use primary
```

---

## Librarian

Multi-repository codebase explorer. Fetches/analyzes code from GitHub/npm/PyPI/crates.

### Use For
- Understanding 3rd-party library internals
- Tracing execution flow through open-source code
- Finding implementation patterns in other codebases
- Comparing different approaches across projects
- Documentation research for unfamiliar libraries

### Don't Use For
- Local project code (use grep/read directly)
- Code changes (read-only)
- Quick API lookups (check docs instead)
- Architecture decisions (use Oracle)

### Examples

```
# Good
@librarian How does Zustand implement store subscriptions?
@librarian Compare error handling in Zod vs Valibot
@librarian How does Next.js handle route caching?

# Bad
@librarian What files are in my src/?           -> local, use primary
@librarian Should I use Redux or Zustand?       -> use Oracle for decisions
@librarian Add a new API endpoint               -> can't write
```

---

## Review

Focused code reviewer with temperature=0.1 for deterministic output.

### Use For
- Pre-commit review of significant changes
- Security-sensitive code (auth, crypto, input validation)
- Complex logic validation
- Pull request review assistance

### Don't Use For
- Architecture advice (use Oracle)
- Style nitpicks (explicitly avoids zealotry)
- Pre-existing code that wasn't modified
- General advice (it finds bugs, not advises)

### Examples

```
# Good
@review Check my auth changes for security issues
@review Review this payment processing logic
@review Verify error handling in API endpoints

# Bad
@review Is this the right architectural approach?   -> use Oracle
@review Fix these bugs                              -> identifies only, can't fix
@review Should I use class or function components?  -> use Oracle
```

---

## OpenCode-Expert

Configuration specialist with access to OpenCode source code.

### Use For
- OpenCode configuration questions
- Debugging permission issues
- Setting up MCP servers
- Creating custom agents/commands/tools
- Understanding OpenCode internals

### Don't Use For
- General coding questions
- Non-OpenCode tooling
- Code reviews
- Architecture decisions

### Examples

```
# Good
@opencode-expert How do I configure per-command bash permissions?
@opencode-expert Why is my MCP server not connecting?
@opencode-expert How do I create a custom agent?

# Bad
@opencode-expert Review my React component      -> use Review
@opencode-expert How does Express routing work? -> use Librarian
@opencode-expert Plan my API architecture       -> use Oracle
```

---

## Decision Flow

```
Need deep reasoning/planning?     -> Oracle
Need library internals?           -> Librarian
Need bug/security review?         -> Review
Need OpenCode help?               -> OpenCode-Expert
Everything else                   -> Primary agent
```

---

## Complementary Patterns

| Pattern | Flow |
|---------|------|
| Research then decide | Librarian (how does X work?) -> Oracle (should we use X?) |
| Plan, implement, verify | Oracle (plan) -> Primary (implement) -> Review (verify) |
| Learn then apply | OpenCode-Expert (config syntax) -> Primary (apply config) |

---

## Configuration Reference

Agents are markdown files with YAML frontmatter in `agent/`:

```yaml
---
description: One-line description
mode: subagent
model: anthropic/claude-opus-4-5  # optional
temperature: 0.1                   # optional
options:
  thinking:
    type: enabled
    budgetTokens: 31999
permission:
  "*": deny          # default deny (whitelist)
  read: allow
  grep: allow
tools:
  write: false       # shorthand
  edit: false
---

System prompt content...
```

### Invocation

```
@agent-name Your prompt here
```

Primary agent invokes subagent, passes context, receives final message.
