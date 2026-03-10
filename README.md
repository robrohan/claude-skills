# Claude Skills

A collection of skills (slash commands) for Claude Code.

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| [KanbanBoard](skills/KanbanBoard/SKILL.md) | `/kanban` | Manage an Obsidian-format Kanban board with subcommands: `init`, `plan`, `manage`, `work`, `verify`, `view` |
| [Laffaire](skills/Laffare/SKILL.md) | `/laffaire` | Manage Laffaire calendar projects and entries via its JSON API |
| [Stitch](skills/Stitch/SKILL.md) | `/stitch` | Extract highlights from a Kindle or Kobo e-reader and write them to a JSON file |

## Installation

Claude Code skills are installed into `~/.claude/skills/`. Each skill lives in its own subdirectory containing a `SKILL.md` file.

### Install all skills

```sh
mkdir -p ~/.claude/skills/kanban ~/.claude/skills/laffaire ~/.claude/skills/stitch
curl -o ~/.claude/skills/kanban/SKILL.md https://raw.githubusercontent.com/robrohan/claude-skills/refs/heads/main/skills/KanbanBoard/SKILL.md
curl -o ~/.claude/skills/laffaire/SKILL.md https://raw.githubusercontent.com/robrohan/claude-skills/refs/heads/main/skills/Laffare/SKILL.md
curl -o ~/.claude/skills/stitch/SKILL.md https://raw.githubusercontent.com/robrohan/claude-skills/refs/heads/main/skills/Stitch/SKILL.md
```

### Install a single skill

For example, to install only the Kanban skill:

```sh
mkdir -p ~/.claude/skills/kanban
curl -o ~/.claude/skills/kanban/SKILL.md https://raw.githubusercontent.com/robrohan/claude-skills/refs/heads/main/skills/KanbanBoard/SKILL.md
```

### Usage

Once installed, invoke a skill in any Claude Code session with its slash command:

```
/kanban view
/laffaire
/stitch
```

Run `/help` in Claude Code to see all available commands.
