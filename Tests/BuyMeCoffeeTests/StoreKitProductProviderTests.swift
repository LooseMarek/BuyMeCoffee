import XCTest
@testable import BuyMeCoffee

final class StoreKitProductProviderTests: XCTestCase {

    // MARK: - Fetching tests

    func testFetchProducts_filtersToPrefix() async throws {
        let allProducts: [(id: String, displayName: String, description: String, displayPrice: String)] = [
            (id: "com.example.tip.small", displayName: "Small", description: "S", displayPrice: "$0.99"),
            (id: "com.example.tip.large", displayName: "Large", description: "L", displayPrice: "$2.99"),
            (id: "com.example.unlock.feature", displayName: "Unlock", description: "U", displayPrice: "$4.99"),
        ]
        let provider = StoreKitProductProvider(
            knownProductIDs: allProducts.map(\.id),
            fetcher: { _ in allProducts }
        )

        let results = try await provider.fetchProducts(prefix: "com.example.tip")

        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.id.hasPrefix("com.example.tip") })
    }

    func testFetchProducts_emptyResult_noThrow() async throws {
        let provider = StoreKitProductProvider(
            knownProductIDs: ["com.example.tip.small"],
            fetcher: { _ in [] }
        )

        let results = try await provider.fetchProducts(prefix: "com.example.tip")

        XCTAssertEqual(results, [])
    }

    func testFetchProducts_propagatesError() async {
        struct FetchError: Error {}
        let provider = StoreKitProductProvider(
            knownProductIDs: ["com.example.tip.small"],
            fetcher: { _ in throw FetchError() }
        )

        do {
            _ = try await provider.fetchProducts(prefix: "com.example.tip")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is FetchError)
        }
    }

    // MARK: - Purchase tests

    func testPurchase_successMode_returnsSuccess() async throws {
        let product = TipProduct(id: "com.example.tip.small", displayName: "Small", description: "S", displayPrice: "$0.99")
        let provider = StoreKitProductProvider(
            knownProductIDs: [product.id],
            fetcher: { _ in [] },
            purchaser: { _ in }
        )

        try await provider.purchase(product)
    }

    func testPurchase_userCancelledThrowsCancelled() async {
        let product = TipProduct(id: "com.example.tip.small", displayName: "Small", description: "S", displayPrice: "$0.99")
        let provider = StoreKitProductProvider(
            knownProductIDs: [product.id],
            fetcher: { _ in [] },
            purchaser: { _ in throw PurchaseError.cancelled }
        )

        do {
            try await provider.purchase(product)
            XCTFail("Expected PurchaseError.cancelled")
        } catch PurchaseError.cancelled {
            // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testPurchase_failureThrowsFailed() async {
        struct UnderlyingError: Error {}
        let product = TipProduct(id: "com.example.tip.small", displayName: "Small", description: "S", displayPrice: "$0.99")
        let provider = StoreKitProductProvider(
            knownProductIDs: [product.id],
            fetcher: { _ in [] },
            purchaser: { _ in throw PurchaseError.failed(UnderlyingError()) }
        )

        do {
            try await provider.purchase(product)
            XCTFail("Expected PurchaseError.failed")
        } catch PurchaseError.failed {
            // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testPurchase_pendingReturnsPending() async {
        let product = TipProduct(id: "com.example.tip.small", displayName: "Small", description: "S", displayPrice: "$0.99")
        let provider = StoreKitProductProvider(
            knownProductIDs: [product.id],
            fetcher: { _ in [] },
            purchaser: { _ in throw PurchaseError.pending }
        )

        do {
            try await provider.purchase(product)
            XCTFail("Expected PurchaseError.pending")
        } catch PurchaseError.pending {
            // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
