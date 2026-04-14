# ADR-002 — iOS Simulator as Universal Test Build Target

**Date:** 2026-04-14
**Status:** Accepted
**Author:** Architect
**Deciders:** Marek Loose

---

## Context

BuyMeCoffee is a dual-platform SPM library (iOS 17+ and macOS 14+). The default SPM test target is `platform=macOS` — tests run directly on the host machine without a simulator.

However, the library includes snapshot tests covering SwiftUI views rendered as iOS bottom sheets. Snapshot tests are inherently pixel-bound: the rendered output depends on the rendering engine, font metrics, and display scale. iOS and macOS render SwiftUI differently. If snapshots are recorded on macOS but the library's primary UI is an iOS bottom drawer, the snapshots do not represent the real user-facing output.

A single, consistent build target must be chosen for both unit tests and snapshot tests so that local development and CI always produce identical results.

---

## Decision

Use `platform=iOS Simulator,name=iPhone 17 Pro` as the build and test destination for **all** test runs — both unit tests and snapshot tests — in both local development and CI.

---

## Options Considered

### Option 1: iOS Simulator for all tests (chosen)

**Description:** Run `xcodebuild test` (or `swift test` via Fastlane with a destination override) targeting `platform=iOS Simulator,name=iPhone 17 Pro` for every test invocation.

**Pros:**
- Snapshot images represent real iOS rendering — accurate to the primary UI surface
- Unit tests and snapshot tests share a single target — no split test runs
- CI configuration is simple: one destination, one matrix entry

**Cons:**
- Requires a macOS runner with Xcode and iOS Simulator toolchain (standard on GitHub Actions `macos-latest`)
- Slightly slower than native macOS tests (simulator boot overhead ~10–20 s)
- macOS-specific view variants (floating sheet) are not snapshot-tested via this target

---

### Option 2: macOS for unit tests, iOS Simulator for snapshot tests

**Description:** Run two separate test phases: `platform=macOS` for unit tests, `platform=iOS Simulator` for snapshot tests.

**Pros:**
- Unit tests run at native speed

**Cons:**
- Two separate CI jobs / test phases — more configuration to maintain
- Risk of divergence between local and CI runs if a developer only runs one phase
- Adds complexity with no meaningful speed benefit (unit tests are fast regardless)

---

### Option 3: macOS only (`platform=macOS`)

**Description:** Use the default SPM test destination for all tests.

**Pros:**
- Fastest — no simulator overhead
- Simplest CI configuration

**Cons:**
- Snapshot images do not reflect iOS rendering (font metrics, sheet chrome, and UIKit-backed rendering differ from AppKit/macOS)
- Snapshots recorded in macOS CI will produce false failures when run on a developer's iOS Simulator, and vice versa

---

## Rationale

The library's primary UI is an iOS bottom drawer. Snapshot fidelity on iOS is more important than the marginal speed gain of native macOS tests. A single consistent target eliminates the entire class of "snapshots differ between local and CI" failures. Option 2 adds configuration overhead without a meaningful benefit given the small size of the test suite.

---

## Consequences

**Positive:**
- Snapshot images are always recorded and diffed against iOS Simulator rendering — no cross-platform rendering divergence.
- One CI job covers the full test suite.
- Developers and CI always run the same destination.

**Negative / Trade-offs:**
- macOS view variants (floating sheet UI) are covered by unit tests but not snapshot tests — acceptable for v1.0.
- Simulator must be pre-booted or will add ~15 s to the first CI run.

**Risks:**
- If Apple renames the simulator (e.g. "iPhone 18 Pro" replaces "iPhone 17 Pro"), the destination string must be updated in CI and Fastlane configuration.

---

## Related

| Type | Reference |
|------|-----------|
| Supersedes | — |
| Related ADRs | — |
| Related issues | — |
