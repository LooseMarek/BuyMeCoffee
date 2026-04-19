# ADR-001 — Protocol-Driven Provider Architecture

**Date:** 2026-04-14
**Status:** Accepted
**Author:** Architect
**Deciders:** Marek Loose

---

## Context

BuyMeCoffee must support two operational modes:

1. **Live mode** — fetches real products from App Store Connect via StoreKit 2 and processes real purchases.
2. **Mock/Preview mode** — returns hardcoded products and simulates purchase outcomes without any StoreKit calls; required for Xcode Previews, unit tests, and CI runs where no StoreKit sandbox is available.

The architecture needs to make this switch zero-friction for both the library consumer (they inject the provider at the call site) and for internal tests (they construct the view with a `MockProductProvider` directly).

---

## Decision

Introduce a `ProductProvider` protocol as the single abstraction over all product-fetching and purchasing behaviour. Two concrete implementations ship with the library:

- `StoreKitProductProvider` — wraps `Product.products(for:)` and `Product.purchase()` from StoreKit 2.
- `MockProductProvider` — returns a developer-configurable list of `TipProduct` values and simulates purchase outcomes; lives in the main module (not a test-only target) so host-app Previews can use it without importing a separate test product.

`BuyMeCoffeeView` accepts a `ProductProvider` parameter that defaults to `StoreKitProductProvider`, so live usage requires no extra configuration.

---

## Options Considered

### Option 1: Protocol-driven provider (chosen)

**Description:** Define `ProductProvider` as a protocol; ship `StoreKitProductProvider` and `MockProductProvider` as concrete types in the main module.

**Pros:**
- Clean separation between StoreKit and SwiftUI layers
- Mock mode requires no `#if DEBUG` or conditional compilation — just pass a different type
- Host apps can write their own provider (e.g. a custom analytics-logging wrapper)
- Unit tests are fast and deterministic — no StoreKit sandbox needed

**Cons:**
- Slightly more types to maintain than a single class with a `isMock` flag
- `MockProductProvider` ships in the production binary (small size cost)

---

### Option 2: `isMock` flag on a single class

**Description:** A single `ProductProvider` class with an `isMock: Bool` property that switches between real and fake behaviour internally.

**Pros:**
- Fewer types

**Cons:**
- `#if DEBUG` or runtime branching pollutes production code paths
- Not extensible — host apps cannot supply their own alternate behaviour
- Harder to test in isolation

---

### Option 3: Separate `BuyMeCoffeeTestHelpers` SPM target for mock

**Description:** `MockProductProvider` lives in a separate SPM test-support product, not the main module.

**Pros:**
- Keeps the main binary smaller

**Cons:**
- Host apps cannot use `MockProductProvider` in their Xcode Previews without adding a separate import
- Complicates the integration story (two products to declare in Package.swift)

---

## Rationale

Option 1 gives the cleanest separation of concerns and the best ergonomics for both internal tests and host-app Previews. The binary size cost of shipping `MockProductProvider` in production is negligible (a few hundred bytes of Swift structs). The protocol boundary also makes it straightforward for advanced consumers to wrap the provider with analytics callbacks — a Post-MVP feature that is free by design.

---

## Consequences

**Positive:**
- All unit tests and snapshot tests run without a StoreKit sandbox or Apple credentials.
- CI is fully self-contained — no provisioning required.
- Host apps get mock support in Previews for free, with no extra SPM dependency.

**Negative / Trade-offs:**
- `MockProductProvider` is compiled into the release binary of host apps (minor size impact).
- Any future change to the `ProductProvider` protocol is a breaking API change for consumers who have implemented their own conformance.

**Risks:**
- If StoreKit 2 API surface changes significantly in a future OS version, only `StoreKitProductProvider` needs updating — the protocol boundary isolates the blast radius.

---

## Related

| Type | Reference |
|------|-----------|
| Supersedes | — |
| Related ADRs | ADR-003 (zero runtime dependencies), ADR-004 (explicit product IDs over prefix filtering) |
| Related issues | — |

---

## v1.1 Update — MockProductProvider Access Change

**Date:** 2026-04-19
**Decision:** `MockProductProvider` access level changed from `public` to `internal`

**Rationale:** The original decision shipped `MockProductProvider` as public to enable host-app Previews. In practice, consumers should use `.storekit` configuration files (set in the Xcode scheme's StoreKit Configuration setting) for local testing — this provides real StoreKit sandbox behaviour without needing a library-provided mock. Keeping the mock internal simplifies the public API surface and encourages best-practice local testing.

**Impact:** `MockProductProvider` remains available to the library's own Previews and tests (same module). Consumers who previously used `MockProductProvider` in their Previews must migrate to `.storekit` files.
