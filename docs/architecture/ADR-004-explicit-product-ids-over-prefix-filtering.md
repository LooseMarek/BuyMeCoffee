# ADR-004 — Explicit Product IDs Over Prefix Filtering

**Date:** 2026-04-19
**Status:** Accepted
**Author:** Architect
**Deciders:** Marek Loose

---

## Context

In v1.0, the BuyMeCoffee library accepted a `productIDPrefix: String` parameter and filtered products by matching this prefix against the StoreKit product IDs returned from `Product.products(for:)`. The intent was to allow consumers to scope tip products separately from other IAP product types (subscriptions, unlocks) in the same app.

However, this approach had two fundamental problems:

1. **StoreKit 2 API mismatch:** `Product.products(for: [String])` requires the exact, full set of product IDs upfront. It does not support wildcard or prefix matching. The library was passing the full list of known IDs to StoreKit and then filtering the results by prefix — a leaky abstraction that obscured the actual StoreKit contract.

2. **Empty product array bug:** `BuyMeCoffeeViewModifier` hard-coded `StoreKitProductProvider.live(knownProductIDs: [])`, passing an empty array. Because the prefix was never threaded through to the provider's `knownProductIDs`, no products were ever fetched and the drawer always showed the empty state. This went undetected until production integration.

---

## Decision

Replace `productIDPrefix: String` with `productIDs: [String]` in all public APIs:

- `BuyMeCoffeeView(productIDs:)` accepts `[String]` directly
- `.buyMeCoffee(isPresented:productIDs:)` accepts `[String]` directly
- `ProductProvider.fetchProducts(productIDs:)` accepts `[String]` directly (previously `fetchProducts(prefix:)`)
- `StoreKitProductProvider` passes `productIDs` directly to `Product.products(for:)` without filtering

Consumers must pass the exact product IDs they want to display:

```swift
.buyMeCoffee(
    isPresented: $showTipJar,
    productIDs: [
        "com.yourapp.tip.small",
        "com.yourapp.tip.medium",
        "com.yourapp.tip.large"
    ]
)
```

---

## Options Considered

### Option 1: Explicit product IDs (chosen)

**Description:** Accept `[String]` at all call sites; pass directly to StoreKit.

**Pros:**
- Aligns perfectly with StoreKit 2's API contract
- No hidden filtering logic — what you pass is what StoreKit fetches
- Fixes the empty-array bug at the root cause (no stored `knownProductIDs` property)
- Makes the product scope explicit and visible in consumer code

**Cons:**
- Breaking change — consumers must update their integration code
- Slightly more verbose (3 explicit IDs vs. 1 prefix string)

---

### Option 2: Fix the prefix threading bug

**Description:** Keep the `productIDPrefix` API but correctly thread it through to `StoreKitProductProvider`.

**Pros:**
- Non-breaking change

**Cons:**
- Perpetuates the abstraction mismatch with StoreKit 2
- Prefix filtering is unnecessary indirection — StoreKit does not support it natively
- Consumers still have to configure the full product ID list somewhere (App Store Connect); repeating it in code is not a burden

---

### Option 3: Both prefix and explicit IDs

**Description:** Accept both `productIDPrefix` and `productIDs` parameters; use whichever is non-nil.

**Pros:**
- Backwards-compatible

**Cons:**
- API bloat — two ways to do the same thing
- Confusing if both are passed
- Still perpetuates the prefix abstraction

---

## Rationale

Option 1 is the only choice that fully aligns with StoreKit 2's design and eliminates the root cause of the v1.0 bug. The breaking change is acceptable because:

1. This is a private library with a single known consumer (the host app under active development)
2. The migration path is trivial (replace one prefix string with an array of 3-5 IDs)
3. The new API is more explicit and easier to reason about

---

## Consequences

**Positive:**
- `BuyMeCoffeeViewModifier` no longer needs to store `knownProductIDs` — IDs are passed at call time
- The empty-array bug is structurally impossible — if the consumer passes an empty `productIDs` array, the intent is clear (empty state)
- The API is now a thin wrapper over StoreKit 2 with no filtering logic

**Negative / Trade-offs:**
- Breaking change requires a migration guide and a version bump
- Consumers with many tip tiers (e.g. 10+ products) must list all IDs explicitly — but this is exactly what StoreKit requires, so it is unavoidable

**Risks:**
- If a consumer misconfigures the product IDs (typo, wrong bundle prefix), the drawer shows empty state — but this would also have happened with the prefix approach if the prefix was wrong

---

## Migration Guide (v1.0 → v1.1)

**Before (v1.0):**
```swift
.buyMeCoffee(
    isPresented: $showTipJar,
    productIDPrefix: "com.yourapp.tip"
)
```

**After (v1.1):**
```swift
.buyMeCoffee(
    isPresented: $showTipJar,
    productIDs: [
        "com.yourapp.tip.small",
        "com.yourapp.tip.medium",
        "com.yourapp.tip.large"
    ]
)
```

---

## Related

| Type | Reference |
|------|-----------|
| Supersedes | v1.0 `productIDPrefix` API |
| Related ADRs | ADR-001 (protocol-driven provider architecture) |
| Related issues | Epic #37 — v1.1 Post-MVP Polish |
