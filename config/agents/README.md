# Agentic Library

My collection of skills and slash commands for agentic coding, or kompis-kodning as I call it. Some I wrote myself; the rest come from the sources below.

## Sources

- [Matt Pocock's skills](https://github.com/mattpocock/skills) - the engineering-flow skills (`ask-matt`, `code-review`, `to-spec`, `to-tickets`, `triage`, `wayfinder`, `setup-matt-pocock-skills`)
- [Peter Yang's no-ai-slop](https://github.com/petergyang/no-ai-slop) - the `no-ai-slop` skill

Matt Pocock's skills have helped me a lot. Instead of one-shot prompting, they turn agentic coding into an actual workflow (triage, spec, tickets, implementation, review), which is what keeps code quality up when you're moving fast. Good pick for a serious software engineer who wants AI to speed up the work without cutting corners on quality.

Peter Yang's `no-ai-slop` catches the tells that give AI-written text away - throat-clearing openers, "it's not X, it's Y" contrasts, fake-profound kickers - and edits them out while keeping your actual voice. The result reads like you wrote it, not like a model smoothed it over.

## Layout

This repo is the single source of truth. Files live here once and get symlinked out to wherever each agent/tool expects to find them - `AGENTS.md` to `~/.claude/CLAUDE.md`, each folder under `skills/` to `~/.claude/skills/<name>`, and so on for other tools as they're added. Edit the source here, never the symlink target; the link just satisfies each tool's own naming and location conventions.

## AGENTS.md

The baseline instruction set every agent gets loaded with, regardless of task or tool: be concise, ask before ambiguous or hard-to-reverse changes, verify instead of guessing, never claim AI authorship in commits or docs, and so on. It's organized into sections:

- **Session Start** - startup habits (skill-check, session bookkeeping, re-stating constraints after compaction)
- **Response Style** - tone, formatting, what to skip
- **Uncertainty** - when to ask vs. proceed on an assumption
- **Evidence** - how much investigation a change warrants before touching code
- **Scope & Design** - YAGNI, reuse, dependency hygiene
- **Testing & Completion** - verification standards, when to call something done
- **Safety & Boundaries** - secrets, destructive commands, injection risks
- **Git & PRs** - commit and PR conventions

These are personal defaults that apply everywhere, not project rules - project-specific instructions belong in each project's own `CLAUDE.md`/`AGENTS.md`, which layers on top of this one.

## Skills

Each skill lives in its own folder under [`skills/`](./skills), with a `SKILL.md` describing what it does and when to use it.
