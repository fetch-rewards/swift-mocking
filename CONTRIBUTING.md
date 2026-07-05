# Contributing

> [!IMPORTANT]
> PRs are merged at the discretion of the project's maintainers. If you would like to contribute code to this project,
> please first [open an issue](https://github.com/fetch-rewards/swift-mocking/issues/new) with a detailed description
> of your proposed changes. This allows us to discuss implementation, alternatives, etc. and avoid wasting time dealing
> with the inefficient back and forth that can arise when PRs are created without prior discussion.
>
> After you've created an issue, please read through the guidelines in this document carefully before implementing any
> changes.
>
> By opening an issue or contributing code to this project, you agree to follow our
> [Code of Conduct](https://github.com/fetch-rewards/swift-mocking/blob/main/CODE_OF_CONDUCT.md).
> 
> Thank you for helping us make this project the best it can be!

- [Homebrew](#homebrew)
- [Code Formatting](#code-formatting)
- [Signed Commits Required](#signed-commits-required)
- [Commit Messages & PR Titles](#commit-messages--pr-titles)
- [Labeling PRs](#labeling-prs)
- [Creating a Release](#creating-a-release)

## Homebrew

This project uses [Homebrew](https://brew.sh) to manage certain dependencies required for development. These
dependencies are defined in the [`Brewfile`](https://github.com/fetch-rewards/swift-mocking/blob/main/Brewfile)
located at the repository's root.

To install these dependencies, use the command line to navigate to the repository’s root and run the following command:
```
brew bundle install
```

## Code Formatting

This project uses [`SwiftFormat`](https://github.com/nicklockwood/SwiftFormat) to maintain consistent code formatting.
We do not currently automate the process of formatting code, but our CI workflow does use `SwiftFormat` as a linter to
validate that all code changes adhere to our formatting rules. Before creating a PR, please run `swiftformat` on all new 
or updated files and commit the changes.

## Signed Commits Required

All contributions to this project must use **signed commits**. This is an important part of our commitment to security, 
authenticity, and trust in the software we maintain. Signed commits prove that a commit actually came from you, not just 
someone who knows your name and email. Without signed commits, it’s possible for malicious actors to impersonate contributors 
and inject malicious code into the project.

> [!IMPORTANT]
> Unsigned commits will be automatically rejected by our CI. If you forget to sign a commit, you can amend and re-push.

To learn more about commit signature verification and to make sure you're using signed commits, please read this
[guide](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification).

Thank you for helping us make the open-source community safer!

## Commit Messages & PR Titles

Descriptive, well-formatted commit messages and PR titles help create a consistent experience for maintainers and
contributors.

**All commits and PR titles should follow these guidelines:**

1. The subject is written using sentence case, not title case, and acronyms are written in all caps:
   ```
   ✅ Make public API changes
   ❌ Make public api changes
   ❌ Make Public API Changes
   ❌ MAKE PUBLIC API CHANGES
   ```
1. The subject is written in the imperative:
   ```
   ✅ Add new file
   ❌ Adds new file
   ❌ Added new file
   ❌ Adding new file
   ```
1. The subject does not end with a period or include unnecessary punctuation:
   ```
   ✅ Refactor networking layer
   ❌ Refactor networking layer.
   ```
1. The subject is ideally 50 characters or less (otherwise, 72 characters or less).
1. The subject is separated from the body with a blank line (critical unless the body is omitted entirely).
1. The subject and body are free of whitespace errors and typos.
1. The body uses proper punctuation and capitalization.
1. The body has a line length of 72 characters or less.

## Labeling PRs

Every PR must have **exactly one** type-of-change label, which determines the section it's grouped under in the
changelog. CI enforces this — a PR with zero or more than one of these labels fails the `PR Labels` check.

A PR often touches several areas — for example, a feature that also adds tests and documentation. Label it for its
**primary purpose**, not the supporting changes (tests, docs, formatting, etc.) it brings along — so a feature that
adds tests and docs is an `enhancement`. When a PR genuinely has two co-equal purposes, use the order below as a
tiebreaker and apply the higher-ranked label. The order (which also matches how the sections appear in the changelog):

1. `enhancement`
1. `bug`
1. `dependencies`
1. `documentation`
1. `testing`
1. `refactoring`
1. `formatting`
1. `ci/cd`
1. `chore`

A PR should have a single primary purpose. If it has two *independent* purposes — for example, a feature and an
unrelated bug fix — split them into separate PRs, stacking them if one depends on the other. A feature that fixes a
pre-existing bug as an inseparable part of its implementation stays a single `enhancement` PR; note the fix in the PR
description so it isn't lost, since the changelog groups the PR under its primary purpose.

> [!NOTE]
> The `breaking changes` label is separate. Apply it **in addition** to the single type-of-change label whenever your
> changes are not backwards compatible; it does not count toward the one-label rule.

## Creating a Release

Releases are created using two [Claude Code](https://claude.ai/code) skills. You will need Claude Code installed to run them.

**Step 1 — Prepare the release**

Run the `/prepare-release` skill. It will:
- Analyze merged PRs since the last release tag and determine the next version
- Update `CHANGELOG.md` and open a documentation PR for review
- Populate the draft GitHub release notes

**Step 2 — Merge the changelog PR**

Review and merge the PR that `/prepare-release` opened. The skill assigns it to you and labels it `documentation`.

**Step 3 — Publish the release**

Once the changelog PR is merged, run the `/publish-release` skill. It will verify that the draft release version matches the changelog entry on `main`, then create the git tag and publish the release.
