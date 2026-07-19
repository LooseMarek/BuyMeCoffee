import XCTest
@testable import BuyMeCoffee

/// Unit tests for the standalone `TipListViewModel` state machine, exercised without any
/// reference to `BuyMeCoffeeView` — proving the type is reusable in isolation.
final class TipListViewModelTests: XCTestCase {

    private let sampleProducts = [
        TipProduct(id: "test.coffee.small", displayName: "Small", description: "Desc", displayPrice: "$1", price: 1),
        TipProduct(id: "test.coffee.large", displayName: "Large", description: "Desc", displayPrice: "$2", price: 2),
    ]

    // MARK: - Fetch

    @MainActor
    func testFetchProductsSuccessTransitionsToLoaded() async {
        let provider = MockProductProvider(products: sampleProducts, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: provider, productIDs: ["test.coffee.small", "test.coffee.large"])

        XCTAssertEqual(viewModel.state, .loading)

        await viewModel.fetchProducts()

        guard case .loaded(let products) = viewModel.state else {
            return XCTFail("Expected .loaded, got \(viewModel.state)")
        }
        XCTAssertEqual(products, sampleProducts)
    }

    @MainActor
    func testFetchProductsEmptyTransitionsToEmpty() async {
        let provider = MockProductProvider(products: [], purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: provider, productIDs: [])

        await viewModel.fetchProducts()

        XCTAssertEqual(viewModel.state, .empty)
    }

    @MainActor
    func testFetchProductsFailureTransitionsToError() async {
        struct FetchError: Error {}
        let provider = ThrowingFetchProvider(error: FetchError())
        let viewModel = TipListViewModel(provider: provider, productIDs: ["test.coffee.small"])

        await viewModel.fetchProducts()

        guard case .error = viewModel.state else {
            return XCTFail("Expected .error, got \(viewModel.state)")
        }
    }

    // MARK: - Purchase

    @MainActor
    func testPurchaseSuccessTransitionsToThankYou() async {
        let provider = MockProductProvider(products: sampleProducts, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: provider, productIDs: [])
        await viewModel.fetchProducts()

        await viewModel.purchase(sampleProducts[0])

        XCTAssertEqual(viewModel.state, .thankYou)
    }

    @MainActor
    func testPurchaseCancelledStaysInLoadedState() async {
        let provider = MockProductProvider(products: sampleProducts, purchaseOutcome: .failure(.cancelled))
        let viewModel = TipListViewModel(provider: provider, productIDs: [])
        await viewModel.fetchProducts()

        await viewModel.purchase(sampleProducts[0])

        guard case .loaded(let products) = viewModel.state else {
            return XCTFail("Expected .loaded after cancel, got \(viewModel.state)")
        }
        XCTAssertEqual(products, sampleProducts)
    }

    @MainActor
    func testPurchaseFailedTransitionsToError() async {
        struct UnderlyingError: Error {}
        let provider = MockProductProvider(products: sampleProducts, purchaseOutcome: .failure(.failed(UnderlyingError())))
        let viewModel = TipListViewModel(provider: provider, productIDs: [])
        await viewModel.fetchProducts()

        await viewModel.purchase(sampleProducts[0])

        guard case .error = viewModel.state else {
            return XCTFail("Expected .error, got \(viewModel.state)")
        }
    }

    @MainActor
    func testPurchasePendingTransitionsToError() async {
        let provider = MockProductProvider(products: sampleProducts, purchaseOutcome: .failure(.pending))
        let viewModel = TipListViewModel(provider: provider, productIDs: [])
        await viewModel.fetchProducts()

        await viewModel.purchase(sampleProducts[0])

        guard case .error = viewModel.state else {
            return XCTFail("Expected .error, got \(viewModel.state)")
        }
    }
}

// MARK: - Test Helpers

/// A provider that always throws when fetching products.
private final class ThrowingFetchProvider: ProductProvider, @unchecked Sendable {
    let error: Error

    init(error: Error) {
        self.error = error
    }

    func fetchProducts(productIDs: [String]) async throws -> [TipProduct] {
        throw error
    }

    func purchase(_ product: TipProduct) async throws {
        throw error
    }
}
