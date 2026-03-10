---
name: kanban
description: "Manage an Obsidian Kanban board through a multi-agent workflow. Subcommands: init, plan, manage, work, verify, view."
version: 1.0.0
allowed-tools: 
	- Read 
	- Edit
	- Write
---

# Kanban Board

You are managing an Obsidian-format Kanban board. Parse `$ARGUMENTS` to determine your role and act accordingly.

The `<board-file>` argument is optional in all subcommands. If omitted, default to `./KANBAN.md` in the current working directory.

## Usage

```
/kanban view [board-file]
/kanban init [board-file]
/kanban plan [board-file]
/kanban manage [board-file]
/kanban work pop <agent-name> [board-file]
/kanban verify "<task name>" [board-file]
```

## Board Format

The board file uses this structure:

```
---

kanban-plugin: board

---

## 🧊 Backlog

- [ ] Task 1
- [ ] Task 2 @{2027-06-20}

## 📝 Todo

- [ ] Task 3 @{2026-03-31}
- [ ] Task 4 [[Link To Obsidian File]]

## 👨‍💻 Doing (2)

- [ ] Task 5
- [ ] Task 6

## ✅ Done

**Complete**
- [x] Task 7
```

## Rules for All Subcommands

- Never delete tasks — only move them forward through columns
- Always preserve the `kanban-plugin: board` frontmatter
- Always preserve all column headers exactly as written
- Always preserve the `**Complete**` marker in the Done column
- Only modify the column(s) relevant to your subcommand

---

## Subcommands

### view

**Role:** Viewer — display the board as a formatted table.

Arguments: `view [board-file]`

1. Read the board file at the given path
2. Parse all tasks from each column
3. Output a markdown table with one column per stage:

| 🧊 Backlog | 📝 Todo | 👨‍💻 Doing | ✅ Done |
|---|---|---|---|
| Task A | Task C | Task D #agent | Task F |
| Task B | | | Task G |

- Each cell contains the task description (strip the `- [ ]` / `- [x]` prefix)
- Strip `#agent` tags and show them in parentheses after the task: `Task D (worker1)`
- Strip `@{date}` and show dates in parentheses after the task: `Task B (2027-06-20)`
- If a column is empty, show `—` in its first cell
- Do not modify the board file

---

### init

**Role:** Initializer — create a new empty board file for a project.

Arguments: `init <board-file>`

1. Check that `<board-file>` does not already exist — if it does, stop and warn the user rather than overwriting their board
2. Create the file at the given path with this exact content:

```
---

kanban-plugin: board

---

## 🧊 Backlog

## 📝 Todo

## 👨‍💻 Doing (0)

## ✅ Done

**Complete**
```

3. Report the path of the created file and suggest running `/kanban plan <board-file>` next

---

### plan

**Role:** Planner — populate the Backlog with tasks.

1. Read the board file at the given path
2. Analyze the goal or context provided by the user (or infer from the project name)
3. Break the goal into discrete, actionable tasks
4. Append each task to the `## 🧊 Backlog` column as `- [ ] Task description`
5. Optionally include a due date: `- [ ] Task description @{YYYY-MM-DD}`
6. Optionally link to related notes: `- [ ] Task description [[Note Name]]`
7. Do not move or remove any existing tasks
8. Save the updated board file

---

### manage

**Role:** Manager — promote prioritized tasks from Backlog to Todo.

1. Read the board file at the given path
2. Review all tasks in `## 🧊 Backlog`
3. Select tasks to promote based on due dates, dependencies, or logical order
4. Move selected tasks from `## 🧊 Backlog` to `## 📝 Todo` (remove from Backlog, append to Todo)
5. Do not move more tasks than can reasonably be worked on
6. Do not touch tasks in any other column
7. Save the updated board file

---

### work

**Role:** Worker — pop the next task from Todo and execute it.

Arguments: `work pop <agent-name> <board-file>`

1. Read the board file at the given path
2. Take the first task from `## 📝 Todo` (top of the list)
3. Append `#<agent-name>` to the task text (e.g. `- [ ] Task description #worker-1`)
4. Move that task from `## 📝 Todo` to `## 👨‍💻 Doing` (remove from Todo, append to Doing)
5. Update the WIP count in the column header: `## 👨‍💻 Doing (N)` where N is the new count
6. Save the updated board file
7. Execute the work described by the task
8. Report what was done — do not mark the task complete (that is the Verifier's job)

---

### verify

**Role:** Verifier — confirm completed work and close the task.

Arguments: `verify "<task name>" <board-file>`

1. Read the board file at the given path
2. Find the task matching `<task name>` in `## 👨‍💻 Doing`
3. Review the work that was done and confirm it is complete
4. If complete:
   - Change `- [ ]` to `- [x]`
   - Move the task from `## 👨‍💻 Doing` to `## ✅ Done` under the `**Complete**` header
   - Decrement the WIP count in `## 👨‍💻 Doing (N)`
   - Save the updated board file
   - Report that the task is verified and closed
5. If not complete:
   - Leave the task in `## 👨‍💻 Doing`
   - Report what is missing or incomplete so the Worker can address it
