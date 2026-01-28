# OpenCode Commands Guide

## Overview

| Command | Category | Purpose |
|---------|----------|---------|
| **overseer** | Task Management | Manage tasks via Overseer MCP - create, list, start, complete |
| **overseer-plan** | Task Management | Convert markdown plan/spec to Overseer tasks |
| **code-review** | Git/PR | Review changes with 3 parallel @code-review subagents |
| **complete-next-task** | Planning | Implement next incomplete PRD task |
| **task-loop** | Planning | Run complete-next-task in loop until PRD complete (CLI) |
| **index-knowledge** | Documentation | Generate hierarchical AGENTS.md for codebase |
| **opensrc** | Documentation | Clone repo + generate AGENTS.md |
| **build-skill** | Development | Create or update agent skills |
| **frontend-design** | Development | Build production-grade frontend (React/Tailwind/shadcn/Motion) |
| **cloudflare** | Development | Load Cloudflare skill for Workers, D1, R2, etc. |
| **agent-browser** | Automation | Automate browser tasks (scraping, forms, interaction) |
| **pcompact-toggle** | Session | Toggle preemptive compaction on/off |
| **pcompact-status** | Session | Check compaction status (threshold, cooldown) |

Commands invoked with `/command-name [args]`

---

## overseer

Manage tasks via Overseer MCP - create, list, start, complete, find ready work.

### Use For
- Task orchestration and tracking
- Finding next ready work
- Recording learnings for tasks
- Creating task hierarchies with milestones

### Don't Use For
- Simple one-off requests
- Questions/research (use primary agent)
- Converting plans to tasks (use `/overseer-plan`)

### Examples

```
# Good
/overseer list                      # Show all tasks
/overseer next                      # Find next ready task
/overseer create "Implement auth"   # Create new task
/overseer start task-123            # Start working on task
/overseer complete task-123         # Mark task done
/overseer learn task-123 "Use jose for JWT"  # Add learning

# Bad
/overseer How do I use this?        # Research question
                                    -> Ask primary agent

/overseer Convert my plan           # Wrong command
                                    -> /overseer-plan <file>
```

---

## overseer-plan

Convert markdown planning documents into trackable Overseer task hierarchies.

### Use For
- Turning specs/plans into executable tasks
- Creating milestone + subtask structures
- Making plans trackable via Overseer

### Don't Use For
- Creating plans (write markdown first)
- Simple single tasks (use `/overseer create`)
- Managing existing tasks (use `/overseer`)

### Examples

```
# Good
/overseer-plan ./docs/auth-plan.md
/overseer-plan ./PRD.md --priority 1
/overseer-plan ./feature-spec.md --parent milestone-123

# Bad
/overseer-plan                      # No file specified
                                    -> /overseer-plan <path-to-file>

/overseer-plan Create auth feature  # Not a file path
                                    -> Write plan to .md file first

/overseer-plan list tasks           # Wrong command
                                    -> /overseer list
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
                                    -> Create PRD .md then /overseer-plan <file>

/complete-next-task skip to task 5  # Non-sequential
                                    -> Complete tasks in order, or manually mark earlier as done

/complete-next-task Build feature   # Not how it works
                                    -> Write plan.md -> /overseer-plan -> /complete-next-task
```

---

## task-loop

**CLI tool** (not a command) - runs `/complete-next-task` in a loop until PRD complete.

```bash
task-loop <feature> [--max-iterations=N]
```

Default: 25 iterations. Stops when `<tasks>COMPLETE</tasks>` marker detected.

### Use For
- Fully autonomous feature implementation
- Overnight/unattended PRD completion
- Batch processing multiple tasks without interaction
- Hands-off development workflows

### Don't Use For
- Interactive development (use `/complete-next-task`)
- PRDs requiring human decisions mid-task
- Exploratory/experimental work
- When you need to review each step

### Examples

```
# Good
task-loop favorites                      # Complete entire PRD autonomously
task-loop api-ratelimit --max-iterations=10   # Limit iterations
task-loop dark-mode &                    # Run in background
nohup task-loop multi-tenant > log.txt & # Unattended overnight

# Bad
task-loop                                # No feature specified
                                         -> task-loop <prd-name>

task-loop nonexistent                    # PRD doesn't exist
                                         -> Write plan.md then /overseer-plan first

task-loop favorites --interactive        # No such flag, it's non-interactive
                                         -> Use /complete-next-task for interactive

task-loop --dry-run favorites            # No dry-run support
                                         -> Review PRD tasks manually first
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

## cloudflare

Load Cloudflare platform skill for Workers, D1, R2, KV, Durable Objects, and more.

### Use For
- Workers/Pages development
- D1/R2/KV storage setup
- Durable Objects implementation
- Cloudflare API integration

### Don't Use For
- Generic backend development
- Non-Cloudflare platforms
- AWS/GCP/Azure work

### Examples

```
# Good
/cloudflare Deploy a Worker with KV bindings
/cloudflare Set up D1 database with migrations
/cloudflare Implement rate limiting with Durable Objects
/cloudflare Configure R2 bucket with public access
/cloudflare --update-skill                    # Update to latest skill version

# Bad
/cloudflare Deploy to AWS Lambda              # Wrong platform
                                              -> Ask primary agent

/cloudflare Set up Express server             # Not Cloudflare-specific
                                              -> Ask primary agent

/cloudflare What is Workers?                  # Documentation question
                                              -> @librarian or Cloudflare docs
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
|- Complex feature?          -> Write plan.md then /overseer-plan
|- Continue existing tasks?  -> /complete-next-task (interactive)
|- Autonomous completion?    -> task-loop <prd-name> (CLI)
|- Quick task?               -> Primary agent

Task management?
|- List/create/start tasks?  -> /overseer
|- Convert plan to tasks?    -> /overseer-plan

Building UI?                 -> /frontend-design
Cloudflare development?      -> /cloudflare
Reviewing code?              -> /code-review
Documenting codebase?        -> /index-knowledge
Exploring OSS?               -> /opensrc

Browser automation?          -> /agent-browser
Creating skills?             -> /build-skill

Context management?
|- Check status?             -> /pcompact-status
|- Toggle auto-compact?      -> /pcompact-toggle
```

---

## Complementary Patterns

| Pattern | Flow |
|---------|------|
| Feature development | Write plan.md -> `/overseer-plan` -> `/complete-next-task` (repeat) -> `/code-review` |
| Autonomous development | Write plan.md -> `/overseer-plan` -> `task-loop <name>` -> `/code-review` |
| Task tracking | `/overseer create` -> `/overseer start` -> Work -> `/overseer complete` |
| Codebase onboarding | `/opensrc <repo>` (remote) or `/index-knowledge` (local) |
| PR workflow | Implement -> `/code-review` -> Fix issues -> Merge |
| Long sessions | `/pcompact-toggle on` -> Work -> `/pcompact-status` (monitor) |
| UI implementation | `/frontend-design` -> Iterate -> `/code-review` |
| Cloudflare work | `/cloudflare` -> Implement -> `/code-review` |
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
