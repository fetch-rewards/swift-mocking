---
name: publish-release
description: Publish the draft GitHub release for swift-mocking after the changelog PR has been merged. Creates the git tag and makes the release public. Run only after /prepare-release and the changelog PR is merged.
---

# Publish Release

Publishes the draft GitHub release prepared by `/prepare-release`. Run this after the changelog PR is merged.

## 1. Identify the draft release

```sh
gh release list --repo fetch-rewards/swift-mocking
```

**If a draft exists:** note its version (e.g. `0.3.0`) and continue to step 2.

**If no draft exists:** fetch main and check whether the topmost (most recent) version entry in `CHANGELOG.md` has a corresponding git tag:

```sh
git fetch origin
git show origin/main:CHANGELOG.md
git tag --sort=-version:refname
```

Only look at the single topmost version in `CHANGELOG.md`. If that version has no corresponding git tag (i.e. the changelog PR merged but the draft was lost), recreate the draft. Extract the release notes from that version's section — everything between its header and the next version's header, excluding the version header line itself. The assembled notes body looks like:

```markdown
### ✨ Features

- Example entry ([#NNN](https://github.com/fetch-rewards/swift-mocking/pull/NNN))

[Full Changelog](https://github.com/fetch-rewards/swift-mocking/compare/<previous_version>...<version>)
```

where `<previous_version>` is the version entry directly below it in `CHANGELOG.md`. The release draft notes must end with a blank line followed by the full-changelog link. Write the assembled body to a temp file and create the draft:

```sh
gh release create <version> --repo fetch-rewards/swift-mocking --draft --title "Version <version>" --notes-file <path>
```

The draft is now recreated. Continue to step 2 using the `<version>` just determined from `CHANGELOG.md`.

If the topmost `CHANGELOG.md` version already has a corresponding git tag (i.e. it is already released), stop and tell the user to run `/prepare-release` first.

## 2. Validate the changelog is in place

Fetch the latest `main` and check that `CHANGELOG.md` contains a version entry matching the draft release version:

```sh
git fetch origin
git show origin/main:CHANGELOG.md | grep "Version <version>"
```

If the version is not found, stop and tell the user the changelog PR for `<version>` has not been merged into `main` yet.

## 3. Publish the release

```sh
gh release edit <version> --repo fetch-rewards/swift-mocking --draft=false
```

This creates the `<version>` git tag pointing to the current HEAD of `main` and makes the release public.

## 4. Confirm

Report the published release URL to the user.
