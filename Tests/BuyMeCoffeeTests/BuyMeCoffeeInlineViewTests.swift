import XCTest
@testable import BuyMeCoffee

/// Unit tests for `BuyMeCoffeeInlineView` — the embeddable tip list component.
///
/// These verify that the inline view reuses the same `TipListViewModel` engine as the drawer
/// (no duplicated fetch/purchase logic) and works end-to-end with a `MockProductProvider`,
/// with no live StoreKit calls.
final class BuyMeCoffeeInlineViewTests: XCTestCase {

    // MARK: - Construction

    /// Verifies construction succeeds with a live-style injected `ProductProvider`.
    @MainActor
    func testInitAcceptsProviderAndProductIDs() {
        let mockProvider = MockProductProvider(products: [], purchaseOutcome: .success)

        let view = BuyMeCoffeeInlineView(
            provider: mockProvider,
            productIDs: ["test.coffee.small", "test.coffee.large"]
        )

        XCTAssertNotNil(view)
    }

    // MARK: - Shared View Model

    /// Verifies the inline view fetches via the SAME view-model type as the drawer
    /// (`TipListViewModel`), so behaviour stays in parity and no fetch logic is duplicated.
    @MainActor
    func testUsesSharedTipListViewModel() async {
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small", description: "Desc", displayPrice: "$1", price: 1),
            TipProduct(id: "test.coffee.large", displayName: "Large", description: "Desc", displayPrice: "$2", price: 2),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)

        // A TipListViewModel — the same shared engine the drawer uses — is injected.
        let viewModel = TipListViewModel(provider: mockProvider, productIDs: ["test.coffee.small", "test.coffee.large"])
        let view = BuyMeCoffeeInlineView(viewModel: viewModel)

        XCTAssertNotNil(view)
        XCTAssertEqual(viewModel.state, .loading)

        await viewModel.fetchProducts()

        if case .loaded(let products) = viewModel.state {
            XCTAssertEqual(products.count, 2)
        } else {
            XCTFail("Expected state to be .loaded, got \(viewModel.state)")
        }
    }

    // MARK: - Mock Provider End-to-End

    /// Verifies mock injection works end-to-end, synchronously, with no live StoreKit calls,
    /// producing the expected ordered set of products.
    @MainActor
    func testMockProviderProducesExpectedRows() async {
        // Provider returns products out of price order; the view model should sort ascending.
        let mockProducts = [
            TipProduct(id: "test.coffee.large", displayName: "Large Coffee", description: "A large cup", displayPrice: "$2.99", price: 2.99),
            TipProduct(id: "test.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99", price: 0.99),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: mockProvider, productIDs: ["test.coffee.large", "test.coffee.small"])

        _ = BuyMeCoffeeInlineView(viewModel: viewModel)

        await viewModel.fetchProducts()

        guard case .loaded(let products) = viewModel.state else {
            XCTFail("Expected .loaded state, got \(viewModel.state)")
            return
        }

        XCTAssertEqual(products.map(\.id), ["test.coffee.small", "test.coffee.large"], "Products should be sorted ascending by price")
    }
}
