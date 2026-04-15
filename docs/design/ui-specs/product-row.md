# UI Spec — ProductRowView

**Version:** 1.0
**Date:** 2026-04-16
**Status:** Approved

---

## Component Identity

| Field | Value |
|-------|-------|
| SwiftUI component | `ProductRowView` |
| Role | Displays a single tip tier; tapping the price button initiates purchase |
| Parent | `BuyMeCoffeeView` product list |
| Data source | `TipProduct` (wraps StoreKit `Product`) |

---

## Layout

```
┌────────────────────────────────────────────────┐
│                                                 │
│   Product Name                  ┌───────────┐  │
│   type.heading4                 │  $0.99    │  │
│                                 │  [accent] │  │
│   Product description           └───────────┘  │
│   type.caption / color.text.secondary           │
│                                                 │
└────────────────────────────────────────────────┘
```

- **Layout:** Horizontal stack — text block (leading, flexible width) + price button (trailing, fixed width)
- **Text block:** Vertical stack with product name above description
- **Alignment:** Text block and price button are vertically centred

---

## Card Container

| Property | Value |
|----------|-------|
| Background | `color.surface` |
| Corner radius | `radius.lg` (16pt) |
| Horizontal inset from parent | `spacing.md` (16pt) — inherited from drawer |
| Internal padding (all sides) | `spacing.md` (16pt) |
| Elevation (default) | None |
| Elevation (pressed) | `elevation.low` |
| Pressed scale | 0.97 (spring, `dampingFraction 0.7`) |

---

## Text Block

### Product Name
- Font: `type.heading4` — 15pt Medium
- Colour: `color.text.primary`
- Line limit: 1; truncates with `...`

### Product Description
- Font: `type.caption` — 13pt Regular
- Colour: `color.text.secondary`
- Line limit: 2; truncates with `...`
- Gap above: `spacing.xs` (4pt)

---

## Price Button

| Property | Value |
|----------|-------|
| Background | Linear gradient `color.accent.start` → `color.accent.end`, 135° |
| Text | Localised price string from StoreKit (`product.displayPrice`) |
| Text font | `type.label` — 13pt Medium |
| Text colour | `color.text.on.accent` |
| Corner radius | `radius.md` (10pt) |
| Padding (horizontal) | `spacing.md` (16pt) |
| Padding (vertical) | `spacing.sm` (8pt) |
| Min width | 70pt |
| Pressed state | Gradient opacity 80%; scale 0.97 |

> The price button is the **only tappable affordance** on the row.
> The surrounding card background is non-interactive — this prevents accidental purchases.

---

## States

### Default
- All values as specified above

### Loading (purchase in progress)
- Price button: gradient replaced by `color.surface.elevated`
- Price button content: `ProgressView` (small, white) replaces price label
- Card: non-interactive (`.disabled(true)`)
- Other rows in parent: opacity 60%

### Error (purchase failed)
- Price button background: `color.error` (solid, no gradient)
- Price button label: "Failed — try again" in `type.label`
- Inline error message below description (see ui-specs/error-and-empty-states.md)
- Resets to default after 4 seconds

### Pending (awaiting approval)
- Price button background: `color.surface.elevated` (solid)
- Price button label: "Pending…" in `type.label`, `color.text.secondary`
- Inline message below description: "Waiting for approval"

### Disabled (another row is loading)
- Card opacity: 60%
- Non-interactive

---

## Spacing

| Property | Value |
|----------|-------|
| Gap between text block and price button | `spacing.sm` (8pt) minimum |
| Card internal padding | `spacing.md` (16pt) all sides |

---

## Theme Tokens Consumed

| Token | Use |
|-------|-----|
| `color.surface` | Card background |
| `color.surface.elevated` | Pressed state card background; loading/pending button background |
| `color.text.primary` | Product name |
| `color.text.secondary` | Product description; pending label colour |
| `color.accent.start` | Gradient start |
| `color.accent.end` | Gradient end |
| `color.text.on.accent` | Price label |
| `color.error` | Error state button background |
| `radius.lg` | Card corner radius |
| `radius.md` | Price button corner radius |
| `elevation.low` | Card pressed elevation |

---

## Accessibility

| Element | Role | Label |
|---------|------|-------|
| Card container | Not interactive | — |
| Price button | `.button` | "Buy [product name] for [localised price]" |
| Price button (loading) | `.button` disabled | "Processing payment, please wait" |
| Price button (error) | `.button` | "Purchase failed. Tap to try again for [localised price]" |
| Price button (pending) | `.button` disabled | "Payment pending approval for [product name]" |
| Product description | Static text | Description string (read naturally) |
