# Market Research Report — Buy Me a Coffee SPM

**Date:** 2026-04-13
**Platforms Researched:** iOS, macOS (as a Swift Package library targeting both)

---

## Summary

The concept is a native StoreKit 2-powered "Buy Me a Coffee" Swift Package that presents a
customisable bottom drawer UI, handles consumable IAP purchases, and shows an animated
thank-you screen. Research found three existing libraries in this space — none of them cover
the full feature set you require. The closest (`InAppPurchaseKit`) is subscription-focused
with a tip jar tacked on as a secondary view, while the most thematically similar
(`appcraftconsulting/buymeacoffee`) has been archived and routes through an external service
rather than native StoreKit IAP. Building a custom SPM is the correct call. Both iOS and
macOS are **✅ Go**.

---

## Per-Platform Recommendations

| Platform | Recommendation | Rationale |
|----------|---------------|-----------|
| iOS | ✅ Go | StoreKit 2 consumable IAPs are fully supported; tipping is explicitly allowed under guideline 3.1.1 |
| macOS | ✅ Go | StoreKit 2 works identically on macOS; SwiftUI drawer pattern translates to sheet presentation |

---

## Existing Libraries / Packages Found

| Package | Type | StoreKit | UI | macOS | Status | License | Notes |
|---------|------|----------|----|-------|--------|---------|-------|
| [appcraftconsulting/buymeacoffee](https://github.com/appcraftconsulting/buymeacoffee) | iOS Framework | ❌ External service | UIKit | ❌ | Archived Jul 2024 | Unknown | Routes to buymeacoffee.com, not App Store IAP; SwiftUI support was never finished |
| [dkasaj/SwiftTipJar](https://github.com/dkasaj/SwiftTipJar) | SPM | ⚠️ StoreKit 1 only | None (logic only) | ❌ Unclear | Appears stale | MIT (likely) | No built-in UI; you write your own views; no thank-you screen; no drawer |
| [adamfootdev/InAppPurchaseKit](https://github.com/adamfootdev/InAppPurchaseKit) | SPM | ✅ StoreKit 2 | `TipJarView` (flat view) | ✅ | Active | MIT (likely) | Subscription-first SDK; tip jar is an add-on view, not a drawer; minimal customisation; no animated thank-you; no prefix filtering; no mock support |
| [danielsaidi/StoreKitPlus](https://github.com/danielsaidi/StoreKitPlus) | SPM | ✅ StoreKit 2 | None | ✅ | Active | MIT | General-purpose StoreKit 2 helpers; no tip-jar UI at all |
| [russell-archer/StoreHelper](https://github.com/russell-archer/StoreHelper) | SPM | ✅ StoreKit 2 | Generic product views | ✅ | Stale (iOS 15–17 era) | MIT | Full-featured IAP library; no tipping-specific UI; overkill for this use case |

---

## Market Assessment

### iOS
**Saturation level:** Low
**Top competitor quality:** Weak to Moderate
**User complaints in existing solutions:**
- `appcraftconsulting/buymeacoffee` — archived, external service dependency, no StoreKit IAP, UIKit only
- `SwiftTipJar` — no UI, StoreKit 1 only, appears unmaintained
- `InAppPurchaseKit` tip jar — plain flat view, not a drawer, subscription-focused library, no customisation of branding/copy

**Evidence of demand:**
- Multiple blog posts and tutorials (Ben Cardy, Superwall, Hacking with Swift) demonstrate that indie developers frequently implement tip jars manually because no complete, well-maintained library exists
- GitHub discussions and issues on existing packages show consistent demand for SwiftUI-native, customisable tip UI
- Apple's explicit allowance in guideline 3.1.1 makes this a low-risk, common pattern for indie apps

### macOS
**Saturation level:** Very Low
**Top competitor quality:** Weak
**User complaints:** Most tip jar solutions are iOS-only; macOS is almost entirely ignored in this space
**Evidence of demand:** Indie macOS developers (e.g. `SwiftTipJar` author built it for a macOS menu bar app) clearly want this but have no clean library to reach for

---

## Differentiation Opportunities

The gap across both platforms is the combination of:

1. **StoreKit 2 native** — All serious alternatives either use StoreKit 1 or external services
2. **Product prefix filtering** — No existing library offers a way to scope IAP product fetching by prefix, which is essential when an app has mixed IAP types
3. **Complete UI package** — No existing library provides a bottom drawer with configurable header, description, product list, and animated thank-you screen in one cohesive unit
4. **Trigger-agnostic presentation** — Existing solutions couple the view to a specific button or entry point; a modifier/environment approach lets any caller trigger the drawer
5. **Mock support** — No library offers a built-in mock/preview mode for design-time and testing workflows
6. **Snapshot + Unit test coverage** — No existing library ships with this level of test infrastructure

---

## Risks

| Risk | Severity | Notes |
|------|----------|-------|
| App Store guideline change | Low | Guideline 3.1.1 explicitly allows tipping; Apple has not shown intent to remove this. Ensure products are clearly labelled as tips/support, not unlocking features. |
| StoreKit sandbox instability | Low | Sandbox environment can be unreliable; mock mode mitigates this during development |
| macOS sheet presentation differences | Low | SwiftUI sheets behave differently on macOS (appear as floating windows by default); may need platform-conditional presentation logic |
| Product ID prefix collisions | Low | Document the prefix convention clearly; risk is only developer error, not platform |
| Snapshot test fragility | Medium | Snapshot tests are sensitive to OS version, device size, and font rendering — pin snapshot tests to a specific simulator/OS to avoid false failures |
| Private-only scope | None | No App Store submission risk for the library itself; risks only apply to host apps |

---

## Detailed Recommendations

### iOS
**Decision:** ✅ Go
**Rationale:** Native StoreKit 2 consumable IAP is mature, well-documented, and fully supported. Apple explicitly permits tipping via IAP under guideline 3.1.1. No existing library delivers a complete, customisable, SwiftUI-native drawer experience. The gap is real and addressable.

### macOS
**Decision:** ✅ Go
**Rationale:** StoreKit 2 is identical on macOS and SwiftUI sheets are supported, though they present as floating windows by default rather than bottom drawers. A small platform-conditional layout adjustment (e.g. `presentationDetents` on iOS, standard `.sheet` on macOS) handles this cleanly. This is a minor implementation detail, not a blocker.
