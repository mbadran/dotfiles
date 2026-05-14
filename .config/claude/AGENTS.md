# user-wide agent instructions

These are universal rules that apply to every project session under this user
account. Project-specific overlays (`<repo>/AGENTS.md`, `<repo>/CLAUDE.md`)
take precedence where they conflict. When in doubt, follow the project's
instruction file over this one.

## Session start

The `SessionStart` hook at `~/.config/claude/hooks/session/start.sh` fires
automatically and prints, in order:

1. git recap (branch, recent commits, uncommitted entries)
2. memory bootstrap (file count, recent files, decay candidates at 30+ days)
3. memory content dump (full contents of every file listed in `MEMORY.md`)
4. todo/fixme scan in the cwd
5. project hook output (if `<repo>/scripts/hooks/session/start.sh` exists)
6. project permissions allow list

After the hook output:

- The memory files have already been loaded — no need to re-`cat` them
- Present a brief "where we at" summary: branch, open work, parked items
- If the project has its own AGENTS.md / CLAUDE.md with a session-start checklist (e.g. dotfiles, speedoku), follow that file's checklist precisely

## Session end

When the user signals wrap-up ("wrap up", "let's call it", etc.):

1. Update project state files per the project's AGENTS.md (PRD, memory, README, etc.)
2. The `SessionEnd` hook fires automatically — it prints drift, project hook output, push reminder, signoff
3. Sign off with the personal sayonara (the hook does this; mirror in the LLM response is fine)

Never run `git push` as part of session wrap-up. Push is always an explicit user instruction.

## Shell trip-ups (macOS + zsh)

Aliased commands silently break Bash tool calls. Each Bash call spawns a fresh
shell that re-sources `.zshrc`, so these aliases can't be unset globally for
the session.

| Alias              | Problem                                            | Use instead                                  |
| ------------------ | -------------------------------------------------- | -------------------------------------------- |
| `cd` → `zoxide`    | Silently jumps elsewhere; corrupts later paths     | Absolute paths; never `cd` from agents       |
| `rm`  → confirms   | Hangs in non-interactive sessions                  | `command rm -f`                              |
| `cp`  → confirms   | Same                                               | `command cp -f`                              |
| `grep` → `rg`      | Flag set differs (no `-E`, different `-e`)         | Use the Grep tool, not `grep` via Bash       |
| `npx` → hangs      | Package resolution stalls on this machine          | `node_modules/.bin/<tool>` directly          |

Prefer the **Grep** and **Glob** tools over `grep`/`find` via Bash — they
bypass the shell entirely. If you must use Bash for aliased commands, prefix
with `unalias -a 2>/dev/null;`.

## Permission-friendly invocations

Each unique Bash command shape has to match an allow-rule in settings or it
prompts the user. Compound commands (`cd X && git status`) and ad-hoc paths
multiply the prompts. Rule: use the tool's own path/working-dir flag.

| Tool | Don't                          | Do                                           |
| ---- | ------------------------------ | -------------------------------------------- |
| git  | `cd /path && git status`       | `git -C /path status`                        |
| git  | `(cd /path && git log)`        | `git -C /path log --oneline -5`              |
| npm  | `cd /path && npm install`      | `npm install --prefix /path`                 |
| tsc  | `cd /path && tsc --noEmit`     | `tsc --noEmit -p /path`                      |

For **destructive** ops (rm, `git reset --hard`, force push, dropping a branch)
confirm with the user first, regardless of whether permission settings allow.

## Commit + push discipline

- **Never push without explicit user instruction.** Commit freely, then stop. Wait for the user to say "push" (or equivalent).
- **No `Co-Authored-By:` lines** in commits unless explicitly requested.
- For project-specific commit message style and pre-commit hygiene, see the project's AGENTS.md and any project skills (e.g. `committing-<project>-mo`).

## Editing discipline

- **Surgical**: change only what was requested. Don't reformat, refactor, or "tidy" unrelated code.
- **No speculative cleanup** — removing dead vars, renaming, normalizing imports — only when scoped to the task.
- **One-at-a-time** when the user is actively co-editing a file — don't batch rewrites of files the user is in.
- **No `while I'm here` changes.** If you spot something else worth fixing, surface it and let the user decide; don't fix it silently.

## Paranoia: backup before destructive ops

Before any operation that can lose uncommitted work, back up the affected
paths to `working/backups/<name>-$(date +%Y%m%d-%H%M)/`.

Applies to: `git reset --hard`, `git checkout .`, `git restore .`, `git clean -f`, `git rebase`, `git stash drop/clear`, `git branch -D`, `git push --force`, `ExitWorktree` with discard, `rm -rf`, `command rm -f`, bulk find-replace.

Rule of thumb: if the operation can't be undone with `git reflog` or Cmd+Z, back up first. For untracked files in worktrees, there is no safety net except a manual copy.

## Reading logs before speculating

When something fails, read the actual error before guessing. Check test
output, dev server logs, screenshots/dumps, screenshots from Cypress or
Playwright if present. Ask the user only after exhausting the logs you can
see yourself.

## Working scratchpad

Most projects have `working/` (or similar) as a gitignored scratchpad for
experiments, debug dumps, backups, test fixtures. Use it instead of `/tmp`
for anything project-related. Don't put long-term docs or instructions
there — those belong in tracked files.

## Memory / skills / AGENTS.md — when to use which

| Type           | Use when                                                                  |
| -------------- | ------------------------------------------------------------------------- |
| Memory         | User preferences, project context, point-in-time observations             |
| Skill          | Capability/instructions loaded on demand by triggering context            |
| AGENTS.md      | Always-on rules that apply every session in scope (user or project)       |

If the same instruction is recurring across sessions, it belongs in memory or
a skill, not in working context.

## User-wide skills

| Skill                | Trigger                                                                                                                                  |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `formatting-mo`      | Editing Markdown tables, section headers, prose paragraphs, trailing ws                                                                  |
| `playwright-bdd-mo`  | Writing/editing Playwright (`*.spec.ts`) or Cypress (`*.cy.ts`) E2E tests in Mo's Gherkin-flavored dialect, or porting Cypress→Playwright |

Project-specific skills live in `<repo>/.claude/skills/` and load only when
working in that repo.

## User-wide agents

Dispatch these via the Agent tool when the user's request matches the trigger.
Don't wait for the user to name the agent — pattern-match on the request shape.

| Agent                  | Dispatch when                                                                                                                  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `config-auditor`       | User asks to audit / review / sanity-check / clean up a config file or config dir (zshrc, nvim, ghostty, starship, etc.). Read-only |
| `rust-cli-scaffolder`  | User asks to scaffold a new Rust CLI project (morsel, aloha, neopager, pangram, or any future utility). Writes the standard layout    |

Project-specific agents live in `<repo>/.claude/agents/` and override user-wide
agents of the same name when invoked in that repo.
