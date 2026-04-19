import Foundation

/// Errors that can occur during a purchase attempt.
public enum PurchaseError: Error, Sendable {
    /// The user cancelled the purchase flow.
    case cancelled

    /// The purchase failed with an underlying error.
    case failed(Error)

    /// The purchase is pending (e.g., Ask to Buy waiting for parental approval).
    case pending
}

/// A protocol defining the contract for fetching products and processing purchases.
///
/// This protocol decouples the UI layer from StoreKit, allowing both live (`StoreKitProductProvider`)
/// and mock (`MockProductProvider`) implementations to be used interchangeably.
public protocol ProductProvider: Sendable {
    /// Fetches products for the given product IDs.
    ///
    /// - Parameter productIDs: The exact product IDs to fetch (e.g., ["com.example.tip.small", "com.example.tip.large"]).
    /// - Returns: An array of `TipProduct` values for the requested IDs.
    /// - Throws: Any error that occurs during product fetching.
    func fetchProducts(productIDs: [String]) async throws -> [TipProduct]

    /// Attempts to purchase the specified product.
    ///
    /// - Parameter product: The product to purchase.
    /// - Throws: `PurchaseError` if the purchase is cancelled, fails, or is pending.
    func purchase(_ product: TipProduct) async throws
}
