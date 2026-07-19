import Foundation

/// A value type wrapping StoreKit Product data for display in the UI.
///
/// This struct contains only the display-level data needed by views, decoupled from StoreKit's `Product` type.
/// It can be constructed from raw strings, making it testable without StoreKit.
public struct TipProduct: Equatable, Identifiable, Sendable {
    /// The unique product identifier (matches StoreKit Product.id)
    public let id: String

    /// The localised display name of the product
    public let displayName: String

    /// The localised description of the product
    public let description: String

    /// The localised price string (e.g., "$0.99")
    public let displayPrice: String

    /// The raw, comparable price value (matches StoreKit `Product.price`)
    public let price: Decimal

    /// Initializes a TipProduct with raw string values.
    ///
    /// - Parameters:
    ///   - id: The unique product identifier
    ///   - displayName: The localised display name
    ///   - description: The localised description
    ///   - displayPrice: The localised price string
    ///   - price: The raw, comparable price value
    public init(
        id: String,
        displayName: String,
        description: String,
        displayPrice: String,
        price: Decimal
    ) {
        self.id = id
        self.displayName = displayName
        self.description = description
        self.displayPrice = displayPrice
        self.price = price
    }

    // MARK: - Equatable

    /// Two TipProducts are equal if their IDs match.
    public static func == (lhs: TipProduct, rhs: TipProduct) -> Bool {
        lhs.id == rhs.id
    }
}
