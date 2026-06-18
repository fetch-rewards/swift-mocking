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

If no draft exists, stop and tell the user to run `/prepare-release` first.

Note the version of the draft (e.g. `0.3.0`).

## 2. Validate the changelog is in place

Fetch the latest `main` and check that `CHANGELOG.md` contains a version entry matching the draft release version:

```sh
git fetch origin main
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
