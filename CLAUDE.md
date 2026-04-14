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

---

## Testing Conventions

**Approach:** TDD — write failing tests before implementing

| Component | Test Types |
|-----------|-----------|
| SPM | Unit, Snapshot |

---

## Environment & Secrets

**Secret Management:** GitHub Secrets for CI/CD, `.env` files locally (not committed)
