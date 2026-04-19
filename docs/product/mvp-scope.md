# MVP Scope — BuyMeCoffee

**Version:** 1.0  
**Date:** 2026-04-13  
**Author:** Product Owner  
**Status:** Approved

---

## Vision

A SwiftUI-native "Buy Me a Coffee" bottom drawer powered by StoreKit 2. A private Swift
Package that any iOS or macOS app can drop in to offer consumable tip IAPs without writing
boilerplate StoreKit 2 code or custom UI.

---

## Problem Statement

Indie Swift developers who want to add a "tip jar" to their iOS or macOS app must either
implement StoreKit 2 purchase flows and custom SwiftUI UI from scratch, or accept one of the
existing open-source libraries — all of which are archived, StoreKit-1-only, UI-less, or
subscription-focused. No complete, maintained, SwiftUI-native, StoreKit-2-powered tip-jar
library exists. This forces developers to re-implement the same pattern repeatedly across
projects.

---

## Target User

| Attribute | Detail |
|-----------|--------|
| Primary persona | Solo Swift developer maintaining one or more iOS / macOS apps |
| Platform | iOS + macOS |
| Technical proficiency | High — comfortable with SPM, StoreKit IAP configuration, and SwiftUI |
| Key pain point | No ready-made, native StoreKit 2 tip-jar drawer exists; rolling one from scratch takes significant time and testing overhead |
| Motivation to use this library | Drop-in integration: configure product-ID prefix, add a view modifier, done |

---

## Value Proposition

BuyMeCoffee is the only Swift Package that combines all of the following in a single,
dependency-free unit:

- **StoreKit 2 native** — no StoreKit 1 wrappers, no external services, no server required
- **Complete drawer UI** — bottom sheet (iOS) and floating sheet (macOS) with configurable header, product list, and animated thank-you screen
- **Explicit product ID configuration** — scope IAP product fetching by passing exact product IDs; no conflicts with subscription or unlock products in the same app
- **Trigger-agnostic** — present the drawer from any view via a SwiftUI modifier or environment, not a bespoke button
- **Built-in mock mode** — design and test without live StoreKit calls; works in Xcode Previews and CI
- **Full test coverage** — snapshot tests for all views, unit tests for purchase logic; ships with CI configuration

---

## MVP Goals

1. Any iOS or macOS app can present the tip drawer with fewer than 10 lines of integration code.
2. All tests pass in CI (snapshot + unit) on every commit.
3. Successfully receives at least one real StoreKit tip after being integrated into a production app.

---

## Success Metrics

| Metric | Target | Timeframe |
|--------|--------|-----------|
| First real tip received in a production app | ≥ 1 tip | Within 30 days of integration into first app |
| CI pipeline green on first integration | 100% pass rate | At v1.0 cut |
| Integration effort | ≤ 10 lines of code in host app | At v1.0 cut |

---

## In Scope (MVP)

**Core UI**
- [ ] `BuyMeCoffeeView` presents as a bottom sheet on iOS (using `presentationDetents`) and a floating sheet on macOS
- [ ] Sheet has a configurable header: icon image, title string, and subtitle/description string
- [ ] Product list is populated from StoreKit 2 by a developer-supplied product-ID prefix string
- [ ] Each product row displays the localised product name, localised description, and localised price
- [ ] Tapping a product row initiates a StoreKit 2 `Product.purchase()` flow
- [ ] An animated thank-you screen is shown on successful purchase completion
- [ ] The sheet can be dismissed by the user at any point

**Presentation API**
- [ ] A SwiftUI view modifier (e.g. `.buyMeCoffee(isPresented:)`) triggers sheet presentation from any view
- [ ] Presentation state is managed via the SwiftUI environment so any descendant can trigger the drawer

**StoreKit Integration**
- [ ] Products are fetched via `Product.products(for:)` filtered to IDs matching the supplied prefix
- [ ] Purchase transactions are handled and finished via StoreKit 2 (`Transaction.finish()`)
- [ ] Purchase errors (cancelled, failed, pending) are handled gracefully without crashing; user-facing error states shown where appropriate

**Theming**
- [ ] A `BuyMeCoffeeTheme` type (or equivalent) defines all visual tokens: background colour, primary text colour, secondary text colour, accent/button colour, and product row background colour
- [ ] A built-in default theme uses a dark-mode style (dark background, light text) regardless of the system appearance setting
- [ ] The host app can supply a fully custom theme by constructing a `BuyMeCoffeeTheme` with their own colour values
- [ ] The theme is passed at the call site (view modifier or initialiser) so different drawers in the same app can use different themes

**Mock / Preview Mode**
- [ ] A built-in mock product provider can be injected to replace live StoreKit calls in Xcode Previews and unit tests
- [ ] Mock mode requires no App Store Connect configuration

**Testing**
- [ ] Snapshot tests cover: empty state, loaded product list, thank-you screen (iOS and macOS)
- [ ] Unit tests cover: product fetching with prefix filter, purchase success path, purchase error paths, mock provider

**CI**
- [ ] GitHub Actions workflow runs the full test suite on every push to `main` and on every pull request
- [ ] CI badge added to repository README

**Documentation**
- [ ] README documents: SPM integration steps, product-ID prefix convention, view modifier usage, mock mode usage, and CI badge

---

## Out of Scope (Post-MVP)

- Subscription IAP products
- Non-consumable IAP products (one-time unlocks)
- watchOS and tvOS support
- Analytics or purchase-event callbacks/hooks
- Server-side receipt validation (StoreKit 2 on-device verification is sufficient for tips; no server callback hook needed)
- Localisation of library-internal strings beyond what StoreKit provides
- Public GitHub repo / open-source release

---

## Constraints

| Constraint | Detail |
|------------|--------|
| Timeline | ASAP — no hard deadline, but integration into a production app is the near-term goal |
| Platform | iOS 17+ and macOS 14+ (minimum versions aligning with iOS 17 / Sonoma release cycle) |
| Monetisation | N/A — private library, no direct monetisation |
| Dependencies | Zero third-party dependencies; StoreKit and SwiftUI only |
| Repository | Private GitHub repo under `LooseMarek/BuyMeCoffee` |
| Known risks | Snapshot test fragility across OS versions (pin tests to a specific simulator/OS); StoreKit sandbox instability (mock mode mitigates during development); macOS sheet presentation differences (platform-conditional layout required) |

---

## Open Questions

All open questions resolved. No blockers for architecture planning.

---

## Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Product Owner | Marek Loose | 2026-04-13 | Approved |
| Architect | — | — | Pending |

---

## v1.1 Addendum

**Date:** 2026-04-19
**Status:** Planned

### Changes from Production Testing

After integration into a production app, several improvements have been identified and are being implemented in v1.1:

#### 1. **productIDs API Change (Breaking)**
- **Change:** Replace `productIDPrefix: String` with `productIDs: [String]` in all public APIs
- **Reason:** StoreKit 2 requires the full set of product IDs upfront; prefix filtering was leaking implementation detail into the public API and causing the view modifier to pass an empty array to the provider
- **Impact:** Breaking change — consumers must update their integration code to pass explicit product ID arrays

#### 2. **Per-Screen Label Customisation**
- **Change:** Introduce four optional label objects: `DrawerHeaderLabels`, `EmptyStateLabels`, `ErrorStateLabels`, `ThankYouLabels`
- **Reason:** The view modifier previously exposed no label customisation; consumers who wanted custom text had to use `BuyMeCoffeeView` directly
- **Impact:** Non-breaking — all label objects default to `nil` (use SPM defaults)

#### 3. **MockProductProvider Access Change**
- **Change:** `MockProductProvider` is now `internal` instead of `public`
- **Reason:** Consumers should use `.storekit` configuration files for local testing, not a public mock type
- **Impact:** Non-breaking for most consumers (mock was primarily used internally); consumers relying on the public mock must migrate to `.storekit` files

#### 4. **Dynamic Drawer Height (iOS)**
- **Change:** All drawer states now size to their content instead of filling the full screen
  - Loading, empty, error, thank-you states: sized to content with vertical padding
  - Loaded state: static layout for small product counts; scrollable when product list exceeds half the screen height
- **Reason:** Full-screen sheets felt oversized for states with minimal content
- **Impact:** Visual change only — no API changes

#### 5. **macOS Popup Improvements**
- **Change:** 
  - Outside-click dismissal: clicking outside the popup now dismisses it (previously Esc-only)
  - Thank-you page sizing: popup expands to show the full thank-you content after purchase
- **Reason:** Better alignment with standard macOS sheet behaviour
- **Impact:** UX improvement only — no API changes

---

## v1.1 Success Metrics

| Metric | Target | Timeframe |
|--------|--------|-----------|
| Zero `productIDPrefix` references in host app code | 100% migration | At v1.1 cut |
| Label customisation adoption | ≥ 1 host app uses custom labels | Within 14 days of v1.1 release |
| Dynamic drawer height approval | Qualitative: "feels better" feedback from host app integration | At v1.1 cut |
