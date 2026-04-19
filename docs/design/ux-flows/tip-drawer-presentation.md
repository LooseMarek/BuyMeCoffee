# UX Flow — Tip Drawer Presentation

**Version:** 1.0
**Date:** 2026-04-16
**Status:** Approved

---

## Flow Identity

| Field | Value |
|-------|-------|
| Flow name | Tip Drawer Presentation |
| Entry points | Host app calls `.buyMeCoffee(isPresented:productIDs:)` on any view (v1.1: explicit product IDs); or sets `BuyMeCoffeeEnvironmentKey` to `true` from a descendant |
| Exit points | User dismisses sheet (swipe down / close button / tap outside on macOS — v1.1); purchase completes and thank-you auto-dismisses |
| Platforms | iOS 17+, macOS 14+ |

---

## User Goal

The user (an end-user of the host app, not the developer) wants to support the developer
by leaving a tip, or at minimum wants to understand the tip options available.

---

## Happy Path

```
Host App View
     │
     │  User taps "Support" / any host-defined trigger
     ▼
[Drawer Opening Animation]
  iOS:  bottom sheet slides up with spring animation
  macOS: floating sheet fades + scales in
     │
     ▼
[Loading State — BuyMeCoffeeView]
  Activity indicator centred in product list area
  Header already visible (title, subtitle, icon)
     │
     │  StoreKit products fetched (ProductProvider.fetchProducts)
     ▼
[Loaded State — BuyMeCoffeeView]
  Header: icon | title | subtitle
  Product list: one ProductRowView per tip tier, sorted by price ascending
     │
     │  User reviews options — no action required
     │
     ├──► User taps a ProductRowView
     │         └── → Purchase Flow (see purchase-flow.md)
     │
     └──► User dismisses drawer
               iOS:  swipe down or drag handle
               macOS: click outside / close button
               └── → Drawer closes, host app state reset
```

---

## Alternate Path: No Products Found

```
StoreKit returns empty product list
(wrong product IDs, App Store Connect not configured, sandbox issue)
     │
     ▼
[Empty State — BuyMeCoffeeView]
  Header still visible
  Product list area shows empty state message (v1.1: sized to content)
  (see ui-specs/error-and-empty-states.md)
     │
     └──► User dismisses drawer (only option)
```

---

## Alternate Path: Product Load Error

```
ProductProvider.fetchProducts throws / returns error
     │
     ▼
[Error State — BuyMeCoffeeView]
  Header still visible
  Product list area shows error state message (v1.1: sized to content)
  (see ui-specs/error-and-empty-states.md)
     │
     └──► User dismisses drawer (only option)
```

---

## Alternate Path: Mock / Preview Mode

```
Host app or Xcode Preview injects MockProductProvider
     │
     ▼
[No loading state — products appear immediately]
  MockProductProvider returns hardcoded TipProduct array synchronously
  Drawer proceeds directly to Loaded State
     │
     └──► Behaves identically to Loaded State above
```

---

## Transition Animations

| Transition | iOS | macOS |
|-----------|-----|-------|
| Sheet open | Spring slide-up from bottom (`easeOut`, 0.35s) — v1.1: fixed `.medium` detent | Fade + scale from 0.95 → 1.0 (`easeOut`, 0.25s) |
| Sheet dismiss (user) | Swipe down / spring slide-down | Fade + scale out — v1.1: also dismisses on outside-click |
| Loading → Loaded | Product rows fade in staggered (50ms delay per row) | Same |
| Loaded → Loading (retry) | Crossfade | Same |

---

## State Summary

| State | Trigger | UI |
|-------|---------|-----|
| `idle` | Sheet not presented | — |
| `loading` | Sheet opened, products being fetched | Header + spinner |
| `loaded` | Products received | Header + product list |
| `empty` | Products array is empty | Header + empty state |
| `error` | Fetch threw error | Header + error state |
| `purchasing` | User tapped a row | See purchase-flow.md |
| `thankyou` | Purchase succeeded | Thank-you screen |
| `dismissed` | Sheet closed by user or auto-dismiss | — |

---

## Accessibility Notes

- Sheet open/close is announced via VoiceOver (`UIAccessibility.post(notification: .screenChanged)` equivalent in SwiftUI)
- Drawer title receives initial VoiceOver focus on open
- All interactive elements have explicit `.accessibilityLabel` values
- Sheet handle on iOS has label "Dismiss tip drawer"
- Dynamic Type: all text scales; the `.medium` presentation detent provides sufficient height for default text sizes; very large Dynamic Type sizes may cause scrolling within the loaded state
