/// A mock `ProductProvider` for use in Xcode Previews and unit tests.
///
/// Returns hardcoded products and simulates purchase outcomes without any StoreKit calls.
final class MockProductProvider: ProductProvider, @unchecked Sendable {

    enum PurchaseOutcome: Sendable {
        case success
        case failure(PurchaseError)
    }

    private let products: [TipProduct]
    private let purchaseOutcome: PurchaseOutcome

    init(products: [TipProduct] = MockProductProvider.defaultProducts, purchaseOutcome: PurchaseOutcome = .success) {
        self.products = products
        self.purchaseOutcome = purchaseOutcome
    }

    static let defaultProducts: [TipProduct] = [
        TipProduct(id: "mock.coffee.small", displayName: "Small Coffee", description: "A small cup of coffee", displayPrice: "$0.99", price: 0.99),
        TipProduct(id: "mock.coffee.large", displayName: "Large Coffee", description: "A large cup of coffee", displayPrice: "$2.99", price: 2.99),
        TipProduct(id: "mock.coffee.mega", displayName: "Mega Coffee", description: "An extra large cup of coffee", displayPrice: "$4.99", price: 4.99),
    ]

    func fetchProducts(productIDs: [String]) async throws -> [TipProduct] {
        products
    }

    func purchase(_ product: TipProduct) async throws {
        switch purchaseOutcome {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
