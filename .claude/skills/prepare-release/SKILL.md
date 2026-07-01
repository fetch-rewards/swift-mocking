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
git fetch origin
git checkout main
git reset --hard origin/main
```

## 2. Run generate-release-info

```sh
.claude/skills/prepare-release/scripts/generate-release-info
```

This outputs one of two things:

- **Unlabeled PRs (exit 1):** Only a `### ⚠️ Needs Label` section — no version or changelog sections. Handle this in step 3 before proceeding.
- **Success (exit 0):** `last_version` and `next_version` on the first line(s), followed by pre-formatted changelog sections ready to paste directly into `CHANGELOG.md` and the release notes. When the current version is pre-1.0 and the release contains a breaking change, two extra lines appear after `next_version` (`breaking_change_pre_1_0: true` and `major_version_option: 1.0.0`) — resolve them in step 5 before using `next_version`.

PRs labeled `breaking change` appear in their categorization section with a `⚠️ **[BREAKING]**` prefix. A breaking change bumps the major version (e.g. `1.4.2` → `2.0.0`) — **except** when the current version is pre-1.0 (`0.x.y`), where the public API is considered unstable and a breaking change is only a minor bump by default (e.g. `0.3.0` → `0.4.0`). See step 5.

## 3. Resolve unlabeled PRs

If the script exited with `### ⚠️ Needs Label`, those PRs had no categorization label. The script produces no version number or changelog output until this is resolved — do not proceed to later steps.

For each unlabeled PR, present its title and number, then ask the user to pick a label:

```
1. enhancement
2. bug
3. documentation
4. testing
5. refactoring
6. formatting
7. dependencies
8. ci
9. chore
```

Apply the chosen label:

```sh
gh pr edit <number> --repo fetch-rewards/swift-mocking --add-label <label>
```

Once all unlabeled PRs have been labeled, re-run the script. Repeat until the script exits successfully, then continue to the next step.

## 4. Review output for changelog PRs

Scan the most recent script output for any entry whose title contains "changelog" (case-insensitive). The script already filters PRs from `documentation/changelog-*` branches, but one may slip through if the branch was named differently.

For each flagged entry, ask the user: "PR #NNN ('title') looks like a changelog update — exclude it?" Do not proceed until the user has confirmed or dismissed each one. Remove any confirmed changelog PRs from the output before using it in subsequent steps. If no entries are flagged, continue immediately to step 5.

## 5. Resolve a pre-1.0 breaking change

Only applies when the script output includes `breaking_change_pre_1_0: true`. If it does not, skip this step and use `next_version` as-is.

When present, the release contains a breaking change but the current version is pre-1.0 (`0.x.y`). By SemVer convention the default is a minor bump (the printed `next_version`, e.g. `0.4.0`), but the user may instead choose to graduate to the `major_version_option` (`1.0.0`) to signal a stable public API. Prompt the user to choose:

- **Minor bump (default):** use the printed `next_version` (e.g. `0.4.0`).
- **Major bump:** use the `major_version_option` (`1.0.0`).

Use the chosen version as `next_version` for every subsequent step. The changelog sections are identical either way — only the version number changes.

## 6. Create a branch from origin/main

Branch name convention: `documentation/changelog-<next_version>`

```sh
git checkout -b documentation/changelog-<next_version> origin/main
```

## 7. Update CHANGELOG.md

Insert a new section above the previous version entry. The version header format is:

```markdown
## 🚀 [Version <next_version>](https://github.com/fetch-rewards/swift-mocking/releases/tag/<next_version>) - <Month Day, Year> ([Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/<last_version>...<next_version>))
```

Paste the sections from the script output (with any entries removed per step 4) beneath it verbatim.

## 8. Commit and push

```sh
git add CHANGELOG.md
git commit -m "Update changelog for Version <next_version>"
git push -u origin documentation/changelog-<next_version>
```

## 9. Create the PR

- **Title:** `Update changelog`
- **Base branch:** `main`
- **Label:** `documentation`
- **Assignee:** `graycampbell`

Use the repo's PR template at `.github/pull_request_template.md`. Set the summary to "Updated `CHANGELOG.md` for Version `<next_version>`.", check the Documentation checkbox, and check all Checklist items. Write the body to a temp file and pass it via `--body-file` to avoid multiline escaping issues.

## 10. Create or update the draft GitHub release notes

Assemble the notes body: the script's section output (no version header line, with any entries removed per step 4), followed by the full-changelog link. The script output already ends with a blank line, so append the link directly. The assembled body looks like:

```markdown
### ✨ Features

- Example entry ([#NNN](https://github.com/fetch-rewards/swift-mocking/pull/NNN))

[Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/<last_version>...<next_version>)
```

Write the assembled body to a temp file, then check whether a release already exists for `<next_version>`:

```sh
gh release list --repo fetch-rewards/swift-mocking
```

- **Listed as Draft:** update it:
  ```sh
  gh release edit <next_version> --repo fetch-rewards/swift-mocking --notes-file <path>
  ```
- **Listed but not a draft (already published):** warn the user — do not overwrite a published release.
- **Not listed:** create a draft:
  ```sh
  gh release create <next_version> --repo fetch-rewards/swift-mocking --draft --title "Version <next_version>" --notes-file <path>
  ```
