# OpenCode Skills Guide

## Overview

| Skill               | Purpose                                               |
| ------------------- | ----------------------------------------------------- |
| **vcs-detect**      | Detect jj vs git before VCS commands                  |
| **overseer**        | Manage tasks via Overseer MCP for multi-session work  |
| **overseer-plan**   | Convert markdown plans to Overseer task hierarchies   |
| **index-knowledge** | Generate hierarchical AGENTS.md knowledge base        |
| **librarian**       | Multi-repo exploration (GitHub/npm/PyPI/crates)       |
| **frontend-design** | Tailwind v4 + shadcn/ui + Motion design system        |
| **build-skill**     | Create/validate OpenCode skills                       |
| **agent-browser**   | Playwright-based browser automation CLI               |
| **cloudflare**      | Cloudflare platform (Workers, Pages, D1, R2, AI, IaC) |

All skills are **loaded on demand** - invoke via `/skill <name>`.

---

## vcs-detect

Detect version control system before any VCS command.

### Use For

- Before any git/jj operation
- Colocated repos (both `.jj/` and `.git/`)
- CI scripts needing correct VCS

### Don't Use For

- Non-VCS operations
- Known VCS context

### Examples

```
# Good
/skill vcs-detect                        # before commit
/skill vcs-detect                        # before push
/skill vcs-detect                        # in CI script
/skill vcs-detect                        # colocated repo check

# Bad
git commit -m "msg"                      -> vcs-detect first, may be jj
git push origin main                     -> vcs-detect first
assume git in unknown repo               -> vcs-detect first
jj commands in git-only repo             -> vcs-detect first
```

---

## overseer

Manage tasks via Overseer MCP codemode. Persistent task tracking with rich context.

### Use For

- Multi-session work tracking
- Breaking down complex implementations
- Context persistence for handoffs
- Recording decisions for future reference

### Don't Use For

- Single atomic actions
- Work fitting in one message exchange
- When TodoWrite is sufficient

### Key Concepts

- **Tickets, not todos**: Tasks have description + context + result
- **3-level hierarchy**: Milestone → Task → Subtask
- **VCS integration**: `start()` creates bookmark, `complete()` squashes commits

### Examples

```
# Good
/skill overseer                          # start multi-session feature
/skill overseer                          # break down complex work
/skill overseer                          # handoff context to another session
/skill overseer                          # track decisions across sessions

# Bad
/skill overseer for quick fix            -> just do it, no tracking needed
/skill overseer for single file change   -> TodoWrite sufficient
/skill overseer without breakdown        -> overhead exceeds value
```

---

## overseer-plan

Convert markdown planning documents to Overseer task hierarchies.

### Use For

- After completing a plan in plan mode
- Converting specs/design docs to tasks
- Creating tasks from roadmap documents

### Don't Use For

- Documents that are incomplete/exploratory
- Non-actionable content
- Without meaningful planning content

### Examples

```
# Good
/skill overseer-plan plan-auth.md
/skill overseer-plan spec-api-v2.md --priority 2
/skill overseer-plan roadmap.md --parent <task-id>

# Bad
/skill overseer-plan (no markdown file)  -> need existing plan first
/skill overseer-plan rough-notes.md      -> too exploratory
/skill overseer-plan todo.txt            -> not structured planning doc
```

---

## index-knowledge

Generate hierarchical AGENTS.md knowledge base.

### Use For

- New projects
- Onboarding contributors
- After major restructuring

### Don't Use For

- Tiny projects (<10 files)
- Well-documented codebases

### Examples

```
# Good
/skill index-knowledge                   # update existing
/skill index-knowledge --create-new      # full regeneration
/skill index-knowledge --max-depth=3     # limit depth
/skill index-knowledge for monorepo
/skill index-knowledge after restructure

# Bad
/skill index-knowledge on 5-file project     -> overkill, manual README
/skill index-knowledge for single module     -> too small
/skill index-knowledge (already documented)  -> update only if stale
/skill index-knowledge to understand code    -> just read it
```

---

## librarian

Multi-repository explorer for remote sources.

### Use For

- Understanding library internals
- Finding patterns in OSS
- Comparing implementations

### Don't Use For

- Local project files
- Making changes (read-only)

### Examples

```
# Good
/skill librarian how does Zustand implement subscriptions?
/skill librarian compare Zod vs Valibot error handling
/skill librarian how does Next.js handle route caching?
/skill librarian find React error boundary patterns
/skill librarian explore tanstack-query internals

# Bad
/skill librarian what's in my src/?          -> primary agent (local)
/skill librarian read my package.json        -> Read tool (local)
/skill librarian add feature to my code      -> primary agent (read-only)
/skill librarian should I use Redux?         -> @oracle (decision)
/skill librarian review my component         -> @review (local code)
```

---

## frontend-design

Create distinctive, production-grade interfaces.

### Use For

- React UI components
- Tailwind v4 styling
- shadcn/ui integration
- Motion animations

### Don't Use For

- Backend code
- Non-React frameworks

### Examples

```
# Good
/skill frontend-design create hero with bold typography
/skill frontend-design build dashboard with shadcn
/skill frontend-design add Motion animations to cards
/skill frontend-design style form with Tailwind v4
/skill frontend-design create dark mode toggle

# Bad
/skill frontend-design write API endpoint        -> primary agent (backend)
/skill frontend-design setup Express server      -> primary agent (backend)
/skill frontend-design build Vue component       -> primary agent (not React)
```

---

## build-skill

Create and validate OpenCode skills.

### Use For

- Creating new skills
- Reviewing skill structure
- Debugging skill loading

### Don't Use For

- Using existing skills
- General markdown

### Examples

```
# Good
/skill build-skill create skill for code review
/skill build-skill scaffold deployment-checklist skill
/skill build-skill validate my-custom-skill
/skill build-skill debug why skill not loading
/skill build-skill add references to existing skill

# Bad
/skill build-skill use librarian             -> just /skill librarian
/skill build-skill run overseer              -> just /skill overseer
/skill build-skill write README              -> primary agent
/skill build-skill create markdown doc       -> primary agent (not a skill)
```

---

## agent-browser

Browser automation CLI using Playwright.

### Use For

- Web scraping
- Form filling
- Login flows
- Screenshot capture

### Don't Use For

- Static file reading
- API calls

### Examples

```
# Good
/skill agent-browser login to dashboard
/skill agent-browser fill out contact form
/skill agent-browser scrape product prices
/skill agent-browser take screenshot of homepage
/skill agent-browser test checkout flow

# Bad
/skill agent-browser read local file         -> Read tool
/skill agent-browser call REST API           -> Bash curl / fetch
/skill agent-browser parse JSON              -> primary agent
/skill agent-browser run tests               -> Bash (test runner)
/skill agent-browser analyze code            -> primary agent / @review
```

---

## Cloudflare

Comprehensive Cloudflare platform skill. Decision trees + detailed references.

### Use For

- Workers (serverless edge functions)
- Pages (full-stack web apps)
- Storage (KV, D1, R2, Queues)
- AI (Workers AI, Vectorize, Agents SDK)
- Networking (Tunnel, Spectrum)
- Security (WAF, DDoS, Turnstile)
- Infrastructure-as-code (Terraform, Pulumi)

### Don't Use For

- Non-Cloudflare platforms
- General web development (use frontend-design)

### Key Decision Trees

```
Run code?     → Workers, Pages, Durable Objects, Workflows
Store data?   → KV, D1, R2, Queues, Vectorize
Need AI?      → Workers AI, Vectorize, Agents SDK
Networking?   → Tunnel, Spectrum, TURN
Security?     → WAF, DDoS, Bot Management, Turnstile
IaC?          → Pulumi, Terraform, API
```

### Examples

```
# Good
/skill cloudflare setup Workers project
/skill cloudflare configure D1 database
/skill cloudflare deploy to Pages
/skill cloudflare add KV storage binding
/skill cloudflare implement Durable Objects

# Bad
/skill cloudflare deploy to Vercel         -> not Cloudflare
/skill cloudflare setup AWS Lambda         -> not Cloudflare
/skill cloudflare React component          -> frontend-design
```

---

## Decision Flow

```
VCS operation?           -> vcs-detect
Multi-session work?      -> overseer
Convert plan to tasks?   -> overseer-plan
Generate docs?           -> index-knowledge
Research libs?           -> librarian
Build React UI?          -> frontend-design
Create skill?            -> build-skill
Web automation?          -> agent-browser
Cloudflare platform?     -> cloudflare
```

---

## Complementary Patterns

| Pattern | Flow |
|---------|------|
| **Feature planning** | plan mode → overseer-plan → overseer → implement |
| **UI development** | frontend-design → implement → @oracle review |
| **Library research** | librarian → understand → implement |
| **VCS workflow** | vcs-detect → git/jj commands |
| **Cloudflare deploy** | cloudflare → configure → deploy |
| **Codebase onboarding** | index-knowledge → librarian (deps) → understand |
| **Edge-rendered UI** | frontend-design → cloudflare (Pages) → deploy |
| **Scraping pipeline** | agent-browser → extract → process/store |
| **Skill authoring** | librarian (research patterns) → build-skill → iterate |
| **Complex feature** | librarian (unknown libs) → overseer → frontend-design → implement |
| **New project bootstrap** | vcs-detect → index-knowledge → establish conventions |
| **Cloudflare full-stack** | cloudflare (D1/KV) + frontend-design → Pages deploy |
| **Multi-session handoff** | overseer (context) → new session → overseer (resume) |
| **PRD task loop** | create PRD → `/complete-next-task <prd>` → repeat until done |

---

## Configuration Reference

Skills are markdown files with YAML frontmatter in `skills/<name>/`:

```yaml
---
name: skill-name
description: One-line description for discovery
references:
  - references/file.md
---
Content...
```

### Skill Locations

| Priority | Location                                     |
| -------- | -------------------------------------------- |
| 1        | `.opencode/skills/<name>/` (project)         |
| 2        | `~/.config/opencode/skills/<name>/` (global) |

### Structure

```
skills/<name>/
├── SKILL.md           # Required
├── references/        # Optional - detailed docs
├── scripts/           # Optional - automation
└── assets/            # Optional - static files
```

### Invocation

```
/skill skill-name
```
