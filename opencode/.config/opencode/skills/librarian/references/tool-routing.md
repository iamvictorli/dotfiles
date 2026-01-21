# Tool Routing

## Decision Flowchart

```mermaid
graph TD
    Q[User Query] --> T{Query Type?}
    T -->|Understand/Explain| U[UNDERSTAND]
    T -->|Find/Search| F[FIND]
    T -->|Explore/Architecture| E[EXPLORE]
    T -->|Compare| C[COMPARE]
    
    U --> U1[opensrc.fetch]
    U1 --> U2[tree]
    U2 --> U3[read key files]
    U3 --> U4{Need examples?}
    U4 -->|Yes| U5[grep_app]
    
    F --> F1{Specific repo?}
    F1 -->|Yes| F2[opensrc.fetch]
    F2 --> F2a[grep]
    F2a --> F2b[read matches]
    F1 -->|No| F3[grep_app broad search]
    F3 --> F4[opensrc.fetch interesting repos]
    
    E --> E1[opensrc.fetch]
    E1 --> E2[opensrc.files]
    E2 --> E3[Read entry points]
    E3 --> E4[Create diagram]
    
    C --> C1["opensrc.fetch([X, Y])"]
    C1 --> C2[grep same pattern]
    C2 --> C3[Read comparable files]
    C3 --> C4[Synthesize comparison]
```

## Query Type Detection

| Keywords | Query Type | Start With |
|----------|------------|------------|
| "how does", "why does", "explain", "purpose of" | UNDERSTAND | opensrc |
| "find", "where is", "implementations of", "examples of" | FIND | grep_app |
| "explore", "walk through", "architecture", "structure" | EXPLORE | opensrc |
| "compare", "vs", "difference between" | COMPARE | opensrc |

## UNDERSTAND Queries

```
opensrc.fetch(lib) → tree → read key files
                              │
                              ▼
                   Need usage examples? → grep_app
```

**When to escalate to grep_app:**
- "How do people typically use..."
- "Best practices for..."
- "Common patterns with..."

## FIND Queries

```
Specific repo? → opensrc.fetch → opensrc.grep → read matches

Broad search?  → grep_app → analyze → opensrc.fetch interesting repos
```

**grep_app query tips:**
- Use literal code patterns: `useState(` not "react hooks"
- Filter by language: `language: ["TypeScript"]`
- Narrow by repo: `repo: "vercel/"` for org

## EXPLORE Queries

```
1. opensrc.fetch(target)
2. opensrc.files → understand structure
3. Identify entry points: README, package.json, src/index.*
4. Read entry → internals
5. Create architecture diagram
```

## COMPARE Queries

```
1. opensrc.fetch([X, Y])
2. Extract source.name from each result
3. opensrc.grep same pattern in both
4. Read comparable files
5. Synthesize → comparison table
```

## Tool Capabilities

| Tool | Best For | Not For |
|------|----------|---------|
| **grep_app** | Broad search, usage examples, finding repos | Semantic queries |
| **opensrc** | Deep exploration, reading internals, tracing flow | Initial discovery |

## Anti-patterns

| Don't | Do |
|-------|-----|
| grep_app before reading source | opensrc.fetch first for UNDERSTAND |
| opensrc.fetch before knowing target | grep_app to discover |
| Multiple small reads | opensrc.readMany batch |
| Describe without linking | Link every file ref |
| Text for complex relationships | Mermaid diagram |
| Use tool names in responses | "I'll search..." not "I'll use opensrc" |
