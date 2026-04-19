# Architecture Plan — BuyMeCoffee

**Date:** 2026-04-14
**Based on:** MVP Scope v1.0

---

## Project Identity

- **Name:** BuyMeCoffee
- **Platforms:** SPM — iOS 17.0+, macOS 14.0+
- **Scale:** Solo side project

---

## Component Structure

| Folder | Purpose |
|--------|---------|
| `Sources/BuyMeCoffee/` | Library source — views, view modifiers, StoreKit integration, theming, providers |
| `Tests/BuyMeCoffeeTests/` | Unit tests and snapshot tests |
| `docs/` | Documentation, ADRs, design specs |

---

## Tech Stack

| Component | Stack | Architecture Pattern |
|-----------|-------|---------------------|
| `Sources/BuyMeCoffee/` | Swift 5.9, SwiftUI, StoreKit 2 | Protocol-driven providers (see ADR-001) |
| `Tests/BuyMeCoffeeTests/` | XCTest, swift-snapshot-testing (test-only) | — |

---

## Internal Architecture

The library is structured around a protocol-driven provider pattern:

```
BuyMeCoffee (module)
├── API
│   ├── BuyMeCoffeeView              # Main drawer view (entry point)
│   ├── buyMeCoffee(isPresented:)    # SwiftUI view modifier
│   ├── BuyMeCoffeeTheme             # Visual token type
│   ├── BuyMeCoffeeEnvironmentKey    # Environment key for trigger-agnostic presentation
│   ├── DrawerHeaderLabels           # Per-screen label object: header icon, title, subtitle
│   ├── EmptyStateLabels             # Per-screen label object: empty state icon, headline, body
│   ├── ErrorStateLabels             # Per-screen label object: error state icon, headline
│   └── ThankYouLabels               # Per-screen label object: thank-you title, subtitle, icon, accessibility
├── Providers
│   ├── ProductProvider              # Protocol: fetch products + purchase
│   ├── StoreKitProductProvider      # Concrete: wraps StoreKit 2 Product/Transaction APIs
│   └── MockProductProvider          # Concrete (internal-only): returns hardcoded mock products for Previews + tests
├── Models
│   └── TipProduct                   # Value type wrapping StoreKit Product data
└── Views (internal)
    ├── ProductRowView
    ├── ThankYouView
    ├── DrawerHeaderView
    ├── EmptyStateView
    └── ErrorStateView
```

`BuyMeCoffeeView` accepts a `ProductProvider` at its call site (defaulting to `StoreKitProductProvider`) and optional label customisation objects (`DrawerHeaderLabels`, `EmptyStateLabels`, `ErrorStateLabels`, `ThankYouLabels`). Injecting `MockProductProvider` replaces all StoreKit calls — no conditional compilation required. `MockProductProvider` is internal-only (v1.1+); consumers should use `.storekit` files for local testing.

---

## Testing Strategy

| Component | Enabled Test Types | Build Target (local + CI) |
|-----------|--------------------|--------------------------|
| `Sources/BuyMeCoffee/` | Unit Tests, Snapshot Tests | `platform=iOS Simulator,name=iPhone 17 Pro` |

**Snapshot targets (iOS):** empty state, loaded product list, thank-you screen.
**Unit targets:** product prefix filtering, purchase success path, purchase error paths, mock provider behaviour.
**Snapshot pinning:** snapshots must be recorded and diffed against a fixed simulator/OS to avoid false failures on OS upgrades.

---

## Third-Party Dependencies

| Category | Tool | Scope | Notes |
|----------|------|-------|-------|
| Snapshot testing | swift-snapshot-testing 1.19.2 | Test-only | pointfreeco/swift-snapshot-testing |
| All others | None | — | Zero runtime dependencies by design (see ADR-003) |

---

## Infrastructure

| Item | Decision | Details |
|------|----------|---------|
| GitHub Project | Yes | Views: Roadmap, Board, Backlog |
| GitHub Actions CI | Yes | Push to `main`, PRs, manual trigger (`workflow_dispatch`) |
| Fastlane | Yes | `mac test` lane — runs `swift test`; no Apple credentials required |
| API Hosting | N/A | No backend |
| Promo Web Hosting | N/A | SPM project — no promo website |

### Fastlane Details

| Field | Value |
|-------|-------|
| Lane | `mac test` |
| Command | `swift test` |
| Apple credentials | Not required (SPM only) |

---

## ADRs

| # | Title | Decision |
|---|-------|----------|
| ADR-001 | Protocol-Driven Provider Architecture | `ProductProvider` protocol decouples StoreKit from views; enables mock/preview mode without conditional compilation |
| ADR-002 | iOS Simulator as Universal Test Build Target | All tests (unit + snapshot) run on `platform=iOS Simulator,name=iPhone 17 Pro` for rendering consistency |
| ADR-003 | Zero Runtime Dependencies | No third-party packages in production code; `swift-snapshot-testing` is test-only |

---

## Notes

- The library must use `#if os(iOS)` / `#if os(macOS)` conditionals for platform-specific sheet presentation (`presentationDetents` on iOS; standard `.sheet` on macOS).
- Snapshot tests are sensitive to OS/simulator version. Snapshots must be committed and regenerated intentionally — never auto-accepted in CI.
- **v1.1:** `MockProductProvider` is `internal`-only; consumers use `.storekit` files for local testing. The mock remains in the main module for internal Previews and tests.
- **v1.1:** `ProductProvider.fetchProducts(productIDs:)` accepts `[String]` directly (no prefix filtering); StoreKit 2 requires the full ID set upfront. `StoreKitProductProvider` passes IDs directly to `Product.products(for:)`.
- **v1.1:** iOS drawer states size to their content. Loading, empty, error, and thank-you states use vertical padding instead of filling the full screen. Loaded state uses a static layout for small product counts and scrolls when the product list exceeds half the screen height.
- **v1.1:** macOS popup dismisses on outside-click (not Esc-only). After purchase, the popup expands to show the full thank-you content without clipping.
