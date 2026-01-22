# OpenCode Skills Guide

## Overview

| Skill | Purpose |
|-------|---------|
| **vcs-detect** | Detect jj vs git before VCS commands |
| **prd** | Create RFC-ready Product Requirements Documents |
| **prd-task** | Convert PRDs to executable JSON for autonomous tasks |
| **session-export** | Export AI session summary to PR/MR descriptions |
| **index-knowledge** | Generate hierarchical AGENTS.md knowledge base |
| **librarian** | Multi-repo exploration (GitHub/npm/PyPI/crates) |
| **frontend-design** | Tailwind v4 + shadcn/ui + Motion design system |
| **build-skill** | Create/validate OpenCode skills |
| **agent-browser** | Playwright-based browser automation CLI |
| **web-design-guidelines** | Review UI against Vercel's Web Interface Guidelines |
| **react-best-practices** | Vercel's React/Next.js optimization rules |

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

## prd

Create RFC-quality Product Requirements Documents.

### Use For
- New feature planning
- Major refactors
- Migration planning

### Don't Use For
- Bug fixes
- Simple changes (<1 day)

### Examples
```
# Good
/skill prd create PRD for user authentication
/skill prd plan API v2 migration
/skill prd design notification system
/skill prd refactor payment processing
/skill prd multi-tenant architecture

# Bad
/skill prd fix null pointer bug          -> just fix it directly
/skill prd add logging statement         -> too small, just do it
/skill prd update README                 -> no PRD needed
/skill prd rename variable               -> primary agent
/skill prd how does zustand work?        -> librarian
```

---

## prd-task

Convert markdown PRD to executable JSON.

### Use For
- After creating PRD
- Starting autonomous completion
- Breaking PRD into verifiable steps

### Don't Use For
- Without existing PRD
- Simple todos

### Examples
```
# Good
/skill prd-task convert prd-auth.md
/skill prd-task convert prd-notifications.md
/skill prd-task generate tasks from prd-payments.md
/skill prd-task break down prd-api-v2.md

# Bad
/skill prd-task plan auth feature         -> prd first, then prd-task
/skill prd-task create task list          -> prd first
/skill prd-task without existing PRD      -> prd first
/skill prd-task fix bug                   -> no PRD needed, just fix
/skill prd-task add simple feature        -> prd if >1 day work
```

---

## session-export

Update PR/MR descriptions with AI session summary.

### Use For
- After completing PR work
- Documenting AI assistance
- Team transparency

### Don't Use For
- PRs without AI help
- Sessions with secrets

### Examples
```
# Good
/skill session-export add to PR #42
/skill session-export update MR !15
/skill session-export document this session
/skill session-export append summary to PR

# Bad
/skill session-export (session has API keys)     -> never include secrets
/skill session-export (discussed passwords)      -> redact first
/skill session-export for manual PR              -> only AI-assisted PRs
/skill session-export (no changes made)          -> nothing to document
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
/skill frontend-design optimize bundle           -> react-best-practices
/skill frontend-design build Vue component       -> primary agent (not React)
/skill frontend-design review accessibility      -> web-design-guidelines
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
/skill build-skill run prd                   -> just /skill prd
/skill build-skill write README              -> primary agent
/skill build-skill explain skill system      -> @opencode-expert
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

## web-design-guidelines

Review UI against Vercel's Web Interface Guidelines.

### Use For
- UI code review
- Accessibility audits
- UX compliance

### Don't Use For
- Backend code
- Performance (use react-best-practices)

### Examples
```
# Good
/skill web-design-guidelines review Button.tsx
/skill web-design-guidelines audit Modal component
/skill web-design-guidelines check form accessibility
/skill web-design-guidelines review navigation UX
/skill web-design-guidelines check src/components/

# Bad
/skill web-design-guidelines review api/route.ts     -> not UI, skip
/skill web-design-guidelines check database schema   -> not UI
/skill web-design-guidelines optimize re-renders     -> react-best-practices
/skill web-design-guidelines review bundle size      -> react-best-practices
/skill web-design-guidelines plan architecture       -> @oracle
```

---

## react-best-practices

Vercel's React/Next.js performance rules. 45 rules, 8 categories.

### Use For
- React optimization
- Next.js perf tuning
- Bundle reduction
- Re-render fixes

### Don't Use For
- Non-React code
- Design/styling (use web-design-guidelines)

### Examples
```
# Good
/skill react-best-practices review data fetching
/skill react-best-practices optimize Dashboard.tsx
/skill react-best-practices check bundle imports
/skill react-best-practices fix re-render issues
/skill react-best-practices audit async patterns

# Bad
/skill react-best-practices review CSS styling       -> web-design-guidelines
/skill react-best-practices check accessibility      -> web-design-guidelines
/skill react-best-practices review Python code       -> not React
/skill react-best-practices plan feature             -> @oracle / prd
/skill react-best-practices how does SWR work?       -> librarian
```

---

## Decision Flow

```
VCS operation?           -> vcs-detect
Planning feature?        -> prd -> prd-task
Document AI work?        -> session-export
Generate docs?           -> index-knowledge
Research libs?           -> librarian
Build React UI?          -> frontend-design
Create skill?            -> build-skill
Web automation?          -> agent-browser
Review UI?               -> web-design-guidelines
Optimize React?          -> react-best-practices
```

---

## Complementary Patterns

| Pattern | Flow |
|---------|------|
| Feature planning | prd → prd-task → implement → session-export |
| UI development | frontend-design → react-best-practices → web-design-guidelines |
| Library research | librarian → understand → implement |
| VCS workflow | vcs-detect → git/jj commands |

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

| Priority | Location |
|----------|----------|
| 1 | `.opencode/skills/<name>/` (project) |
| 2 | `~/.config/opencode/skills/<name>/` (global) |

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
