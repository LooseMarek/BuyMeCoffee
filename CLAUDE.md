# CLAUDE.md — BuyMeCoffee

> This file is the source of truth for all agents working on this project.
> It defines the tech stack, conventions, repo structure, and agent context.
> All agents must read this file before starting any task.

---

## Project Overview

A SwiftUI-native StoreKit 2 tip-jar Swift Package that any iOS or macOS app can drop in to present a configurable 'Buy Me a Coffee' bottom drawer with zero boilerplate.

---

## Platforms & Tech Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| SPM | Swift 6.2, SPM | iOS 17.0, macOS 14.0 |

---

## Repository Structure

```
BuyMeCoffee/
├── docs/               # Architecture, ADRs, product, and design docs
```

> Add component folders here as they are created.

---

## Architecture

**Pattern:** See `./docs/architecture/`

**Key ADRs:** See `./docs/architecture/`

---

## Coding Conventions

### General
- Follow language-idiomatic style for each component
- Keep functions small and focused

### Git
**Branch Naming:** `{type}/{issue-number}-{short-description}`
**Commit Style:** Conventional Commits (`feat:`, `fix:`, `test:`, `chore:`, etc.)
**Merge Strategy:** Always use **rebase and merge** when merging PRs into `main` to keep a flat, linear history. Do not use merge commits or squash.
**CI gate:** Always wait for CI to pass on the PR before merging into `main`. Never merge a branch with a failing or in-progress CI run.

---

## Testing Conventions

**Approach:** TDD — write failing tests before implementing

| Component | Test Types |
|-----------|-----------|
| SPM | Unit, Snapshot |

### Snapshot Testing

**Always provide snapshots for both platforms.** Every snapshot test must cover iOS (`UIHostingController`) and macOS (`NSHostingView`) — CI runs separate pipelines for each via `fastlane ios test` and `fastlane mac test`.

**macOS snapshots require `perceptualPrecision: 0.95`.** The CI runner is an Intel MacBook Pro (2018) while development happens on Apple Silicon. Even identical solid-colour views produce a sub-perceptual colour delta between the two due to display colour-space differences. Use:
```swift
assertSnapshot(of: hostingView, as: .image(perceptualPrecision: 0.95), named: "customTheme-macOS")
```

**iOS snapshots require `perceptualPrecision: 0.98`.** The CI runner is self-hosted and may run a different iOS simulator version than the local machine. Minor differences in SF Symbol rendering, text antialiasing, or colour profiles between iOS versions cause exact-match failures. Use:
```swift
assertSnapshot(of: hostingController.view, as: .image(perceptualPrecision: 0.98), named: "customTheme-iOS")
```

**Design snapshot test views to be cross-architecture stable.** Prefer solid `Rectangle().fill(color)` blocks over elements that involve hardware-specific rendering:
- No `LinearGradient` — Metal interpolates gradients differently on Intel vs Apple Silicon.
- No `.cornerRadius()` — GPU anti-aliasing at rounded edges differs between architectures.
- No `Text` — subpixel antialiasing is present on Intel but absent on Apple Silicon.

**Record snapshot references locally via Fastlane, not `swift test`.** `swift test` renders macOS views using the display's backing scale (2× Retina locally, 1× headless), causing scale mismatches on CI. Always record with:
```
bundle exec fastlane mac test   # records at 2× via xcodebuild, matching CI
bundle exec fastlane ios test   # records against the configured simulator
```
Run once to auto-record (test fails), then run again to confirm (test passes), then commit the reference images.

**Commit reference images alongside the test code.** Never push a snapshot test without its reference `.png` files — CI has no way to auto-commit them back to the repo.

---

## Living Document

**Every task that encounters a non-obvious problem with a clear solution must update this file.** If an agent hits a recurring pitfall — a build configuration quirk, a platform gotcha, a tooling workaround — and identifies a definitive fix, add a concise note to the relevant section before closing the PR. This prevents future agents from re-discovering the same issues.

---

## Environment & Secrets

**Secret Management:** GitHub Secrets for CI/CD, `.env` files locally (not committed)
