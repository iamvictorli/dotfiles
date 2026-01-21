# OpenCode Commands Guide

## Overview

| Command | Description | Use Case |
|---------|-------------|----------|
| **code-review** | Parallel code review with 3 subagents | Review uncommitted changes, commits, or PRs/MRs |
| **complete-next-task** | Execute next incomplete PRD task | Autonomous task completion from prd.json |
| **prd** | Create Product Requirements Document | Define feature end state before implementation |
| **prd-task** | Convert PRD to executable JSON | Transform markdown PRD for task automation |
| **frontend-design** | Build production-grade UI | React/Tailwind/shadcn/Motion interfaces |
| **index-knowledge** | Generate AGENTS.md hierarchy | Create codebase documentation for agents |
| **opensrc** | Clone + document external repo | Fetch repo and generate AGENTS.md knowledge |
| **build-skill** | Create/update agent skills | Define reusable SKILL.md files |
| **agent-browser** | Browser automation via Playwright | Scraping, form filling, web interaction |
| **session-export** | Export session to PR/MR | Add AI session summary to GitHub/GitLab |
| **pcompact-status** | Check compaction status | View preemptive compaction settings |
| **pcompact-toggle** | Toggle compaction on/off | Enable/disable automatic context management |

---

## PRD Workflow Commands

### prd

Create a Product Requirements Document defining feature end state.

#### Use For
- Planning new features before implementation
- Defining acceptance criteria upfront
- Migrations and refactors needing clear scope
- Complex features requiring structured breakdown

#### Don't Use For
- Quick bug fixes (just fix it)
- Exploratory prototypes (too rigid)
- Trivial changes (overhead > value)

#### Examples

```
# Good
/prd Add favorites system with offline sync
/prd Migrate auth from JWT to session cookies

# Bad
/prd Fix typo in README           -> just edit
/prd Experiment with new animation -> prototype first
```

---

### prd-task

Convert markdown PRD to executable JSON for autonomous task completion.

**Requires:** Existing PRD (e.g., `prd-favorites.md` → argument `favorites`)

#### Use For
- Automating PRD execution via `/complete-next-task`
- Breaking PRD into trackable tasks with pass/fail
- Enabling multi-session feature development

#### Don't Use For
- PRDs not yet finalized (convert when ready)
- Simple PRDs with 1-2 tasks (manual faster)

#### Examples

```
# Good
/prd-task favorites              -> converts prd-favorites.md
/prd-task auth-migration

# Bad
/prd-task                        -> needs PRD name
/prd-task prd-favorites.md       -> just the name, not filename
```

---

### complete-next-task

Execute next incomplete task from a PRD. Implements, tests, commits.

**State location:** `.opencode/state/<prd-name>/prd.json`

#### Use For
- Autonomous feature development
- Multi-session progress tracking
- Enforcing feedback loops (type check, test, lint)

#### Don't Use For
- Initial exploration (understand codebase first)
- Tasks requiring human decisions mid-implementation

#### Process
1. Reads progress.txt for context
2. Finds next `passes: false` task
3. Implements with feedback loops
4. Updates PRD and progress
5. Commits with VCS (auto-detects jj/git)

#### Examples

```
# Good
/complete-next-task favorites
/complete-next-task auth-migration

# Bad
/complete-next-task              -> needs PRD name
/complete-next-task ./prd.json   -> just the name
```

---

## Code Quality Commands

### code-review

Review code with 3 parallel @code-review subagents. Results ranked by severity.

**Agent:** Uses `plan` agent for orchestration.

#### Use For
- Pre-merge reviews of branches/PRs
- Security audits of sensitive changes
- Quality gates before release

#### Don't Use For
- WIP code (too early)
- Generated code (review source instead)

#### Behavior
- Uncommitted changes → reviews those
- No changes → reviews last commit
- PR/MR number provided → fetches and reviews

#### Examples

```
# Good
/code-review                     -> review uncommitted
/code-review focus on auth flow
/code-review #42                 -> review PR 42

# Bad
/code-review entire codebase     -> too broad, use guidance
```

---

## Frontend Commands

### frontend-design

Build distinctive UI with React, Tailwind CSS v4, shadcn/ui, Motion.

Loads `frontend-design` skill with patterns for avoiding generic AI aesthetics.

#### Use For
- Production-ready components/pages
- Consistent design system usage
- Accessible, animated interfaces

#### Don't Use For
- Backend-only features
- Quick prototypes not needing polish

#### Examples

```
# Good
/frontend-design Dashboard with real-time charts
/frontend-design Settings page with tabbed navigation

# Bad
/frontend-design Make it look nice    -> too vague
```

---

## Documentation Commands

### index-knowledge

Generate hierarchical AGENTS.md knowledge base for codebase.

Creates root + complexity-scored subdirectory documentation.

#### Use For
- New projects needing agent context
- After major refactors
- Onboarding agents to codebase

#### Don't Use For
- Trivial repos (single file)
- External repos (use `/opensrc` instead)

#### Examples

```
# Good
/index-knowledge
/index-knowledge focus on src/core/

# Bad
/index-knowledge node_modules/   -> don't index deps
```

---

### opensrc

Clone external repo and enhance with AGENTS.md documentation.

Combines `opensrc` fetch + `index-knowledge` generation.

#### Use For
- Understanding third-party library internals
- Creating documented local copies of dependencies
- Research into open source implementations

#### Don't Use For
- Repos you already have cloned
- Quick API lookups (use Librarian agent)

#### Examples

```
# Good
/opensrc vercel/ai
/opensrc github:facebook/react

# Bad
/opensrc                         -> needs repo
/opensrc ./local-project         -> use index-knowledge
```

---

## Skill & Automation Commands

### build-skill

Create or update SKILL.md files for reusable agent capabilities.

Loads `build-skill` skill with format, naming, validation rules.

#### Use For
- Creating new agent skills
- Standardizing repeated workflows
- Debugging existing skills

#### Don't Use For
- One-off tasks (no reuse value)
- Simple aliases (use commands instead)

#### Examples

```
# Good
/build-skill Create deployment skill
/build-skill Review my-skill for issues

# Bad
/build-skill                     -> needs task
```

---

### agent-browser

Browser automation using Playwright CLI.

#### Use For
- Web scraping with JS rendering
- Form filling and submission
- Testing web interactions
- Screenshots and PDFs

#### Don't Use For
- Static page fetching (use webfetch)
- API interactions (use curl/fetch)

#### Examples

```
# Good
/agent-browser Scrape pricing from example.com
/agent-browser Fill contact form with test data

# Bad
/agent-browser Download JSON API   -> use curl
```

---

### session-export

Add AI session summary to GitHub PR or GitLab MR description.

Uses `gh`/`glab` CLI to update PR/MR.

#### Use For
- Documenting AI assistance in PRs
- Creating audit trail of AI contributions
- Sharing session context with reviewers

#### Don't Use For
- PRs not yet created
- Repos without GitHub/GitLab

#### Examples

```
# Good
/session-export                  -> updates current PR
/session-export #42              -> updates PR 42

# Bad
/session-export to file          -> not file export
```

---

## Context Management Commands

### pcompact-status

Check preemptive compaction settings.

#### Shows
- Enabled/disabled state
- Trigger threshold (80%)
- Context limit
- Cooldown period
- Active compactions

#### Examples

```
/pcompact-status
```

---

### pcompact-toggle

Toggle preemptive compaction on/off.

Prevents context overflow by auto-summarizing at 80% capacity.

#### Usage

```
/pcompact-toggle        # Toggle current state
/pcompact-toggle on     # Enable
/pcompact-toggle off    # Disable
```

---

## Decision Flow

```
Planning a feature?
├─ Define requirements?        -> /prd
├─ Convert to tasks?           -> /prd-task
└─ Execute tasks?              -> /complete-next-task

Building UI?                   -> /frontend-design

Reviewing code?
├─ Local changes/commits?      -> /code-review
└─ PR/MR?                      -> /code-review #<number>

Documentation?
├─ Current codebase?           -> /index-knowledge
└─ External repo?              -> /opensrc

Automation?
├─ Reusable skill?             -> /build-skill
└─ Browser interaction?        -> /agent-browser

Session management?
├─ Export to PR/MR?            -> /session-export
├─ Check context?              -> /pcompact-status
└─ Toggle compaction?          -> /pcompact-toggle
```

---

## Complementary Patterns

| Workflow | Command Chain |
|----------|---------------|
| **Feature development** | `/prd` → `/prd-task` → `/complete-next-task` (repeat) |
| **External lib research** | `/opensrc` → read AGENTS.md → implement |
| **PR submission** | `/code-review` → fix issues → `/session-export` |
| **New skill creation** | `/build-skill` → test skill → `/build-skill` (iterate) |
| **Long sessions** | `/pcompact-toggle on` → work → `/pcompact-status` |

---

## Configuration Reference

Commands are markdown files with YAML frontmatter.

### Location
- **Global:** `~/.config/opencode/command/`
- **Project:** `.opencode/command/`

### Frontmatter Format

```yaml
---
description: Short description shown in command list
agent: optional-agent-name   # e.g., "plan" for orchestration
---
```

### Body Format

```markdown
Command instructions and context.

Variables:
- $ARGUMENTS - User input after command name
- $FILE{path} - Include file contents

<user-request>
$ARGUMENTS
</user-request>
```

### Example: Skill-Loading Command

```markdown
---
description: Create a PRD for a feature
---

First, invoke the skill tool:

\```
skill({ name: 'prd' })
\```

Then follow the skill instructions.

<user-request>
$ARGUMENTS
</user-request>
```

### Example: Direct Execution Command

```markdown
---
description: Check preemptive compaction status
---

Check if preemptive compaction is enabled.

Usage: /pcompact-status

$ARGUMENTS
```
