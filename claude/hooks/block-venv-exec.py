#!/usr/bin/env python3
"""PreToolUse hook: block direct execution of .venv/bin/ executables.

Enforces the global preference for `uv run <cmd>` over `./.venv/bin/<cmd>`.

Detection is by *command position*, not substring presence, so read-only
inspection of a venv (`ls -l .venv/bin/`, `cat .venv/bin/foo`) is untouched
while execution (`cd ~/x && ./.venv/bin/foo`) is blocked.

Fails open: any unexpected input or internal error exits 0 (allow), so a bug
here can never wedge the session.
"""

import json
import re
import sys

# A token that names an executable inside a .venv/bin directory.
# Matches ./.venv/bin/x, .venv/bin/x, /abs/p/.venv/bin/x, ~/p/.venv/bin/x
VENV_EXEC = re.compile(r"(?:^|/)\.venv/bin/[^/]+$")
VENV_ACTIVATE = re.compile(r"(?:^|/)\.venv/bin/activate(?:\.\w+)?$")

# Shell operators that begin a new command context.
SEGMENT_SPLIT = re.compile(r"(?:\|\||&&|;|\||\n|\(|\)|&)")

# Prefixes that delegate to the *next* token as the real command.
PASSTHROUGH = {"sudo", "command", "exec", "time", "nohup", "env", "builtin", "eval"}

ENV_ASSIGN = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*=")

REASON = (
    "Blocked: this command executes an interpreter/entry point directly from a "
    ".venv/bin/ directory ({hit}).\n\n"
    "Use `uv run <command>` instead — it resolves the same interpreter without "
    "hardcoding the venv path. If the venv belongs to another directory, run "
    "from that directory (uv discovers .venv relative to cwd), e.g.:\n"
    "  cd /path/to/project && uv run <command>\n\n"
    "Inspecting files under .venv/bin/ (ls, cat, grep) is not blocked — only "
    "executing them."
)


def unquote(tok: str) -> str:
    if len(tok) >= 2 and tok[0] == tok[-1] and tok[0] in ("'", '"'):
        return tok[1:-1]
    return tok


def find_violation(command: str):
    """Return the offending token, or None if the command is acceptable."""
    for segment in SEGMENT_SPLIT.split(command):
        try:
            tokens = segment.split()
        except Exception:
            continue
        if not tokens:
            continue

        # Drop leading env assignments (FOO=bar BAZ=qux cmd ...) and
        # passthrough wrappers (sudo, exec, time, ...) to reach the real command.
        idx = 0
        while idx < len(tokens):
            tok = unquote(tokens[idx])
            if ENV_ASSIGN.match(tok) or tok in PASSTHROUGH:
                idx += 1
                continue
            break
        if idx >= len(tokens):
            continue

        rest = [unquote(t) for t in tokens[idx:]]
        head = rest[0]

        # Case 1: the command itself lives in .venv/bin/
        if VENV_EXEC.search(head):
            return head

        # Case 2: sourcing a venv activate script
        if head in ("source", "."):
            for arg in rest[1:]:
                if VENV_ACTIVATE.search(arg):
                    return arg

    return None


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return 0  # fail open

    command = (payload.get("tool_input") or {}).get("command")
    if not isinstance(command, str) or not command.strip():
        return 0

    try:
        hit = find_violation(command)
    except Exception:
        return 0  # fail open

    if not hit:
        return 0

    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "deny",
                "permissionDecisionReason": REASON.format(hit=hit),
            }
        },
        sys.stdout,
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
