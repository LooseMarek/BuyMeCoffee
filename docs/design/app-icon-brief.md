# App Icon Brief — BuyMeCoffee

**Version:** 1.0
**Date:** 2026-04-16
**Status:** Approved

> This brief covers the library's README logo / repository identity icon.
> BuyMeCoffee is a Swift Package — there is no App Store icon submission.
> The icon below is intended for use in the README header and GitHub social preview.

---

## Purpose

A recognisable identity mark for the `LooseMarek/BuyMeCoffee` GitHub repository.
Communicates the library's purpose at a glance: tipping / "buy me a coffee" + native Swift.

---

## Concept

**A coffee cup with a Swift-orange warmth.**

The icon uses the `cup.and.saucer.fill` SF Symbol as its base motif — immediately
communicating "coffee tip" — rendered with the library's warm amber-to-orange accent
gradient against the dark `color.background` field.

An optional subtle steam wisp above the cup suggests warmth and generosity.

---

## Visual Direction

| Property | Specification |
|----------|---------------|
| Shape | Square with rounded corners — `radius.xl` (24pt at standard size) |
| Background | `color.background` (`#16182A`) — same as the drawer background, reinforcing brand consistency |
| Icon motif | `cup.and.saucer.fill` SF Symbol, centred |
| Icon fill | Linear gradient `color.accent.start` (`#F5A623`) → `color.accent.end` (`#F07242`), 135° |
| Icon size | 55% of icon canvas |
| Optional detail | 2–3 thin curved lines above the cup (steam), same gradient, reduced opacity (40%) |

---

## Sizes Required

| Use | Canvas Size |
|-----|------------|
| README `<img>` header | 256 × 256pt |
| GitHub social preview (background) | 1280 × 640pt |
| In-repo `/docs/design/icon.png` | 512 × 512pt |

---

## Style Guidance

- Dark field first — the dark background should dominate; the gradient icon is the focal point
- Do not add a border or stroke around the rounded square
- Do not add the library name as text within the icon — the README provides context
- Keep it single-element: the cup motif alone. Resist adding the Swift bird, SPM logo, or other symbols that would create visual noise at small sizes
- The gradient direction (top-leading → bottom-trailing) must match the gradient used on the price button in the drawer — visual consistency across library and identity

---

## Inspiration Reference

The two-tone warm gradient in `docs/design/inspiration.png` (the hero balance card) directly
informs the gradient accent. The coffee cup motif anchors the library's purpose clearly —
no abstract shapes.

---

## Deliverable Format

A single PNG exported at 512 × 512pt with transparent corners (the rounded square clipping
should be applied by the renderer, not baked into the PNG) — or as an SVG with the gradient
defined inline for use in the README via GitHub's SVG rendering.
