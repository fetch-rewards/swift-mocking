---
name: prepare-release
description: Analyze merged PRs since the last release, determine the next version, update the changelog, open the PR, and populate the draft GitHub release notes for a new swift-mocking release.
---

# Prepare Release

Runs `generate-release-info` to collect PR data and compute the next version, then creates the changelog branch, updates `CHANGELOG.md`, opens a documentation PR, and populates the draft GitHub release notes.

When done, report the PR URL and tell the user to invoke `/publish-release` once the PR is merged.

## 1. Sync with main

Fetch origin and hard-reset to `origin/main`. Do not use `git pull` — it can produce merge commits that the repo's branch protection rules reject on push.

```sh
git fetch origin main
git checkout main
git reset --hard origin/main
```

## 2. Run generate-release-info

```sh
.claude/skills/prepare-release/scripts/generate-release-info
```

This outputs:
- `last_version` and `next_version` on the first two lines
- Pre-formatted changelog sections (section headings + bullet entries with markdown links) ready to paste directly into `CHANGELOG.md` and the release notes

## 3. Create a branch from origin/main

Branch name convention: `documentation/changelog-<next_version>`

```sh
git checkout -b documentation/changelog-<next_version> origin/main
```

## 4. Update CHANGELOG.md

Insert a new section above the previous version entry. The version header format is:

```markdown
## 🚀 [Version <next_version>](https://github.com/fetch-rewards/swift-mocking/releases/tag/<next_version>) - <Month Day, Year> ([Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/<last_version>...<next_version>))
```

Paste the sections from the script output beneath it verbatim.

## 5. Commit and push

```sh
git add CHANGELOG.md
git commit -m "Update changelog for Version <next_version>"
git push -u origin documentation/changelog-<next_version>
```

## 6. Create the PR

- **Title:** `Update changelog`
- **Base branch:** `main`
- **Label:** `documentation`
- **Assignee:** `graycampbell`

Use the repo's PR template at `.github/pull_request_template.md`. Set the summary to "Updated `CHANGELOG.md` for Version `<next_version>`.", check the Documentation checkbox, and check all Checklist items. Write the body to a temp file and pass it via `--body-file` to avoid multiline escaping issues.

## 7. Update the draft GitHub release notes

The release notes body is the script's section output (no version header line), followed by a full-changelog link:

```markdown
[Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/<last_version>...<next_version>)
```

Write to a temp file and update the draft:

```sh
gh release edit <next_version> --repo fetch-rewards/swift-mocking --notes-file <path>
```
