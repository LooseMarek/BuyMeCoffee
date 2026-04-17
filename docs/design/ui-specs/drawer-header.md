# UI Spec — DrawerHeaderView

**Version:** 1.0
**Date:** 2026-04-16
**Status:** Approved

---

## Component Identity

| Field | Value |
|-------|-------|
| SwiftUI component | `DrawerHeaderView` |
| Role | Configurable header at the top of the tip drawer: icon, title, subtitle |
| Parent | `BuyMeCoffeeView` |
| Configurable by host app | Yes — icon image, title string, subtitle string are all optional |

---

## Layout

```
┌──────────────────────────────────────────┐
│                                          │
│   ┌──────────┐                           │
│   │          │   Title text              │
│   │  [Icon]  │   type.heading2           │
│   │          │                           │
│   └──────────┘   Subtitle text           │
│                  type.body               │
│                  color.text.secondary    │
│                                          │
└──────────────────────────────────────────┘
```

**Alignment:** Leading (left-aligned). Icon and text aligned to leading edge with `spacing.md` horizontal inset (inherited from parent). Icon and text block are vertically centred relative to each other in a horizontal stack.

---

## Elements

### Icon Image (optional)
- Source: any SwiftUI `Image` passed by the host app (SF Symbol or custom asset)
- Container size: 56 × 56pt
- Container shape: `RoundedRectangle(cornerRadius: 16pt)` — clips the image
- Background: `color.productRowBackground` (`productRowBackgroundColor`) — visible when image has transparency
- Image rendering: `.scaledToFit()` at 30×30pt centred inside the 56×56pt container (12pt inset on each side)
- If omitted: the icon container is not rendered; title/subtitle stack fills the full width

### Title (optional)
- Font: `type.heading2` — 22pt Semibold
- Colour: `color.text.primary`
- Line limit: 2 lines; truncates with `...` if longer
- If omitted: not rendered; subtitle takes its vertical position

### Subtitle (optional)
- Font: `type.body` — 15pt Regular
- Colour: `color.text.secondary`
- Line limit: 3 lines; truncates with `...` if longer
- If omitted: not rendered

---

## Spacing

| Property | Value |
|----------|-------|
| Gap between icon and text block | `spacing.md` (16pt) |
| Gap between title and subtitle | `spacing.xs` (4pt) |
| Component minimum height | 56pt (icon height drives minimum) |

---

## Variant: No Icon

When `iconImage` is `nil`:

```
┌──────────────────────────────────────────┐
│                                          │
│   Title text                             │
│   type.heading2                          │
│                                          │
│   Subtitle text                          │
│   type.body / color.text.secondary       │
│                                          │
└──────────────────────────────────────────┘
```

---

## Variant: Title Only (no subtitle)

```
┌──────────────────────────────────────────┐
│  ┌──────────┐                            │
│  │  [Icon]  │   Title text               │
│  └──────────┘                            │
└──────────────────────────────────────────┘
```

Title is vertically centred relative to the icon.

---

## Theme Tokens Consumed

| Token | Use |
|-------|-----|
| `color.text.primary` | Title text |
| `color.text.secondary` | Subtitle text |
| `color.productRowBackground` (`productRowBackgroundColor`) | Icon container background |

---

## Accessibility

| Element | Role | Label |
|---------|------|-------|
| Icon image | `.decorative()` if purely decorative; `.accessibilityLabel(title)` if the icon IS the title | Configurable |
| Title | `.accessibilityHeading(.h1)` | Title string |
| Subtitle | Static text | Subtitle string |
| On sheet open | VoiceOver focus should land on title | Managed by `BuyMeCoffeeView` |
