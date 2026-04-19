# UI Spec — ThankYouView

**Version:** 1.2
**Date:** 2026-04-19
**Status:** Approved

---

## Component Identity

| Field | Value |
|-------|-------|
| SwiftUI component | `ThankYouView` |
| Role | Confirmation screen shown on successful StoreKit purchase |
| Parent | `BuyMeCoffeeView` — replaces product list content area on purchase success |
| Dismiss | macOS: tap anywhere on the view; iOS: use system sheet gesture or host-app dismiss |
| **v1.1 change** | No longer full-screen; sizes to its content with vertical padding |
| **v1.2 change** | Removed auto-dismiss (3s timer); macOS gets minimum width 360pt, vertical `fixedSize`; tap-to-dismiss is macOS-only |

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

**Alignment:** All elements centred horizontally. **v1.1:** Vertically sized to content with vertical padding (no `Spacer()` elements); no longer full-screen.

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
| Line limit | none (wraps freely) |
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

## Dismiss Behaviour

| Event | Platform | Action |
|-------|----------|--------|
| User taps anywhere on `ThankYouView` | macOS only | Immediate dismiss (`isPresented` set to `false`) |
| User swipes down | iOS only | Sheet dismisses naturally via system gesture; no conflict |
| Host app sets `isPresented` to `false` | Both | Drawer closes |

> Auto-dismiss (3-second timer) was removed in v1.2. The drawer stays open until the user explicitly dismisses it.

### macOS Sizing

On macOS, `ThankYouView` is constrained with `frame(minWidth: 360)` and `fixedSize(horizontal: false, vertical: true)` to prevent content clipping when the product list was small before purchase.

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
| View container (macOS) | `.button` (tappable to dismiss) | `accessibilityLabel("Dismiss")` |
| View container (iOS) | Static | — |
| Icon | `.decorative()` | — |
| Headline | `.accessibilityHeading(.h1)` | "Thank you!" |
| Body | Static text | "Your support means a lot." |
| On appear | VoiceOver announcement | "Thank you! Purchase complete." |

> VoiceOver users: the announcement on appear ensures they receive confirmation even
> if they cannot see the animation.
