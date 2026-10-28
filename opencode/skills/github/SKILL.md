---
name: github
description: Use for any GitHub task — repos, PRs, issues, reviews, CI/Actions runs, releases, gists, searching code/issues, or raw GitHub API calls. Uses the authenticated `gh` CLI (prefer over the GitHub MCP).
---

# GitHub via `gh` CLI

`gh` is installed and authenticated (keyring, user `whyyor`). Run via shell. Inside a git repo, `gh` infers the repo; elsewhere pass `-R owner/repo`.

## Rules
- Prefer `--json field1,field2` + `--jq` for machine-readable output; avoid parsing tables.
- Never open an interactive editor/prompt: always pass `--title`, `--body`/`--body-file`, `--fill`, or `--yes`.
- Use `GH_PAGER=cat` / `--paginate` for long lists.
- Ask the user before destructive or public actions (merge, close, delete, release, force push, commenting).
- Check auth with `gh auth status` if something fails.

## Common commands
- Repo: `gh repo view [-R o/r] --json name,description,defaultBranchRef`, `gh repo clone o/r`, `gh repo create name --private --source . --push`
- PRs: `gh pr list --json number,title,author,headRefName`, `gh pr view N --json title,body,files,reviews,statusCheckRollup`, `gh pr diff N`, `gh pr checkout N`, `gh pr create --title T --body B --base main`, `gh pr review N --approve|--comment -b "..."`, `gh pr merge N --squash --delete-branch`
- Issues: `gh issue list --state open --json number,title,labels`, `gh issue view N --comments`, `gh issue create -t T -b B -l label`, `gh issue comment N -b "..."`
- CI: `gh run list --limit 10`, `gh run view RUN_ID --log-failed`, `gh run watch RUN_ID`, `gh pr checks N`
- Releases: `gh release list`, `gh release create vX --generate-notes`
- Search: `gh search repos|issues|prs|code "query" --json ...`

## Anything else → `gh api`
- REST: `gh api repos/{owner}/{repo}/pulls/N/comments --paginate`
- GraphQL: `gh api graphql -f query='query { viewer { login } }'`
- Write: `gh api -X POST repos/{owner}/{repo}/issues -f title=T -f body=B`
`{owner}`/`{repo}` auto-fill from the current repo.
