# UI Spec — ThankYouView

**Version:** 1.0
**Date:** 2026-04-16
**Status:** Approved

---

## Component Identity

| Field | Value |
|-------|-------|
| SwiftUI component | `ThankYouView` |
| Role | Full-drawer confirmation screen shown on successful StoreKit purchase |
| Parent | `BuyMeCoffeeView` — replaces product list content area on purchase success |
| Auto-dismiss | 3 seconds after appearance; or immediately on tap |

---

## Layout

```
┌──────────────────────────────────────────┐
│                                          │
│                                          │
│            ┌───────────┐                 │
│            │   ☕ / ✓   │                 │  ← Icon (animated)
│            └───────────┘                 │
│                                          │
│           Thank you!                     │  ← Headline
│                                          │
│     Your support means a lot.            │  ← Body
│                                          │
│                                          │
└──────────────────────────────────────────┘
```

**Alignment:** All elements centred horizontally. Vertically centred within the content area (below the drawer's top padding, above the bottom safe area inset).

---

## Elements

### Icon

| Property | Value |
|----------|-------|
| Source | SF Symbol `cup.and.saucer.fill` (coffee cup), or `checkmark.circle.fill` as fallback |
| Size | 64 × 64pt |
| Rendering | `.foregroundStyle` — gradient from `color.accent.start` to `color.accent.end` (same gradient as price button) |
| Container | No background — icon sits directly on `color.background` |
| Animation | See Entrance Animation section below |

### Headline

| Property | Value |
|----------|-------|
| Text | "Thank you!" (library-internal string, not configurable in MVP) |
| Font | `type.heading3` — 17pt Semibold |
| Colour | `color.text.primary` |
| Alignment | Centre |
| Gap above icon | `spacing.lg` (24pt) |

### Body

| Property | Value |
|----------|-------|
| Text | "Your support means a lot." (library-internal, not configurable in MVP) |
| Font | `type.body` — 15pt Regular |
| Colour | `color.text.secondary` |
| Alignment | Centre |
| Line limit | 2 |
| Gap above headline | `spacing.xs` (4pt) |
| Horizontal padding | `spacing.xl` (32pt) each side — narrower than drawer content to create breathing room |

---

## Entrance Animation

The `ThankYouView` animates in as a unit when `BuyMeCoffeeView` transitions from the
product list to the thank-you state.

| Step | Property | From | To | Duration | Easing |
|------|----------|------|----|----------|--------|
| 1 | Container opacity | 0 | 1 | 0.30s | `easeOut` |
| 1 | Container scale | 0.85 | 1.0 | 0.30s | Spring (`dampingFraction 0.75`) |
| 2 (offset 0.15s) | Icon scale | 0.5 | 1.0 | 0.40s | Spring (`dampingFraction 0.6`, `stiffness 200`) |
| 2 (offset 0.15s) | Icon opacity | 0 | 1 | 0.20s | `easeOut` |

> The icon "pops" slightly after the container settles — a two-beat animation that draws
> the eye to the confirmation icon naturally.

---

## Auto-Dismiss Behaviour

| Event | Action |
|-------|--------|
| 3 seconds elapsed | `isPresented` set to `false`; sheet dismisses with default sheet animation |
| User taps anywhere on `ThankYouView` | Immediate dismiss (same action) |
| User swipes down on iOS | Sheet dismisses naturally via system gesture; no conflict |

> There is no visible countdown timer. The dismiss is silent and smooth.

---

## Exit Animation

On dismiss, the sheet uses the system sheet dismiss animation (slide down on iOS,
fade-out on macOS). No custom exit animation on `ThankYouView` itself —
the system sheet animation is sufficient.

---

## Theme Tokens Consumed

| Token | Use |
|-------|-----|
| `color.background` | View background (inherited from sheet) |
| `color.text.primary` | Headline text |
| `color.text.secondary` | Body text |
| `color.accent.start` | Icon gradient start |
| `color.accent.end` | Icon gradient end |

---

## Accessibility

| Element | Role | Label |
|---------|------|-------|
| View container | `.button` (whole view is tappable to dismiss) | — |
| Icon | `.decorative()` | — |
| Headline | `.accessibilityHeading(.h1)` | "Thank you!" |
| Body | Static text | "Your support means a lot." |
| On appear | VoiceOver announcement | "Thank you! Purchase complete." |
| Auto-dismiss | Not announced | — |
| Tap to dismiss | — | `accessibilityLabel("Dismiss")` on container |

> VoiceOver users: the announcement on appear ensures they receive confirmation even
> if they cannot see the animation.
