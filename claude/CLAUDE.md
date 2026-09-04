# Read Only Commands

## Permissions

You may run read-only shell commands or Python scripts freely without asking for confirmation
(e.g. list, describe, get, show).

For any mutating or destructive command — including but not limited to deletes, creates,
updates, deploys, and infrastructure operations — show me the exact command and wait for my
explicit approval before running it.

Notes on how this is actually enforced:

- The "without asking" half is delivered by the allowlist in `~/.claude/settings.json`, not by
  this file — prose cannot suppress a permission prompt. If a read-only command still prompts,
  it's missing from that allowlist; propose adding it rather than working around it.
- A command being read-only is judged by what it *does*, not by what it looks like.
  `find -delete`, `git branch -D`, and `<anything> | tee` are mutating. When a command mixes
  read and write, treat the whole thing as mutating.
- Scripts are opaque: the allowlist can't tell a read-only script from a destructive one, so
  script execution stays promptable by design. Before proposing to run one I haven't read,
  read it first.

# AWS Credentials

## `sandbox` is the default; Bedrock is decoupled

`AWS_PROFILE=sandbox` in the `env` block of `~/.claude/settings.json`, so every AWS call — Bash,
`cdk`/`sam`, plain boto3, and the `mcp__aws-mcp__*` tools — resolves to the sandbox account
without naming a profile. Write `aws s3 ls`, not `aws --profile sandbox s3 ls`. Name a profile
only when you deliberately want a *different* account (`--profile marketplace`).

Notes on how this is actually arranged:

- Claude Code's own model calls do **not** use `AWS_PROFILE`. They get credentials from
  `awsCredentialExport` (`aws configure export-credentials --profile bedrock --format process`),
  which runs at session start and on each credential reload. That decoupling is the whole point:
  before it, `AWS_PROFILE` had to be `bedrock` for the model to work, so every unprofiled AWS
  command silently hit the Bedrock account instead of the one intended.
- `sandbox` and `bedrock` share `sso-session tines`, so the `awsAuthRefresh` login on `bedrock`
  refreshes the token both profiles use. One `aws sso login` covers both.
- The `mcp__aws-mcp__*` tools carry no profile argument of their own — `--profile` inside
  `call_aws`'s `cli_command` is rejected outright, and `run_script`'s `call_boto3` has no profile
  parameter. Their identity comes from the `mcp-proxy-for-aws` server in `~/.claude.json`, which
  is pinned to `--profile sandbox`; absent that flag it would fall back to `AWS_PROFILE`, which is
  now also sandbox. If you ever need a per-call override, give the proxy two profiles
  (`--profile sandbox marketplace`) — with only one it installs no override middleware and the
  `aws_profile` tool parameter does not exist.
- The proxy reads its args only at launch, so a change to `~/.claude.json` needs a Claude Code
  restart before it takes effect. Same for a change to `AWS_PROFILE`. After changing either, check
  the account with `aws sts get-caller-identity` — through `call_aws` as well as Bash, since the
  two resolve credentials independently.
- If the credential export breaks, model calls fail loudly at startup rather than AWS calls going
  quietly to the wrong account. That failure direction is deliberate. Removing the
  `awsCredentialExport` line and setting `AWS_PROFILE=bedrock` restores the old behavior.

# Project Guidelines

## Python Package Management

Use `uv` for all Python package management operations:
- **Installing packages**: `uv pip install <package>`
- **Creating virtual environments**: `uv venv`
- **Running scripts**: `uv run <script>`
- **Adding dependencies**: `uv add <package>`

Do NOT use `pip`, `pip3`, `poetry`, or `pipenv` for package operations.

## Python Development

When writing Python code, use Python's built-in libraries and capabilities directly:
- **HTTP requests**: Use `urllib.request` or `http.client` for REST API calls, not shell commands like `curl` or `httpie`
- **JSON processing**: Use `json` module, not `jq` via subprocess
- **File operations**: Use `open()`, `pathlib`, `os`, not shell commands like `cat`, `sed`, `awk`
- **System operations**: Use `os`, `subprocess.run()` when truly needed, but prefer native Python

Only delegate to shell tools when the operation is fundamentally shell-based (e.g., git commands, package managers) or when a specialized CLI tool is the standard interface.

## TypeScript/JavaScript Package Management

Use `bun` for all TypeScript/JavaScript package management operations:
- **Installing packages**: `bun install`
- **Adding dependencies**: `bun add <package>`
- **Adding dev dependencies**: `bun add -d <package>`
- **Running scripts**: `bun run <script>`
- **Executing files directly**: `bun <file.ts>` (no build step needed for TypeScript)

Do NOT use `npm`, `yarn`, or `pnpm` for package operations.

## TypeScript/JavaScript Development

When writing TypeScript/JavaScript code, use the language's built-in capabilities directly:
- **HTTP requests**: Use `fetch()` (built into Bun runtime) for REST API calls, not shell commands like `curl`
- **JSON processing**: Use `JSON.parse()` / `JSON.stringify()`, not `jq` via subprocess
- **File operations**: Use `fs` module or Bun's file APIs (`Bun.file()`, `Bun.write()`), not shell commands like `cat`, `sed`, `awk`
- **System operations**: Use `child_process` or Bun's `Bun.spawn()` when truly needed, but prefer native JavaScript/TypeScript

Only delegate to shell tools when the operation is fundamentally shell-based (e.g., git commands) or when a specialized CLI tool is the standard interface.

## HTTP Requests

Use `httpie` for making HTTP requests instead of `curl`:
- **GET requests**: `http GET https://api.example.com/endpoint`
- **POST requests**: `http POST https://api.example.com/endpoint key=value`
- **Headers**: `http GET https://api.example.com/endpoint Authorization:"Bearer token"`

HTTPie provides more readable output and simpler syntax for JSON APIs.

This ensures maximum portability across different systems.

## Rationale

- **uv**: Significantly faster than pip, better dependency resolution, modern tooling
- **bun**: Significantly faster than npm/yarn, all-in-one runtime and package manager, native TypeScript support
- **httpie**: More intuitive syntax, better formatted output, easier to read and debug

# Context Management

## AWS Command Hygiene

Always bound AWS CLI output to prevent context overflow:

- **Use `--query`** to extract only needed fields (JMESPath syntax)
- **Use `--output text`** for single-value results instead of JSON
- **Pass `--region` explicitly** when working across regions

**Why:** One unbounded AWS command can return megabytes of JSON. A single
`securityhub get-findings` without `--query` returns the full ASFF document and can exhaust
context mid-task.

Examples:
```bash
# Good - bounded output
aws ec2 describe-instances \
  --region us-west-1 \
  --query 'Reservations[].Instances[].[InstanceId,State.Name,InstanceType]' \
  --output text

# Bad - unbounded JSON
aws ec2 describe-instances --region us-west-1
```

For complex queries where multiple fields are needed, use `--query` to extract a subset and
`--output json` for structure, but never pipe raw AWS output without filtering.

## Subagent Delegation

Delegate noisy investigation to subagents when the answer is short but the evidence is bulky.

**When to delegate:**
- The answer is a conclusion in 10 lines or fewer
- The evidence requires multiple AWS describe/get/list calls whose JSON is far larger than the answer
- You need to WebFetch AWS documentation (see below)

**When NOT to delegate:**
- One bounded command would answer the question
- You need the raw data for further processing
- The investigation is part of the main task flow

Example: "Why is this Lambda timing out?" → delegate to `aws-probe` subagent if available.
The subagent reads logs, configuration, and VPC settings, then reports: "Lambda has no VPC access
but is trying to reach an RDS instance in a private subnet."

## Plan Lifecycle

Plans in `.claude/plans/` are working documents, not durable documentation.

**After executing a plan:**
1. Propagate durable facts into the appropriate documentation (STATUS.md, design docs, etc.)
2. Commit the plan
3. Delete the plan file

**Why:** Git history is the archive. Executed plans left in the tree look current and put
superseded designs one careless grep away from being read as active. Use
`git log --diff-filter=D --name-only -- .claude/plans/` to list deleted plans, then
`git show <sha>:<path>` to read one.

## WebFetch and AWS Documentation

Never `WebFetch` an AWS documentation index page.

**Why:** `WebFetch` returns the entire page as markdown with no way to bound the output. A
service's entry in the AWS General Reference endpoints index
(`docs.aws.amazon.com/general/latest/gr/<service>.html`) returns every regional endpoint table
and quota table to answer one row of one table.

**Instead:**
- Fetch the narrowest page in the service's developer guide
- Delegate to a `general-purpose` subagent and ask for specific sections
- For policy/template JSON, always request it **verbatim** — paraphrased condition keys or
  rewritten resources can be subtly wrong

**Measured:** Four doc fetches while planning one integration cost more context than every AWS
call in that session combined.

## Documentation Reading Strategy

When working with large documentation sets (>100KB):

- **Read sections, not whole files** — grep for headings and read that slice. Headings are
  stable and are the intended entry points.
- **Know which file to read when** — project CLAUDE.md or AGENTS.md files should tell you the
  starting point (e.g., "Start any session by reading docs/STATUS.md")
- **One file should be the entry point** — typically a STATUS.md or README.md that's meant to be
  read whole and points to other docs for detail

Example:
```bash
# Read just the "Deployment" section of a large doc
grep -A 30 "^## Deployment" docs/architecture.md
```
