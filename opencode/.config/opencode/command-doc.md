# OpenCode Commands Guide

## Overview

| Command | Category | Purpose |
|---------|----------|---------|
| **session-export** | Git/PR | Add AI session summary to PR/MR description |
| **code-review** | Git/PR | Review changes with 3 parallel @code-review subagents |
| **prd** | Planning | Create PRD for a feature |
| **prd-task** | Planning | Convert PRD markdown to executable JSON |
| **complete-next-task** | Planning | Implement next incomplete PRD task |
| **index-knowledge** | Documentation | Generate hierarchical AGENTS.md for codebase |
| **opensrc** | Documentation | Clone repo + generate AGENTS.md |
| **build-skill** | Development | Create or update agent skills |
| **frontend-design** | Development | Build production-grade frontend (React/Tailwind/shadcn/Motion) |
| **agent-browser** | Automation | Automate browser tasks (scraping, forms, interaction) |
| **pcompact-toggle** | Session | Toggle preemptive compaction on/off |
| **pcompact-status** | Session | Check compaction status (threshold, cooldown) |

Commands invoked with `/command-name [args]`

---

## session-export

Add AI session summary to GitHub PR or GitLab MR description.

### Use For
- Documenting AI assistance in pull requests
- Creating session summaries for code review context
- Preserving conversation history in PR descriptions

### Don't Use For
- Local commits without PRs
- Non-GitHub/GitLab workflows
- Replacing commit messages

### Examples

```
# Good
/session-export                     # Export to current branch's PR
/session-export #42                 # Export to specific PR number
/session-export !15                 # Export to GitLab MR
/session-export After refactoring auth module with AI assistance

# Bad
/session-export                     # No PR exists yet
                                    -> Create PR first, then export

/session-export                     # For a one-line typo fix
                                    -> Skip, not worth documenting

/session-export Write commit msg    # Wrong tool
                                    -> Just ask primary agent to commit
```

---

## code-review

Review changes with 3 parallel @code-review subagents, correlating results by severity.

### Use For
- Pre-commit review of significant changes
- Security-sensitive code (auth, crypto, validation)
- Complex logic before merging
- PR review assistance

### Don't Use For
- Style nitpicks (explicitly avoided)
- Simple typo fixes
- Pre-existing code not in diff
- Architecture decisions

### Examples

```
# Good
/code-review                                    # Review uncommitted changes
/code-review Focus on auth flow                 # Guided review
/code-review #123                               # Review PR by number
/code-review github.com/org/repo/pull/123      # Review by URL
/code-review Check error handling in API layer

# Bad
/code-review Fix this bug                       # Reviews only, doesn't fix
                                                -> Ask primary agent to fix

/code-review Should I refactor this?            # Architectural question
                                                -> @oracle Should I refactor...

/code-review Review entire codebase             # Too broad, not a diff
                                                -> /code-review on specific changes

/code-review Check my indentation               # Style nitpick
                                                -> Run linter/formatter instead
```

---

## prd

Create a Product Requirements Document defining the end state of a feature.

### Use For
- Planning new features before implementation
- Documenting migration or refactor scope
- Establishing acceptance criteria
- Creating task breakdown for complex work

### Don't Use For
- Quick bug fixes
- Small, obvious changes
- Already-implemented features
- Code documentation

### Examples

```
# Good
/prd User favorites feature
/prd API rate limiting system
/prd Migrate from REST to GraphQL
/prd Dark mode with system preference detection
/prd Multi-tenant workspace isolation

# Bad
/prd Fix null pointer exception              # Too small
                                             -> Just fix it directly

/prd Add a button                            # Trivial
                                             -> Ask primary agent

/prd How does authentication work?           # Research question
                                             -> @librarian How does auth work in [lib]?

/prd Document the API                        # Wrong deliverable
                                             -> /index-knowledge or write docs directly
```

---

## prd-task

Convert existing PRD markdown to executable JSON for autonomous task completion.

### Use For
- Making PRDs machine-executable
- Enabling `/complete-next-task` workflow
- Tracking task completion state

### Don't Use For
- Creating PRDs (use `/prd` first)
- Manual implementation
- PRDs without clear task breakdown

### Examples

```
# Good
/prd-task favorites                 # Converts prd-favorites.md
/prd-task api-ratelimit             # After PRD is finalized
/prd-task dark-mode                 # Ready for autonomous execution
/prd-task multi-tenant

# Bad
/prd-task                           # No PRD name specified
                                    -> /prd-task <prd-name>

/prd-task new-feature               # PRD doesn't exist yet
                                    -> /prd new-feature first

/prd-task vague-idea                # PRD lacks concrete tasks
                                    -> Refine PRD with clear acceptance criteria

/prd-task Build the feature         # Not a PRD name
                                    -> /prd-task <existing-prd-name>
```

---

## complete-next-task

Complete the next incomplete task from a PRD. Implements, runs feedback loops, commits.

### Use For
- Autonomous task execution from PRDs
- Incremental feature implementation
- Maintaining progress across sessions
- Resuming work after breaks

### Don't Use For
- Work without a PRD
- Non-sequential task completion
- Skipping verification steps

### Examples

```
# Good
/complete-next-task favorites       # Complete next task in favorites PRD
/complete-next-task api-ratelimit   # Continue where you left off
/complete-next-task dark-mode       # Resume after session break
/complete-next-task multi-tenant    # Incremental progress

# Bad
/complete-next-task                 # No PRD specified
                                    -> /complete-next-task <prd-name>

/complete-next-task nonexistent     # PRD doesn't exist
                                    -> /prd <feature> then /prd-task <feature> first

/complete-next-task skip to task 5  # Non-sequential
                                    -> Complete tasks in order, or manually mark earlier as done

/complete-next-task Build feature   # Not how it works
                                    -> /prd -> /prd-task -> /complete-next-task <name>
```

---

## index-knowledge

Generate hierarchical AGENTS.md knowledge base for the current codebase.

### Use For
- Onboarding AI to new codebases
- Creating agent context documentation
- Updating docs after major refactors
- Adding complexity scores for subdirectories

### Don't Use For
- User-facing documentation
- API documentation
- README files
- Changelogs

### Examples

```
# Good
/index-knowledge                    # Generate for current codebase
/index-knowledge update             # Refresh after restructuring
/index-knowledge src/               # Focus on specific directory
/index-knowledge                    # Before starting major work

# Bad
/index-knowledge                    # On empty/trivial projects
                                    -> Not needed for small projects

/index-knowledge Write user docs    # Wrong purpose
                                    -> Ask primary agent to write README

/index-knowledge Generate API docs  # Wrong tool
                                    -> Use typedoc/jsdoc/swagger

/index-knowledge for external repo  # Not cloned locally
                                    -> /opensrc <repo> instead
```

---

## opensrc

Clone a repository and generate AGENTS.md knowledge base.

### Use For
- Quick codebase exploration setup
- Creating AI-ready analysis of OSS projects
- Studying open-source implementations
- Understanding library internals

### Don't Use For
- Local repositories
- Already-cloned repos
- Private repos without access

### Examples

```
# Good
/opensrc vercel/ai
/opensrc facebook/react
/opensrc github.com/anthropics/sdk
/opensrc tailwindlabs/tailwindcss
/opensrc drizzle-team/drizzle-orm

# Bad
/opensrc ./local-project            # Already local
                                    -> /index-knowledge for local repos

/opensrc private/repo               # No access
                                    -> Clone manually with credentials first

/opensrc react                      # Ambiguous
                                    -> /opensrc facebook/react (full path)

/opensrc How does Zustand work?     # Research question
                                    -> @librarian How does Zustand work?
```

---

## build-skill

Create or update agent skills following the skill format.

### Use For
- Creating reusable agent capabilities
- Packaging domain knowledge
- Building skill libraries
- Updating existing skills

### Don't Use For
- One-off prompts
- Simple commands (use command files)
- Agent definitions (use agent files)

### Examples

```
# Good
/build-skill Create a kubernetes deployment skill
/build-skill Update the frontend-design skill
/build-skill Review my skill for issues
/build-skill Create a database migration skill
/build-skill Build a testing best-practices skill

# Bad
/build-skill Write code for me                  # Not a skill request
                                                -> Just ask primary agent

/build-skill Create an agent                    # Wrong abstraction
                                                -> Create agent file in agent/ directory

/build-skill Add a /deploy command              # Simple command
                                                -> Create command file in command/

/build-skill How do skills work?                # Documentation question
                                                -> @opencode-expert How do skills work?
```

---

## frontend-design

Create production-grade frontend interfaces with React, Tailwind CSS v4, shadcn/ui, and Motion.

### Use For
- Building UI components and pages
- Creating distinctive, non-generic interfaces
- Full-stack React applications
- Design system implementation

### Don't Use For
- Backend-only work
- Non-React frameworks
- Simple HTML/CSS pages
- Design mockups

### Examples

```
# Good
/frontend-design Dashboard with analytics cards
/frontend-design Auth flow with social login
/frontend-design Settings page with form validation
/frontend-design Data table with sorting, filtering, pagination
/frontend-design Landing page with hero and feature sections

# Bad
/frontend-design Build an API                   # Backend work
                                                -> Ask primary agent for API

/frontend-design Create Vue component           # Wrong framework
                                                -> Ask primary agent (not specialized)

/frontend-design Design wireframes              # It implements, doesn't design
                                                -> Use Figma/design tool first

/frontend-design Simple HTML page               # Overkill
                                                -> Ask primary agent for basic HTML
```

---

## agent-browser

Automate browser tasks using Playwright-based CLI.

### Use For
- Web scraping with interaction
- Form filling and submission
- Testing user flows
- Extracting data from dynamic sites

### Don't Use For
- Static API calls
- Simple HTTP requests
- PDF generation
- Non-browser automation

### Examples

```
# Good
/agent-browser Scrape product prices from [url]
/agent-browser Fill out job application form at [url]
/agent-browser Take screenshots of competitor pages
/agent-browser Extract table data after login
/agent-browser Test checkout flow on staging

# Bad
/agent-browser Call REST API                    # No browser needed
                                                -> Use fetch/curl directly

/agent-browser Download JSON from endpoint      # Static resource
                                                -> curl or fetch tool

/agent-browser Generate PDF                     # Wrong tool
                                                -> Use puppeteer/playwright directly for PDF

/agent-browser Read local HTML file             # Not a browser task
                                                -> Read tool for local files
```

---

## pcompact-toggle

Toggle preemptive compaction on/off. Prevents context overflow at 80% capacity.

### Use For
- Enabling auto-summarization for long sessions
- Disabling when you need full context retention
- Managing context-heavy workflows

### Don't Use For
- Manual summarization
- Checking status
- One-off compaction

### Examples

```
# Good
/pcompact-toggle                    # Toggle current state
/pcompact-toggle on                 # Enable before long session
/pcompact-toggle off                # Disable for context-sensitive work
/pcompact-toggle on                 # Before large refactor session

# Bad
/pcompact-toggle check              # Wrong command
                                    -> /pcompact-status

/pcompact-toggle                    # Just to see what happens
                                    -> /pcompact-status to check first

/pcompact-toggle summarize now      # Manual compaction
                                    -> /compact for immediate summarization

/pcompact-toggle 50%                # Can't set threshold
                                    -> Threshold is fixed at 80%
```

---

## pcompact-status

Check preemptive compaction status and settings.

### Use For
- Checking if compaction is enabled
- Viewing threshold settings (80%)
- Monitoring active compactions
- Debugging context issues

### Don't Use For
- Changing settings
- Manual compaction
- Context inspection

### Examples

```
# Good
/pcompact-status                    # View current state
/pcompact-status                    # Debug why session was summarized
/pcompact-status                    # Check before long task
/pcompact-status                    # Monitor during heavy session

# Bad
/pcompact-status on                 # Wrong command
                                    -> /pcompact-toggle on

/pcompact-status enable             # Wrong command
                                    -> /pcompact-toggle on

/pcompact-status compact now        # Wrong command
                                    -> /compact

/pcompact-status show context       # Wrong tool
                                    -> Check context usage in UI
```

---

## Decision Flow

```
Planning new work?
|- Complex feature?          -> /prd then /prd-task
|- Continue existing PRD?    -> /complete-next-task
|- Quick task?               -> Primary agent

Building UI?                 -> /frontend-design
Reviewing code?              -> /code-review
Documenting codebase?        -> /index-knowledge
Exploring OSS?               -> /opensrc

Browser automation?          -> /agent-browser
Creating skills?             -> /build-skill
Exporting session?           -> /session-export

Context management?
|- Check status?             -> /pcompact-status
|- Toggle auto-compact?      -> /pcompact-toggle
```

---

## Complementary Patterns

| Pattern | Flow |
|---------|------|
| Feature development | `/prd` -> `/prd-task` -> `/complete-next-task` (repeat) -> `/code-review` |
| Codebase onboarding | `/opensrc <repo>` (remote) or `/index-knowledge` (local) |
| PR workflow | Implement -> `/code-review` -> Fix issues -> `/session-export` |
| Long sessions | `/pcompact-toggle on` -> Work -> `/pcompact-status` (monitor) |
| UI implementation | `/frontend-design` -> Iterate -> `/code-review` |
| Skill development | `/build-skill` -> Test -> Refine |

---

## Configuration Reference

Commands are markdown files with YAML frontmatter in `command/`:

```yaml
---
description: One-line description shown in /help
agent: plan                        # optional: use plan mode
---

Command prompt content...

$ARGUMENTS                         # User input placeholder
```

### Locations

```
~/.config/opencode/command/       # Global commands
.opencode/command/                # Project commands
```

### Invocation

```
/command-name [arguments]
```

### Special Variables

| Variable | Description |
|----------|-------------|
| `$ARGUMENTS` | User input after command name |
| `$FILE{path}` | Embed file contents |
