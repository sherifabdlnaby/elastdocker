# AGENTS.md

Guide for AI agents working in this repo. Humans: see [README.md](README.md).

## What this is

A Docker Compose distribution of the Elastic Stack (Elasticsearch, Logstash, Kibana, APM, Beats). The runtime is **Docker Compose v2**; the stack is driven by **mise tasks** under the `elk:` namespace (`mise run elk:setup`, `mise run elk`, `mise run elk:down`, … see `mise tasks`). mise is required to run the stack. The task names are the users' interface (README documents them), so a rename is a breaking change. There is no application source to build, the repo is compose files, service configs (YAML), Dockerfiles, and shell setup scripts.

## Toolchain (mise)

[**mise**](https://mise.jdx.dev) pins the linters/formatters, exposes tasks, and wires git hooks. `mise.toml` is the source of truth for `[tools]`, `[tasks]`, `[env]`, `[hooks]`, and `[settings]`. Don't install a linter by hand or bolt on an ad-hoc script, add a mise tool or task instead.

**Setup** (once, and per new worktree): `mise trust && mise run setup`. Setup first runs `mise doctor project`, which fails fast when a prerequisite mise can't install (e.g. a running Docker engine) is missing; those checks are `[doctor.checks]` in `mise.toml`.

**Run via mise** before calling work done:

```sh
mise run check          # all linters/formatters/validators (alias: lint); add --fix to auto-fix
mise run check --all    # whole tree (default scope is uncommitted changes; --pr = changed vs main)
mise run check --step shellcheck  # one step, for a short feedback loop (--skip-step to exclude)
mise tasks              # discover every task (elk, elk:setup, elk:down, …)
mise run <task> --help  # a task's flags
```

## Git hooks (hk)

Commits run the [hk](https://hk.jdx.dev) commit gates on staged files, and a push runs the push gates; CI runs both as `mise run check`, so a green commit is not yet a green CI. Fix failures with `mise run check --fix`; don't disable steps to push a commit through. `git commit --no-verify` skips hooks for a WIP commit. `mise run setup` installs the hooks; on Git 2.54+ they live in git config, so an empty `.git/hooks/` does not mean no hooks.

## Linters

Steps live in `.config/hk.pkl`, grouped into tiers by when they run (commit gates, push gates); the `check` hook mounts every tier. `mise run check --step <TAB>` completes step names, and `hk check --plan --all` lists them.

Linter configs live beside `.config/hk.pkl` in `.config/`. Each step is routed to its file there (native discovery, an env var, or a `--config` flag spliced in by `withFlag`); a tool that cannot find its config falls back to defaults and still passes, so prove a new route by breaking the file once. betterleaks reads its config only via `BETTERLEAKS_CONFIG`; `.env` (placeholder defaults) is allowlisted there, not a real secret store.

## CI

- `.github/workflows/lint.yml` runs `mise run check` (`--pr` on PRs, `--all` on schedule/dispatch) and leaves one sticky comment pointing at `mise run check --fix`. Keep this green by running `mise run check --all` locally.
- `.github/workflows/smoke-test.yml` spins up the full stack (`mise run elk:setup && mise run elk`), smoke-tests Elasticsearch + Kibana, and Trivy-scans the built image to the Security tab. Changes to compose files or service configs are validated here.
- `.github/workflows/auto-release.yml` drafts releases. GitHub Actions are pinned to commit SHAs (enforced by `pinact`); let `mise run check --fix` re-pin after bumping a version comment.

## Extending the setup

Changing tools, tasks, env, or hooks? Edit the config, then run `mise run check`:

- **`mise.toml`**: `[tools]` (pinned linters + hk), `[tasks]` (stack tasks under `elk:`, compose file sets and service groups in `[vars]`), `[env]` (loads `.env`), `[settings]`.
- **`mise.lock`**: resolved versions + checksums. Commit it; regenerate with `mise lock` after a `[tools]` change.
- **`.config/hk.pkl`**: the lint pipeline, with linter configs beside it in `.config/`. Add a fast, file-scoped step to `commitGates`; a slower one to `pushGates` (route it to a mise task).
- **`.config/mise/`**: project-local state (the setup stamp is gitignored) and the task completion script.

For tool/task/hook syntax, see the [mise](https://mise.jdx.dev) and [hk](https://hk.jdx.dev) docs.
