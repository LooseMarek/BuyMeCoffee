# Design System — BuyMeCoffee

**Version:** 1.0
**Date:** 2026-04-16
**Status:** Approved

> All visual tokens in this document map directly to properties on `BuyMeCoffeeTheme`.
> The **Default Theme** values listed here are used when the host app does not supply a custom theme.
> Tokens are named `{category}.{name}` throughout all design and UI spec documents.

---

## Inspiration Reference

Design language is informed by `docs/design/inspiration.png`:
a premium dark finance/wallet UI with very dark blue-charcoal backgrounds, slightly elevated
dark surfaces, vibrant gradient hero elements, clean white primary text, and blue-grey muted
secondary text. Adapted here with a warm amber-to-orange coffee gradient accent in place of
the source's cooler purple-pink gradient.

---

## Colour Tokens

All colours are expressed as hex with 100% opacity unless noted.

### Background & Surface

| Token | Default (Dark Theme) | Role |
|-------|---------------------|------|
| `color.background` | `#16182A` | Sheet / drawer background |
| `color.surface` | `#1F2235` | Product row card background |
| `color.surface.elevated` | `#272A40` | Elevated surfaces (e.g. pressed state, modal within modal) |
| `color.separator` | `#2E3150` | Hairline dividers between rows |

> **Rationale:** Dark blue-charcoal rather than pure black gives depth and matches the inspiration's
> premium, dark-first aesthetic. Surfaces are differentiated by lightness steps, not borders.

### Text

| Token | Default (Dark Theme) | Role |
|-------|---------------------|------|
| `color.text.primary` | `#FFFFFF` | Headings, product names, price labels |
| `color.text.secondary` | `#8B8FA8` | Subtitles, descriptions, captions |
| `color.text.on.accent` | `#FFFFFF` | Text rendered on top of the accent gradient |

### Accent (Gradient)

The accent is a two-stop linear gradient expressing the "coffee warmth" brand feel —
warm amber bleeding into a richer orange.

| Token | Default (Dark Theme) | Role |
|-------|---------------------|------|
| `color.accent.start` | `#F5A623` | Gradient start (warm amber) |
| `color.accent.end` | `#F07242` | Gradient end (warm orange) |

> Used for: the purchase CTA button, price chip, and the thank-you screen highlight.
> Direction: top-leading → bottom-trailing (135°).

### Semantic

| Token | Default (Dark Theme) | Role |
|-------|---------------------|------|
| `color.success` | `#52D38C` | Thank-you confirmation icon, positive states |
| `color.error` | `#E05252` | Inline purchase error messages |

### Custom Theme Rules

A host app may override any or all tokens by constructing a `BuyMeCoffeeTheme` with their
own `Color` values. Any token not explicitly set falls back to the default dark values above.

**Theming scope:** The theme applies to the entire drawer and all child views.
It does not affect system chrome (sheet handle, OS-level modal background).

---

## Typography Tokens

The library uses SwiftUI's system font (SF Pro on Apple platforms) exclusively —
no custom font loading, no third-party fonts. This ensures zero binary overhead and
correct Dynamic Type scaling.

| Token | Size | Weight | Role |
|-------|------|--------|------|
| `type.heading1` | 28pt | Bold | Not used in MVP; reserved for future |
| `type.heading2` | 22pt | Semibold | Drawer title |
| `type.heading3` | 17pt | Semibold | Section labels, thank-you headline |
| `type.heading4` | 15pt | Medium | Product row name |
| `type.body` | 15pt | Regular | Drawer subtitle/description |
| `type.caption` | 13pt | Regular | Product row description, secondary labels |
| `type.label` | 13pt | Medium | Price button label, chip text |

> All text styles support **Dynamic Type** — use SwiftUI's `.font(.title2)` equivalents
> mapped to the sizes above, not hardcoded `Font.system(size:)`. This satisfies standard
> accessibility requirements automatically.

---

## Spacing Tokens

Based on a **4-point grid**.

| Token | Value | Common Use |
|-------|-------|-----------|
| `spacing.xs` | 4pt | Icon-to-label gap, tight internal padding |
| `spacing.sm` | 8pt | Row internal padding (vertical), icon margin |
| `spacing.md` | 16pt | Standard horizontal inset, card internal padding |
| `spacing.lg` | 24pt | Section spacing, header bottom margin |
| `spacing.xl` | 32pt | Top padding below sheet handle, major section gaps |
| `spacing.xxl` | 48pt | Thank-you screen vertical centering offset |

---

## Border Radius Tokens

| Token | Value | Common Use |
|-------|-------|-----------|
| `radius.none` | 0pt | — |
| `radius.sm` | 4pt | Inline chips, small badges |
| `radius.md` | 10pt | Price button |
| `radius.lg` | 16pt | Product row card, main sheet corners |
| `radius.xl` | 24pt | Icon image container in drawer header |
| `radius.pill` | 9999pt | Full-pill buttons (unused in MVP; reserved) |

---

## Shadow / Elevation Tokens

Used to lift surfaces visually on macOS (floating sheet) and for the thank-you card.

| Token | Definition | Use |
|-------|-----------|-----|
| `elevation.low` | `0 2pt 8pt rgba(0,0,0,0.30)` | Product row hover/pressed feedback |
| `elevation.medium` | `0 4pt 16pt rgba(0,0,0,0.40)` | macOS floating sheet drop shadow |
| `elevation.high` | `0 8pt 32pt rgba(0,0,0,0.50)` | Thank-you card entrance animation |

---

## Component States

Applies to all interactive elements (product rows, price buttons, dismiss control).

| State | Visual Treatment |
|-------|-----------------|
| Default | Base surface/accent colours as specified per component |
| Pressed | Background lightens by 10% (`color.surface.elevated`); scale 0.97 |
| Disabled | Opacity 40%; no interaction |
| Focused (keyboard/accessibility) | System focus ring at `color.accent.start` |
| Loading | Activity indicator replaces price label; button disabled |
| Error | `color.error` replaces accent on the affected row |

---

## Platform Notes

| Concern | iOS | macOS |
|---------|-----|-------|
| Sheet chrome | System handle bar, `presentationDetents([.medium, .large])` | Standard floating `.sheet` |
| Corner radius | Rounded sheet corners handled by system | Sheet corners handled by system |
| Safe areas | Content respects `.safeAreaInset` at bottom | Standard window padding |
| Dynamic Type | Full support | Full support |
| Accent gradient direction | Top-leading → bottom-trailing | Same |
