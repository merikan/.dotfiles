# Agentic Library

My collection of skills and slash commands for agentic coding, or kompis-kodning as I call it. Some I wrote myself; the rest come from the sources below.

## Sources

- [Matt Pocock's skills](https://github.com/mattpocock/skills) - the engineering-flow skills (`ask-matt`, `code-review`, `to-spec`, `to-tickets`, `triage`, `wayfinder`, `setup-matt-pocock-skills`)
- [Peter Yang's no-ai-slop](https://github.com/petergyang/no-ai-slop) - the `no-ai-slop` skill

Matt Pocock's skills have helped me a lot. Instead of one-shot prompting, they turn agentic coding into an actual workflow (triage, spec, tickets, implementation, review), which is what keeps code quality up when you're moving fast. Good pick for a serious software engineer who wants AI to speed up the work without cutting corners on quality.


Peter Yang's `no-ai-slop` catches the tells that give AI-written text away - throat-clearing openers, "it's not X, it's Y" contrasts, fake-profound kickers - and edits them out while keeping your actual voice. The result reads like you wrote it, not like a model smoothed it over.


## Layout

This repo is the single source of truth. Files live here once and get symlinked out to wherever each agent/tool expects to find them - `AGENTS.md` to `~/.claude/CLAUDE.md`, each folder under `skills/` to `~/.claude/skills/<name>`, and so on for other tools as they're added. Edit the source here, never the symlink target; the link just satisfies each tool's own naming and location conventions.

```bash
.
├── .agents -> /Users/peter/.config/agents
├── .config
│   ├── agents
│   │   ├── AGENTS.md -> /Users/peter/.dotfiles/config/agents/AGENTS.md
│   │   ├── README.md -> /Users/peter/.dotfiles/config/agents/README.md
│   │   └── skills -> /Users/peter/.dotfiles/config/agents/skills
│   ├── opencode
│   │   ├── .gitignore
│   │   ├── AGENTS.md -> /Users/peter/.dotfiles/config/agents/AGENTS.md
│   │   ├── opencode.json -> /Users/peter/.dotfiles/config/opencode/opencode.json
│   │   ├── plugins
│   │   └── skills
```

## Install and update skills

### Install

I am using [`npx skills`](https://www.npmjs.com/package/skills) to install all my skills. 


I use the `add` command to install the skills. Since I want to install the skills in my home directory and not the project, I use the `--global` flag. I don't specify any agent, and then it will end up in the correct directory, `~/.config/agents`. I also use the `--yes` flag to avoid being prompted. 
```bash
npx skills add <skill-repository> --global --yes
```

**Install current skills**
```bash
npx skills@latest add mattpocock/skills --global --yes
npx skills@latest add petergyang/no-ai-slop --skill no-ai-slop --global --yes
```


### Update

Installing skills works just fine, but updating is problematic. If a skill has been updated, it works well, but not if it has been deleted—in that case, `npx skills` has no way of knowing that it has been removed.

My process for getting around this problem is to remove all skills and reinstall them with the latest version. Since I have all my skills in my dotfiles Git repository, this is not a problem. I am not afraid of losing anything. The process looks like this:
1. Delete all skills `rm --force ~/.config/agent/skills`
1. Reinstall all skills, as above.  

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



```

```
