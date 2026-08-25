# Claude Code global config

Global (user-scope) Claude Code configuration. Claude Code reads `~/.claude/`, so these files
are symlinked into place rather than copied — edit them here.

## Install on a new machine

```sh
mkdir -p ~/.claude/themes ~/.claude/plugins

ln -s ~/repos/dotfiles/claude/CLAUDE.md      ~/.claude/CLAUDE.md
ln -s ~/repos/dotfiles/claude/settings.json  ~/.claude/settings.json
ln -s ~/repos/dotfiles/claude/hooks          ~/.claude/hooks
ln -s ~/repos/dotfiles/claude/themes/solarized-light-custom.json \
      ~/.claude/themes/solarized-light-custom.json

cp ~/repos/dotfiles/claude/known_marketplaces.json ~/.claude/plugins/
```

`hooks/` is linked as a whole directory, so new hooks need no extra link.

`known_marketplaces.json` is **copied, not linked** — Claude Code rewrites it (it stamps
`lastUpdated` on marketplace refresh), and `installLocation` inside it is an absolute path
that only matches this account. Re-copy it here if you add a marketplace.

## What's here

| Path | Notes |
|---|---|
| `CLAUDE.md` | Global instructions: read-only-command policy, AWS credential arrangement, `uv`/`httpie` preferences |
| `settings.json` | Bedrock env, theme, permission allowlist, `PreToolUse` hooks |
| `hooks/` | Hook scripts referenced by `settings.json` |
| `themes/` | `settings.json` sets `theme: custom:solarized-light-custom`; without this file the setting dangles |
| `known_marketplaces.json` | Records the `anthropics/claude-plugins-official` marketplace |

`hooks/block-venv-exec.py` must stay executable (`chmod +x`). `settings.json` invokes it via
`python3`, so a lost mode bit is a confusing rather than obvious failure.

The hooks and the settings that reference them must move together. `settings.json` calls each
hook by path (`python3 ~/.claude/hooks/<name>.py`); a missing script means the hook silently
stops guarding instead of failing loudly.

## Skills — not tracked here, and shouldn't be

`~/.claude/skills/` holds ~18 `aws-*` skill directories. They are **not** vendored into this
repo: each carries a `.aws-skill-metadata` file with its own version (`v1`, `v2`, `v5` observed
2026-08-24), i.e. they are refreshed independently and would drift the moment they were copied.
They are not from the official plugin marketplace — that clone doesn't contain them.

They appear to be installed and version-refreshed by the **`aws-mcp` MCP server** (the same
server that exposes an `aws___retrieve_skill` tool); all 18 landed at one timestamp. *This is
inferred from the naming, the per-skill versioning and the single install timestamp, not
confirmed against a documented mechanism.* The practical recovery step is to connect `aws-mcp`
and let it populate the directory — if that turns out not to repopulate them, vendoring them
here becomes the better option.

One skill is managed in another repo and needs its link re-made by hand:

```sh
ln -s ~/repos/isv-skills/tines-story-to-typescript ~/.claude/skills/tines-story-to-typescript
```

## `~/.claude.json` — not tracked

That file is ~34 KB of mutable state (`numStartups`, `tipsHistory`, `userID`, per-project
history) that rewrites itself constantly, so it is deliberately absent. The only part worth
re-creating by hand is the MCP server list:

- **`aws-mcp`** — stdio, `uvx` running `mcp-proxy-for-aws`, pinned to `--profile sandbox`.
  That pin decides which AWS account every `mcp__aws-mcp__*` call hits; the proxy reads its
  args only at launch, so changing it needs a Claude Code restart.
- **`se_demo_3b`** — HTTP transport; authorization is interactive OAuth, held outside this file.

Re-add with `command claude mcp add ...` — note the `command` prefix, since `claude` is a shell
function in `zshrc` that forwards to a new terminal window and returns no output.

To put a server's config under version control properly, prefer `--scope project`, which writes
a `.mcp.json` in the repo that needs it. A copy of the config in this repo would be inert:
nothing compares it against the live file.

## Deliberately not tracked

Machine-local state and churn under `~/.claude/`:

```
projects/   sessions/   history.jsonl   shell-snapshots/   file-history/   cache/
ide/        daemon/     daemon.log      jobs/              session-env/    backups/
paste-cache/            mcp-needs-auth-cache.json          plugins/marketplaces/
```

Also `claude_desktop_config.json`, which is already a symlink into
`~/Library/Application Support/Claude/` and owned by the desktop app.

`settings.local.json` is gitignored on purpose — it is the per-machine override layer.

Track `agents/`, `commands/` and `keybindings.json` here as soon as they exist; they are
hand-authored like the hooks.
