# UI Spec — BuyMeCoffeeDrawer (Main Sheet)

**Version:** 1.0
**Date:** 2026-04-16
**Status:** Approved

---

## Component Identity

| Field | Value |
|-------|-------|
| SwiftUI component | `BuyMeCoffeeView` |
| Role | Root container for the tip drawer; presented as a sheet |
| Used in flows | tip-drawer-presentation.md, purchase-flow.md |
| Child components | `DrawerHeaderView`, `ProductRowView` (×n), `ThankYouView`, empty/error states |

---

## Platform Presentation

### iOS
- Presentation: `.sheet` with dynamic `.presentationDetents` sized to content (v1.1: fit-to-content for most states)
- **v1.1 behaviour:** Loading, empty, error, and thank-you states size to their content with vertical padding (no longer full-screen). Loaded state uses static layout when products fit within half the screen height; scrollable when product list exceeds that threshold.
- Drag handle: system handle bar at top centre — always visible
- Background: `color.background` applied via `.presentationBackground`
- Corner radius: system default (approx 16pt at top corners)
- Bottom safe area: content inset by `spacing.md` above home indicator

### macOS
- Presentation: standard SwiftUI `.sheet` (floating window)
- Size: fixed width 360pt, height auto (min 300pt)
- **v1.1 behaviour:** Outside-click dismissal enabled (previously Esc-only). After purchase, popup expands to show full thank-you content without clipping.
- Background: `color.background`
- Shadow: `elevation.medium`
- Corner radius: `radius.lg` (16pt)
- No drag handle

---

## Layout

```
┌─────────────────────────────────────┐
│         [System drag handle]        │  ← iOS only; system-provided
│                                     │
│  ┌───────────────────────────────┐  │
│  │      DrawerHeaderView         │  │  ← spacing.xl top padding
│  └───────────────────────────────┘  │
│                                     │
│  ─ ─ ─ ─ separator ─ ─ ─ ─ ─ ─ ─  │  ← color.separator, 0.5pt
│                                     │
│  ┌───────────────────────────────┐  │
│  │      ProductRowView #1        │  │
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │      ProductRowView #2        │  │  ← spacing.sm gap between rows
│  └───────────────────────────────┘  │
│  ┌───────────────────────────────┐  │
│  │      ProductRowView #3        │  │
│  └───────────────────────────────┘  │
│  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │
│                                     │
│  [Loading / Empty / Error state]    │  ← replaces product rows when applicable
│                                     │
│       [bottom safe area inset]      │
└─────────────────────────────────────┘
```

---

## Spacing & Geometry

| Property | Value |
|----------|-------|
| Horizontal inset (content padding) | `spacing.md` (16pt) each side |
| Top padding below drag handle (iOS) | `spacing.xl` (32pt) |
| Top padding below sheet top edge (macOS) | `spacing.lg` (24pt) |
| Gap between header and separator | `spacing.lg` (24pt) |
| Gap between separator and first row | `spacing.md` (16pt) |
| Gap between rows | `spacing.sm` (8pt) |
| Bottom padding above safe area | `spacing.lg` (24pt) |

---

## States

### Loading State
- `DrawerHeaderView` visible (full opacity)
- Product list area replaced by a centred `ProgressView` (system spinner)
- Spinner colour: `color.text.secondary`
- **v1.1:** Sized to content with vertical padding (no fixed height constraints)

### Loaded State
- `DrawerHeaderView` visible
- Separator visible
- Product rows visible, staggered fade-in (50ms per row, `easeOut` 0.25s)
- **v1.1 iOS:** Static `VStack` layout when products fit within half the screen height; `ScrollView` enabled when product list exceeds that threshold (drawer capped at ~half screen height)

### Empty State
- `DrawerHeaderView` visible
- Separator visible
- Empty state view in product list area (see ui-specs/error-and-empty-states.md)

### Error State
- `DrawerHeaderView` visible
- Separator visible
- Error state view in product list area (see ui-specs/error-and-empty-states.md)

### ThankYou State
- Entire content area (header + rows) replaced by `ThankYouView`
- Transition: crossfade + spring scale (see ui-specs/thank-you-screen.md)

---

## Theme Surface

`BuyMeCoffeeTheme` tokens consumed by this component:

| Token used | From |
|-----------|------|
| `color.background` | Sheet background |
| `color.separator` | Hairline between header and rows |

All child components inherit the theme via SwiftUI environment.

---

## Accessibility

| Element | Role | Label |
|---------|------|-------|
| Sheet container | `.sheet` | "Tip drawer" |
| On appear | — | VoiceOver screen-changed notification; focus moves to drawer title |
| Drag handle (iOS) | Not interactive in SwiftUI; system handles it | — |
