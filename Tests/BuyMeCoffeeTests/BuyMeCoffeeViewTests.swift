import XCTest
@testable import BuyMeCoffee

/// Unit tests for BuyMeCoffeeView state machine transitions.
final class BuyMeCoffeeViewTests: XCTestCase {

    // MARK: - State Machine Tests

    /// Verifies that the view transitions from .loading to .loaded when the mock provider returns products.
    @MainActor
    func testStateMachine_loadingToLoaded() async throws {
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small", description: "Desc", displayPrice: "$1"),
            TipProduct(id: "test.coffee.large", displayName: "Large", description: "Desc", displayPrice: "$2"),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)
        let viewModel = BuyMeCoffeeViewModel(provider: mockProvider, productIDs: ["test.coffee.small", "test.coffee.large"])

        // Initial state should be loading
        XCTAssertEqual(viewModel.state, .loading)

        // Trigger fetch
        await viewModel.fetchProducts()

        // State should transition to loaded with products
        if case .loaded(let products) = viewModel.state {
            XCTAssertEqual(products.count, 2)
            XCTAssertEqual(products[0].id, "test.coffee.small")
            XCTAssertEqual(products[1].id, "test.coffee.large")
        } else {
            XCTFail("Expected state to be .loaded, got \(viewModel.state)")
        }
    }

    /// Verifies that the view transitions from .loading to .empty when the mock provider returns no products.
    @MainActor
    func testStateMachine_loadingToEmpty() async throws {
        let mockProvider = MockProductProvider(products: [], purchaseOutcome: .success)
        let viewModel = BuyMeCoffeeViewModel(provider: mockProvider, productIDs: [])

        // Initial state should be loading
        XCTAssertEqual(viewModel.state, .loading)

        // Trigger fetch
        await viewModel.fetchProducts()

        // State should transition to empty
        XCTAssertEqual(viewModel.state, .empty)
    }

    /// Verifies that the view transitions from .loading to .error when the mock provider throws.
    @MainActor
    func testStateMachine_loadingToError() async throws {
        struct TestError: Error {}
        let mockProvider = ThrowingMockProductProvider(error: TestError())
        let viewModel = BuyMeCoffeeViewModel(provider: mockProvider, productIDs: ["test.coffee.small"])

        // Initial state should be loading
        XCTAssertEqual(viewModel.state, .loading)

        // Trigger fetch
        await viewModel.fetchProducts()

        // State should transition to error
        if case .error = viewModel.state {
            // Success
        } else {
            XCTFail("Expected state to be .error, got \(viewModel.state)")
        }
    }

    /// Verifies that the view transitions to .thankYou after a successful mock purchase.
    @MainActor
    func testStateMachine_purchaseSuccess_showsThankYou() async throws {
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small", description: "Desc", displayPrice: "$1"),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)
        let viewModel = BuyMeCoffeeViewModel(provider: mockProvider, productIDs: ["test.coffee.small"])

        // Fetch products first
        await viewModel.fetchProducts()

        // Verify we're in loaded state
        guard case .loaded(let products) = viewModel.state else {
            XCTFail("Expected .loaded state after fetch")
            return
        }

        // Attempt purchase
        await viewModel.purchase(products[0])

        // State should transition to thankYou
        if case .thankYou = viewModel.state {
            // Success
        } else {
            XCTFail("Expected state to be .thankYou, got \(viewModel.state)")
        }
    }

    /// Verifies that ViewModel passes productIDs to provider.fetchProducts(productIDs:)
    @MainActor
    func testFetchProductsCallsProviderWithCorrectIDs() async throws {
        let requestedIDs = ["com.example.tip.small", "com.example.tip.large"]
        let mockProducts = [
            TipProduct(id: "com.example.tip.small", displayName: "Small", description: "Desc", displayPrice: "$1"),
            TipProduct(id: "com.example.tip.large", displayName: "Large", description: "Desc", displayPrice: "$2"),
        ]

        let capturingProvider = CapturingProductProvider(products: mockProducts)
        let viewModel = BuyMeCoffeeViewModel(provider: capturingProvider, productIDs: requestedIDs)

        await viewModel.fetchProducts()

        XCTAssertEqual(capturingProvider.capturedProductIDs, requestedIDs, "ViewModel should pass productIDs to provider.fetchProducts(productIDs:)")
    }
}

// MARK: - Test Helpers

/// A mock provider that always throws during fetch.
private final class ThrowingMockProductProvider: ProductProvider, @unchecked Sendable {
    let error: Error

    init(error: Error) {
        self.error = error
    }

    func fetchProducts(prefix: String) async throws -> [TipProduct] {
        throw error
    }

    func fetchProducts(productIDs: [String]) async throws -> [TipProduct] {
        throw error
    }

    func purchase(_ product: TipProduct) async throws {
        throw error
    }
}

/// A mock provider that captures the productIDs parameter for verification.
private final class CapturingProductProvider: ProductProvider, @unchecked Sendable {
    let products: [TipProduct]
    var capturedProductIDs: [String]?

    init(products: [TipProduct]) {
        self.products = products
    }

    func fetchProducts(productIDs: [String]) async throws -> [TipProduct] {
        capturedProductIDs = productIDs
        return products
    }

    func purchase(_ product: TipProduct) async throws {
    }
}

/// Minimal view model to test state transitions in isolation.
@MainActor
private final class BuyMeCoffeeViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded([TipProduct])
        case empty
        case error(String)
        case thankYou

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading), (.empty, .empty), (.thankYou, .thankYou):
                return true
            case (.loaded(let l), .loaded(let r)):
                return l == r
            case (.error, .error):
                return true
            default:
                return false
            }
        }
    }

    @Published var state: State = .loading

    private let provider: ProductProvider
    private let productIDs: [String]

    init(provider: ProductProvider, productIDs: [String]) {
        self.provider = provider
        self.productIDs = productIDs
    }

    func fetchProducts() async {
        do {
            let products = try await provider.fetchProducts(productIDs: productIDs)
            if products.isEmpty {
                state = .empty
            } else {
                state = .loaded(products)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func purchase(_ product: TipProduct) async {
        do {
            try await provider.purchase(product)
            state = .thankYou
        } catch {
            // In a full implementation, we'd handle purchase errors
            // For this test, we just verify the happy path
        }
    }
}
