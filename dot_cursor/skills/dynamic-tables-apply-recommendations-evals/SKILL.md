---
name: dynamic-tables-apply-recommendations-evals
description: Run the local eval workflow for the `dynamic-tables-apply-recommendations` skill in the `cortex-code-skills` repo. Use when the current workspace is `cortex-code-skills` and the user asks to run dynamic tables recommendation evals, apply-recommendations evals, refresh the QA6 OAuth token, activate the repo-local `evals` virtualenv, or invoke `cortex-eval` for these tasks.
---

# Dynamic Tables Apply-Recommendations Evals

## When to Use

Use this skill only when all of the following are true:

- The current workspace is `~/Projects/cortex-code-skills`
- The task is to run evals for the `dynamic-tables-apply-recommendations` workflow
- The user wants the local QA6 flow with the repo-local `evals` environment and the QA6 OAuth token script

If the request is about editing the skill, changing eval assertions, or general dynamic tables work, do not use this skill.

## Workflow

Run the eval flow in this order.

### Step 1: Preflight checks

Before running anything, verify these files exist:

```bash
~/Projects/cortex-code-skills/evals/.venv/bin/activate
~/Projects/cortex-code-skills/evals/.env.example
~/bin/qa6-oauth-token.py
```

If any of them are missing, stop and tell the user exactly which path is missing.

### Step 2: Activate the eval environment

Use the repo-local eval venv, not a sibling checkout:

```bash
source ~/Projects/cortex-code-skills/evals/.venv/bin/activate
```

### Step 3: Refresh the QA6 OAuth token

Run:

```bash
python3 ~/bin/qa6-oauth-token.py
```

This opens a browser window for login and fetches the OAuth token. The token is valid for 1 hour.

If the browser login requires manual completion, pause and ask the user to finish the login flow before continuing.

### Step 4: Run the evals

Default to the broader dynamic-tables config with an apply-recs filter:

```bash
cortex-eval run --config ~/Projects/cortex-code-skills/evals/data-engineering/dynamic-tables/config.yaml -c qa6 -a qa6 -i '*apply-recs-*'
```

For a narrower run, replace `*apply-recs-*` with the actual task regex the user wants.

When sourcing the env file, use absolute paths:

```bash
set -a && source ~/Projects/cortex-code-skills/evals/.env.example && set +a && source ~/Projects/cortex-code-skills/evals/.venv/bin/activate && cortex-eval run --config ~/Projects/cortex-code-skills/evals/data-engineering/dynamic-tables/config.yaml -c qa6 -a qa6 -i '*<regex-for-actual-test-to-run>*'
```

Replace `*<regex-for-actual-test-to-run>*` with the actual filter the user wants.

## Notes

- Keep the command order exactly as written: activate env, refresh token, then run `cortex-eval`.
- The OAuth token expires after 1 hour, so refresh it again if the token is stale or the eval run starts failing due to auth.
- Prefer absolute paths for `.env.example` and `.venv/bin/activate`. Relative sourcing was brittle in practice.
- Do not default to `evals/data-engineering/dynamic-tables/config-apply-recs.yaml`. In this repo state, that config currently mis-resolves task paths and fails with `FileNotFoundError` for `instruction.md` files.
- Only use `config-apply-recs.yaml` after first validating that its task paths resolve correctly from the current invocation context.

## Output

Report:

- whether environment activation succeeded
- whether token refresh succeeded
- the exact `cortex-eval` command that was run
- whether the eval run completed, failed, or needs user follow-up
