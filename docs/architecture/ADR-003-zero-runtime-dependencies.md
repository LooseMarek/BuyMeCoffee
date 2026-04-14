# ADR-003 — Zero Runtime Dependencies

**Date:** 2026-04-14
**Status:** Accepted
**Author:** Architect
**Deciders:** Marek Loose

---

## Context

BuyMeCoffee is a drop-in Swift Package intended to be added to any iOS or macOS app with minimal friction. Every dependency the library declares becomes a transitive dependency for every host app that adopts it. Dependencies carry costs: binary size, license obligations, version-conflict risk, and ongoing maintenance overhead when the dependency releases breaking changes.

The library's feature set — a SwiftUI bottom drawer that calls StoreKit 2 — is fully achievable using Apple's first-party frameworks alone.

---

## Decision

BuyMeCoffee's production source (`Sources/BuyMeCoffee/`) has zero third-party dependencies. Only Apple-provided frameworks (`SwiftUI`, `StoreKit`) are imported. The test target (`Tests/BuyMeCoffeeTests/`) may declare test-only dependencies; `swift-snapshot-testing` is the sole approved test dependency.

---

## Options Considered

### Option 1: Zero runtime dependencies (chosen)

**Description:** Production source uses only SwiftUI and StoreKit 2. Test target adds `swift-snapshot-testing` as a test-only dependency declared in Package.swift under `.testTarget(dependencies:)`.

**Pros:**
- No transitive dependencies imposed on host apps
- No license compliance burden beyond Apple's frameworks
- No SPM version-conflict surface area
- Binary size impact is zero

**Cons:**
- Some utility code (e.g. async helpers, colour extensions) must be written by hand rather than pulled from a utility package

---

### Option 2: Use a lightweight utility library (e.g. `swift-extensions`)

**Description:** Pull in a small utility SPM package for common Swift/SwiftUI extensions.

**Pros:**
- Reduces boilerplate

**Cons:**
- Forces every host app to resolve and compile an additional dependency
- Adds version-conflict risk in host apps that may already depend on the same library at a different version
- Not justified given the small size of this library's utility needs

---

## Rationale

The zero-dependency constraint was identified during product scoping as a differentiator from existing libraries (`InAppPurchaseKit` pulls in its own dependencies; `StoreHelper` is over-engineered for this use case). Maintaining this constraint keeps the integration story clean: `swift package add` and done. The only concession is `swift-snapshot-testing` in the test target, which does not affect host apps.

---

## Consequences

**Positive:**
- Host apps see no new transitive dependencies when adding BuyMeCoffee.
- No SPM resolution conflicts.
- CI has no external network dependencies beyond Apple's own packages.

**Negative / Trade-offs:**
- Any utility code needed (e.g. `Color` hex initialiser, async test helpers) must be implemented inline.

**Risks:**
- If `swift-snapshot-testing` releases a breaking major version, the test target must be updated. This does not affect host apps or the public API.

---

## Related

| Type | Reference |
|------|-----------|
| Supersedes | — |
| Related ADRs | ADR-001 (protocol-driven architecture) |
| Related issues | — |
