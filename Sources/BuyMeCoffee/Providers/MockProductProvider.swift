/// A mock `ProductProvider` for use in Xcode Previews and unit tests.
///
/// Returns hardcoded products and simulates purchase outcomes without any StoreKit calls.
/// Lives in the main module so host apps can use it in their own Xcode Previews.
public final class MockProductProvider: ProductProvider, @unchecked Sendable {

    public enum PurchaseOutcome: Sendable {
        case success
        case failure(PurchaseError)
    }

    private let products: [TipProduct]
    private let purchaseOutcome: PurchaseOutcome

    public init(products: [TipProduct] = MockProductProvider.defaultProducts, purchaseOutcome: PurchaseOutcome = .success) {
        self.products = products
        self.purchaseOutcome = purchaseOutcome
    }

    public static let defaultProducts: [TipProduct] = [
        TipProduct(id: "mock.coffee.small", displayName: "Small Coffee", description: "A small cup of coffee", displayPrice: "$0.99"),
        TipProduct(id: "mock.coffee.large", displayName: "Large Coffee", description: "A large cup of coffee", displayPrice: "$2.99"),
        TipProduct(id: "mock.coffee.mega", displayName: "Mega Coffee", description: "An extra large cup of coffee", displayPrice: "$4.99"),
    ]

    public func fetchProducts(prefix: String) async throws -> [TipProduct] {
        products
    }

    public func purchase(_ product: TipProduct) async throws {
        switch purchaseOutcome {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
