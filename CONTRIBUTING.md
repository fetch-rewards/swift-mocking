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

- [Signed Commits Required](#signed-commits-required)
- [Commit Messages & PR Titles](#commit-messages--pr-titles)

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
1. The subject is separated from the body with a blank line (critical unless the body is ommitted entirely).
1. The subject and body are free of whitespace errors and typos.
1. The body uses proper punctuation and capitalization.
1. The body has a line length of 72 characters or less.
