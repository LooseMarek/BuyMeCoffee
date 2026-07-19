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

    // MARK: - Sort Order

    @MainActor
    func testDefaultSortOrderIsAscending() async {
        let unsorted = [
            TipProduct(id: "c", displayName: "C", description: "Desc", displayPrice: "$3", price: 3),
            TipProduct(id: "a", displayName: "A", description: "Desc", displayPrice: "$1", price: 1),
            TipProduct(id: "b", displayName: "B", description: "Desc", displayPrice: "$2", price: 2),
        ]
        let provider = MockProductProvider(products: unsorted, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: provider, productIDs: [])

        await viewModel.fetchProducts()

        guard case .loaded(let products) = viewModel.state else {
            return XCTFail("Expected .loaded, got \(viewModel.state)")
        }
        XCTAssertEqual(products.map(\.price), [1, 2, 3])
    }

    @MainActor
    func testDescendingSortOrder() async {
        let unsorted = [
            TipProduct(id: "a", displayName: "A", description: "Desc", displayPrice: "$1", price: 1),
            TipProduct(id: "c", displayName: "C", description: "Desc", displayPrice: "$3", price: 3),
            TipProduct(id: "b", displayName: "B", description: "Desc", displayPrice: "$2", price: 2),
        ]
        let provider = MockProductProvider(products: unsorted, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: provider, productIDs: [], sortOrder: .descending)

        await viewModel.fetchProducts()

        guard case .loaded(let products) = viewModel.state else {
            return XCTFail("Expected .loaded, got \(viewModel.state)")
        }
        XCTAssertEqual(products.map(\.price), [3, 2, 1])
    }

    @MainActor
    func testSortIsStableForEqualPrices() async {
        let equalPriced = [
            TipProduct(id: "first", displayName: "First", description: "Desc", displayPrice: "$1", price: 1),
            TipProduct(id: "second", displayName: "Second", description: "Desc", displayPrice: "$1", price: 1),
            TipProduct(id: "third", displayName: "Third", description: "Desc", displayPrice: "$1", price: 1),
        ]
        let provider = MockProductProvider(products: equalPriced, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: provider, productIDs: [])

        await viewModel.fetchProducts()

        guard case .loaded(let products) = viewModel.state else {
            return XCTFail("Expected .loaded, got \(viewModel.state)")
        }
        XCTAssertEqual(products.map(\.id), ["first", "second", "third"])
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
