# OpenCode Agents Guide

## Overview

| Agent | Model | Purpose |
|-------|-------|---------|
| **oracle** | anthropic/claude-opus-4-5 + extended thinking | Senior advisor - architecture, debugging, planning |
| **librarian** | anthropic/claude-sonnet-4-5 | Remote repo exploration (GitHub/npm/PyPI) |
| **code-reviewer** | default, temp=0.1 | Code review - bugs, security, quality |
| **opencode-expert** | default, temp=0.1 | OpenCode config & troubleshooting |
| **overseer** | anthropic/claude-opus-4-5 | Task management via Overseer MCP |

All agents are **advisory** - they advise, primary agent acts. Most are read-only; librarian has broader tool access for exploration.

### Built-in Agents

| Agent | Mode | Purpose |
|-------|------|---------|
| `build` | primary | Default primary agent |
| `plan` | primary | Planning mode (read-only edits) |
| `general` | subagent | General-purpose subagent |
| `explore` | subagent | Fast codebase exploration |

---

## oracle

Senior engineering advisor with extended thinking (31,999 budget tokens). Uses `anthropic/claude-opus-4-5`.

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
- Third-party library questions (use librarian)

### Examples

```
# Good
@oracle Review auth middleware for security issues
@oracle Plan refactor of payment processing module
@oracle Debug this race condition in concurrent requests

# Bad
@oracle What does React useState do?    -> use librarian
@oracle Add a log statement             -> can't write, use primary
@oracle Fix this typo                   -> overkill, use primary
```

---

## librarian

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
- Architecture decisions (use oracle)

### Examples

```
# Good
@librarian How does Zustand implement store subscriptions?
@librarian Compare error handling in Zod vs Valibot
@librarian How does Next.js handle route caching?

# Bad
@librarian What files are in my src/?           -> local, use primary
@librarian Should I use Redux or Zustand?       -> use oracle for decisions
@librarian Add a new API endpoint               -> can't write
```

---

## code-reviewer

Focused code reviewer with temperature=0.1 for deterministic output.

### Use For
- Pre-commit review of significant changes
- Security-sensitive code (auth, crypto, input validation)
- Complex logic validation
- Pull request review assistance

### Don't Use For
- Architecture advice (use oracle)
- Style nitpicks (explicitly avoids zealotry)
- Pre-existing code that wasn't modified
- General advice (it finds bugs, not advises)

### Examples

```
# Good
@code-reviewer Check my auth changes for security issues
@code-reviewer Review this payment processing logic
@code-reviewer Verify error handling in API endpoints

# Bad
@code-reviewer Is this the right architectural approach?   -> use oracle
@code-reviewer Fix these bugs                              -> identifies only, can't fix
@code-reviewer Should I use class or function components?  -> use oracle
```

---

## opencode-expert

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
@opencode-expert Review my React component      -> use code-reviewer
@opencode-expert How does Express routing work? -> use librarian
@opencode-expert Plan my API architecture       -> use oracle
```

---

## overseer

Task management specialist for multi-session work and project coordination.

### Use For
- Creating milestones and subtasks
- Converting plans/specs to task hierarchies
- Finding next ready work
- Recording learnings
- Tracking project progress

### Don't Use For
- Single-session simple tasks
- Code review (use code-reviewer)
- Architecture decisions (use oracle)
- Library research (use librarian)

### Examples

```
# Good
@overseer Create milestone for auth system with subtasks
@overseer What's the next ready task?
@overseer Add learning about rate limiting to current task

# Bad
@overseer Review this code                  -> use code-reviewer
@overseer How does Next.js routing work?    -> use librarian
@overseer Plan API architecture             -> use oracle
```

---

## Decision Flow

```
Need deep reasoning/planning?     -> oracle
Need library internals?           -> librarian
Need bug/security review?         -> code-reviewer
Need task/milestone management?   -> overseer
Need OpenCode help?               -> opencode-expert
Everything else                   -> Primary agent
```

---

## Complementary Patterns

| Pattern | Flow |
|---------|------|
| Research then decide | librarian (how does X work?) -> oracle (should we use X?) |
| Plan, implement, verify | oracle (plan) -> Primary (implement) -> code-reviewer (verify) |
| Learn then apply | opencode-expert (config syntax) -> Primary (apply config) |

### Overseer Integration

Overseer is the "memory" layer. Other agents are stateless advisors. Use Overseer to persist decisions/learnings.

| Pattern | Flow | When |
|---------|------|------|
| Plan → Track → Build | oracle (design) -> overseer (create tasks) -> Primary (implement each) | Large features needing structure |
| Research → Decide → Track | librarian (how does X?) -> oracle (pick approach) -> overseer (task breakdown) | Unfamiliar domain/library |
| Build → Review → Learn | Primary (implement) -> code-reviewer (verify) -> overseer (record learning) | Tricky implementation worth remembering |
| Session handoff | overseer (update progress) -> [end] -> overseer (what's next?) -> Primary (continue) | Multi-session work |
| Blocked work | overseer (find ready) -> Primary (implement unblocked) -> overseer (unblock dependents) | Complex dependencies |

**Examples:**

```
# Large feature
@oracle Design auth system with JWT refresh tokens
@overseer Convert this plan to milestone with subtasks
@overseer What's the next ready task?
[implement]
@code-reviewer Check token validation logic
@overseer Complete current task, add learning about jose library

# Research-driven
@librarian How does Stripe handle webhook verification?
@oracle Should we use their SDK or raw crypto?
@overseer Create tasks for payment webhook implementation

# Session resume
@overseer What tasks are in progress or ready?
[continue work]
@overseer Mark login-flow task complete with result "uses PKCE"
```

---

## Configuration Reference

Agents are markdown files with YAML frontmatter in `agent/`:

```yaml
---
# Required
description: One-line description for @ autocomplete

# Mode (default: "all" for custom agents)
mode: subagent | primary | all

# Model override (optional)
model: provider/model-id  # e.g., anthropic/claude-sonnet-4-5

# Sampling parameters (optional)
temperature: 0.1
top_p: 0.9

# Iteration limit (optional)
steps: 10  # max agentic iterations before forcing text-only

# UI customization (optional)
color: "#FF5733"  # hex color for agent
hidden: false     # hide from @ menu (subagent only)

# Disable built-in agent (optional)
disable: true

# Extended thinking (optional, provider-specific)
options:
  thinking:
    type: enabled
    budgetTokens: 31999  # max for Anthropic models

# Permissions (replaces deprecated 'tools' field)
permission:
  "*": deny | allow | ask
  read: allow
  grep: allow
  glob: allow
  lsp: allow
  webfetch: allow
  bash:
    "git *": allow
    "*": deny
  edit: deny
  external_directory:
    "/tmp/*": allow
    "*": deny
---

System prompt content...
```

### Agent Modes

| Mode | Description |
|------|-------------|
| `subagent` | Invoked by primary via `@agent-name`. Cannot be selected as main. |
| `primary` | Can be selected as main working agent. |
| `all` | Available in both contexts. Default for custom agents. |

### Permission Categories

| Category | Description |
|----------|-------------|
| `read`, `grep`, `glob`, `lsp` | Read operations |
| `edit`, `write`, `patch`, `multiedit` | Write operations |
| `bash` | Shell commands (supports pattern matching) |
| `task` | Task/subagent tool |
| `external_directory` | Access outside project |
| `todowrite`, `todoread` | Todo management |
| `websearch`, `codesearch` | Search tools |

### Invocation

Subagents:
```
@agent-name Your prompt here
```

Primary agents:
- TUI: `<leader>a` to list agents
- CLI: `opencode --agent agent-name`
- Config: `default_agent: "agent-name"`

Primary agent invokes subagent, passes context, receives final message.
