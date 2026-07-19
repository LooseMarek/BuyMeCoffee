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
├── docs/                       # Architecture, ADRs, product, and design docs
└── Sources/BuyMeCoffee/
    ├── BuyMeCoffeeView.swift        # Public sheet/drawer entry point
    ├── BuyMeCoffeeInlineView.swift  # Public embeddable tip list (no sheet chrome)
    ├── API/                    # Protocols & shared contracts (ProductProvider, PurchaseError)
    ├── Models/                 # Value types (TipProduct, label configs)
    ├── Providers/              # ProductProvider implementations (StoreKit, Mock)
    ├── Theme/                  # Theming (BuyMeCoffeeTheme, environment keys)
    ├── ViewModels/             # Shared, presentation-agnostic view models (TipListViewModel)
    └── Views/                  # SwiftUI views
```

> Add component folders here as they are created.
>
> **Public API surface:** `BuyMeCoffeeView` (sheet/drawer presentation) and
> `BuyMeCoffeeInlineView` (embeddable tip list for host layouts — no sheet/modal chrome). Both
> are backed by the shared `TipListViewModel` and take the same `provider` / `productIDs` /
> `sortOrder` inputs.
>
> **Shared view models live in `ViewModels/`.** Product-fetch/purchase logic belongs in a
> presentation-agnostic `ObservableObject` here (e.g. `TipListViewModel`) so multiple views can
> reuse it. Keep such view models module-**internal** (not `public`) — they are shared building
> blocks for views in this package, not part of the host-app-facing API surface. Test injection
> into a `public` view is done via a separate internal initializer overload reachable through
> `@testable import`, not by making the view model `public` (Swift forbids a public initializer
> from exposing a less-visible type).

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

**Snapshot reference filenames must be globally unique across ALL snapshot test classes.** SPM copies every reference `.png` into a single flat resource bundle for the `BuyMeCoffeeSnapshotTests` target, keyed by basename (`<testMethodName>.<named>.png`) — regardless of the `__Snapshots__/<ClassName>/` subdirectory it lives in. Two classes with the same method name AND the same `named:` value produce colliding basenames and fail package resolution with `multiple resources named '…png'` before any test runs. When a new test class needs a state another class already snapshots (e.g. inline vs. drawer both covering `thankYou`/`empty`/`error`), give the `named:` value a class-specific prefix (e.g. `inlineThankYouState-iOS` vs. the drawer's `thankYouState-iOS`) so the basenames differ.

**Snapshots compare exactly — no `perceptualPrecision` override.** CI and local
development both run on the same Apple Silicon (arm64) Mac mini, so there is no
architecture-driven rendering delta to absorb. Use plain `.image`:
```swift
assertSnapshot(of: hostingView, as: .image, named: "customTheme-macOS")
```

**No remaining restriction on `LinearGradient`, `.cornerRadius()`, or `Text` in
snapshot views.** Those were avoided specifically to dodge Intel-vs-Apple-Silicon GPU
rendering differences, which no longer apply now that CI and local dev share the same
architecture.

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

## Fastlane & Ruby

**Use Homebrew Ruby, not system Ruby.** macOS ships Ruby 2.6 at `/usr/bin/ruby`, which is incompatible with the project's `Gemfile.lock`. Always use `/opt/homebrew/opt/ruby/bin/bundle` (or ensure Homebrew Ruby is first on `PATH`):
```
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
```

**xcpretty is disabled (`xcodebuild_formatter: ""`).** xcpretty 0.4.1 is incompatible with Ruby 4.0 (`Gem::Resolver::APISet::GemParser` was removed from RubyGems). The Fastfile disables it so both lanes work. Do not re-enable xcpretty unless a compatible version is available.

---

## Environment & Secrets

**Secret Management:** GitHub Secrets for CI/CD, `.env` files locally (not committed)
