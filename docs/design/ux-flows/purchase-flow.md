# UX Flow — Purchase Flow

**Version:** 1.2
**Date:** 2026-04-19
**Status:** Approved

---

## Flow Identity

| Field | Value |
|-------|-------|
| Flow name | Purchase Flow |
| Entry point | User taps a `ProductRowView` in the loaded drawer |
| Exit points | Purchase succeeded → ThankYouView → user dismisses; Purchase cancelled → return to Loaded State; Purchase failed → inline error on row |
| Platforms | iOS 17+, macOS 14+ |

---

## User Goal

The user has chosen a tip tier and wants to complete the StoreKit purchase with as little
friction as possible. Ideally: one tap → system authentication → confirmation.

---

## Happy Path

```
[Loaded State — ProductRowView tapped]
     │
     │  User taps a product row price button
     ▼
[Row enters loading state]
  Price button replaced by activity indicator
  Row not re-tappable (prevents double-purchase)
  Other rows: opacity 60% (de-emphasised, still visible)
     │
     │  Product.purchase() called via ProductProvider
     ▼
[System StoreKit sheet / Face ID / Touch ID prompt]
  Handled entirely by the OS — no custom UI
     │
     │  User authenticates and confirms
     ▼
[Transaction verified — Transaction.finish() called]
     │
     ▼
[ThankYouView animates in, replacing product list]
  (see ui-specs/thank-you-screen.md)
  v1.1 iOS: sized to content
  v1.1 macOS: popup expands to show full thank-you content (minWidth 360pt)
     │
     │  macOS: user taps anywhere on the view to dismiss
     │  iOS:   user uses system sheet gesture (swipe down) to dismiss
     ▼
[Drawer dismisses]
  isPresented set to false
  Host app state reset
```

---

## Alternate Path: User Cancels StoreKit Sheet

```
User taps "Cancel" in OS StoreKit sheet
     │
     ▼
[Row exits loading state — returns to default]
  Price button restored
  Other rows return to full opacity
  No error message shown (cancellation is intentional)
     │
     └──► Drawer remains open; user may choose again or dismiss
```

---

## Alternate Path: Purchase Error (Failed / Unknown)

```
Product.purchase() throws or returns .userCancelled / .pending / error
     │
     ▼
[Row enters error state]
  Price button background: color.error
  Price button label: "Failed — try again"
  Error message appears below the row: caption text in color.error
  (see ui-specs/error-and-empty-states.md for inline error spec)
     │
     │  After 4 seconds OR user taps elsewhere
     ▼
[Row resets to default state]
  Error cleared; user can retry or choose a different tier
```

---

## Alternate Path: Pending Transaction

```
Purchase returns .pending (e.g. Ask to Buy, parental approval)
     │
     ▼
[Row enters pending state]
  Price button label: "Pending…"
  Price button background: color.surface.elevated
  Informational caption below row: "Waiting for approval"
     │
     └──► Drawer may be dismissed; transaction will complete later via
          the host app's own StoreKit listener (outside this library's scope)
```

---

## Transition Animations

| Transition | Duration | Easing |
|-----------|----------|--------|
| Row → loading | 0.15s | `easeIn` |
| Other rows dim | 0.15s | `easeIn` |
| Loading → error state | 0.20s | `easeOut` |
| Error → reset | 0.20s | `easeOut` (after 4s delay) |
| Product list → ThankYouView | 0.30s | Spring (dampingFraction 0.75) |

---

## State Machine (ProductRowView)

```
default
  └─[tap]──► loading
               ├─[success]──► (ThankYouView takes over; row state irrelevant)
               ├─[cancelled]──► default
               ├─[error]──► error
               │               └─[4s / tap elsewhere]──► default
               └─[pending]──► pending
                               └─[dismissed]──► (handled by host app)
```

---

## Accessibility Notes

- While a row is in loading state: `.accessibilityLabel("Processing payment, please wait")`
- While a row is in error state: error message is announced via VoiceOver accessibility notification
- Pending state caption: `.accessibilityLabel("Payment is pending approval")`
- ThankYouView: announced as `.accessibilityLabel("Thank you! Purchase complete.")` on appear
- macOS: tap-to-dismiss container has `.accessibilityLabel("Dismiss")` and `.isButton` trait
