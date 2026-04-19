# UI Spec — Error & Empty States

**Version:** 1.0
**Date:** 2026-04-16
**Status:** Approved

---

## Component Identity

| Field | Value |
|-------|-------|
| SwiftUI components | `EmptyStateView`, inline error label within `ProductRowView` |
| Role | Communicates failure or absence of products to the user without crashing or blocking dismissal |
| Parent contexts | `BuyMeCoffeeView` (drawer-level), `ProductRowView` (row-level) |

---

## 1. Drawer-Level Empty State

Shown when `ProductProvider` returns an empty product array (no matching IAP products found).

### Layout

```
┌──────────────────────────────────────────┐
│                                          │
│                                          │
│          ┌─────────────┐                 │
│          │  cart icon  │                 │  ← SF Symbol: cart.badge.questionmark
│          └─────────────┘                 │
│                                          │
│       No tips available                  │  ← Headline
│                                          │
│  Check your product IDs are              │  ← Body (developer-facing hint)
│  configured in App Store Connect.        │
│                                          │
│                                          │
└──────────────────────────────────────────┘
```

**Alignment:** All elements centred horizontally and vertically within the product list area.

### Elements

#### Icon
- SF Symbol: `cart.badge.questionmark`
- Size: 40 × 40pt
- Colour: `color.text.secondary`

#### Headline
- Text: "No tips available"
- Font: `type.heading4` — 15pt Medium
- Colour: `color.text.primary`
- Gap above icon: `spacing.md` (16pt)

#### Body
- Text: "Check your product IDs are configured in App Store Connect."
- Font: `type.caption` — 13pt Regular
- Colour: `color.text.secondary`
- Line limit: 3
- Horizontal padding: `spacing.xl` (32pt) each side
- Gap above headline: `spacing.xs` (4pt)

### Height
**v1.1:** Sized to content with vertical padding (no fixed height constraints). The sheet sizes naturally to the content height.

---

## 2. Drawer-Level Error State

Shown when `ProductProvider.fetchProducts()` throws an error.

### Layout

```
┌──────────────────────────────────────────┐
│                                          │
│          ┌─────────────┐                 │
│          │  wifi / !   │                 │  ← SF Symbol: exclamationmark.triangle
│          └─────────────┘                 │
│                                          │
│       Couldn't load tips                 │  ← Headline
│                                          │
│  Something went wrong. Please            │  ← Body
│  try again later.                        │
│                                          │
└──────────────────────────────────────────┘
```

### Elements

#### Icon
- SF Symbol: `exclamationmark.triangle`
- Size: 40 × 40pt
- Colour: `color.error`

#### Headline
- Text: "Couldn't load tips"
- Font: `type.heading4` — 15pt Medium
- Colour: `color.text.primary`
- Gap above icon: `spacing.md` (16pt)

#### Body
- Text: "Something went wrong. Please try again later."
- Font: `type.caption` — 13pt Regular
- Colour: `color.text.secondary`
- Line limit: 3
- Horizontal padding: `spacing.xl` (32pt) each side
- Gap above headline: `spacing.xs` (4pt)

### Height
**v1.1:** Sized to content with vertical padding (no fixed height constraints). Multi-line body text does not get clipped.

### Notes
- No retry button in MVP (dismissing and reopening triggers a fresh fetch)
- Consistent with Apple's HIG pattern for non-actionable errors at this level

---

## 3. Row-Level Inline Error (Purchase Failed)

Shown below a `ProductRowView` when a purchase attempt returns an error.

### Layout

```
┌────────────────────────────────────────────────┐
│   Product Name              ┌───────────────┐  │
│                             │ Failed — try  │  │  ← Price button in error state
│   Product description       │    again      │  │
│                             └───────────────┘  │
│   ⚠ Purchase could not be completed.           │  ← Inline error label (below row)
└────────────────────────────────────────────────┘
```

### Inline Error Label

| Property | Value |
|----------|-------|
| Text | "Purchase could not be completed." |
| Font | `type.caption` — 13pt Regular |
| Colour | `color.error` |
| Icon | SF Symbol `exclamationmark.circle.fill` at 12pt, `color.error`, leading |
| Gap above (between card and label) | `spacing.xs` (4pt) |
| Horizontal inset | `spacing.md` (16pt) — aligns with card edge |
| Visibility duration | 4 seconds, then fades out (`easeOut`, 0.20s) |

### Price Button in Error State
- Background: `color.error` (solid — gradient replaced)
- Label: "Failed — try again"
- Font: `type.label`
- Colour: `color.text.on.accent` (white)
- Reverts to default gradient after 4 seconds (same timing as inline label)

---

## 4. Row-Level Inline Pending State

Shown below a `ProductRowView` when a purchase returns `.pending` (Ask to Buy).

### Inline Pending Label

| Property | Value |
|----------|-------|
| Text | "Waiting for approval." |
| Font | `type.caption` — 13pt Regular |
| Colour | `color.text.secondary` |
| Icon | SF Symbol `clock` at 12pt, `color.text.secondary`, leading |
| Gap above | `spacing.xs` (4pt) |
| Horizontal inset | `spacing.md` (16pt) |
| Visibility | Persists until drawer is dismissed (no auto-clear) |

---

## Theme Tokens Consumed

| Token | Use |
|-------|-----|
| `color.text.primary` | Empty/Error state headlines |
| `color.text.secondary` | Empty/Error state body text; pending label |
| `color.error` | Error icon tint; inline error label; row error button background |

---

## Accessibility

| Element | Role | Label |
|---------|------|-------|
| Empty state icon | `.decorative()` | — |
| Empty state headline | Static text | "No tips available" |
| Error state icon | `.decorative()` | — |
| Error state headline | Static text | "Couldn't load tips" |
| Inline row error | Static text | Announced via accessibility notification on appear |
| Inline row pending | Static text | Announced via accessibility notification on appear |
