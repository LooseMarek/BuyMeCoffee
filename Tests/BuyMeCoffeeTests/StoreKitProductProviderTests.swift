import XCTest
@testable import BuyMeCoffee

final class StoreKitProductProviderTests: XCTestCase {

    // MARK: - Fetching tests

    func testFetchProductsPassesIDsDirectlyToStoreKit() async throws {
        let requestedIDs = ["com.example.tip.small", "com.example.tip.large"]

        // Use an actor to safely capture IDs in the @Sendable closure
        actor IDCapture {
            var ids: [String]?
            func set(_ newIds: [String]) {
                ids = newIds
            }
        }
        let capture = IDCapture()

        let allProducts: [(id: String, displayName: String, description: String, displayPrice: String)] = [
            (id: "com.example.tip.small", displayName: "Small", description: "S", displayPrice: "$0.99"),
            (id: "com.example.tip.large", displayName: "Large", description: "L", displayPrice: "$2.99"),
        ]

        let provider = StoreKitProductProvider(
            fetcher: { ids in
                await capture.set(ids)
                return allProducts
            }
        )

        _ = try await provider.fetchProducts(productIDs: requestedIDs)

        let capturedIDs = await capture.ids
        XCTAssertEqual(capturedIDs, requestedIDs, "Fetcher should receive exactly the IDs passed by the caller, without filtering")
    }

    func testFetchProductsReturnsAllProductsForGivenIDs() async throws {
        let productIDs = ["com.example.tip.small", "com.example.tip.large"]
        let allProducts: [(id: String, displayName: String, description: String, displayPrice: String)] = [
            (id: "com.example.tip.small", displayName: "Small", description: "S", displayPrice: "$0.99"),
            (id: "com.example.tip.large", displayName: "Large", description: "L", displayPrice: "$2.99"),
        ]

        let provider = StoreKitProductProvider(
            fetcher: { _ in allProducts }
        )

        let results = try await provider.fetchProducts(productIDs: productIDs)

        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].id, "com.example.tip.small")
        XCTAssertEqual(results[1].id, "com.example.tip.large")
    }

    func testFetchProducts_emptyResult_noThrow() async throws {
        let provider = StoreKitProductProvider(
            fetcher: { _ in [] }
        )

        let results = try await provider.fetchProducts(productIDs: [])

        XCTAssertEqual(results, [])
    }

    func testFetchProducts_propagatesError() async {
        struct FetchError: Error {}
        let provider = StoreKitProductProvider(
            fetcher: { _ in throw FetchError() }
        )

        do {
            _ = try await provider.fetchProducts(productIDs: ["com.example.tip.small"])
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is FetchError)
        }
    }

    // MARK: - Purchase tests

    func testPurchase_successMode_returnsSuccess() async throws {
        let product = TipProduct(id: "com.example.tip.small", displayName: "Small", description: "S", displayPrice: "$0.99")
        let provider = StoreKitProductProvider(
            fetcher: { _ in [] },
            purchaser: { _ in }
        )

        try await provider.purchase(product)
    }

    func testPurchase_userCancelledThrowsCancelled() async {
        let product = TipProduct(id: "com.example.tip.small", displayName: "Small", description: "S", displayPrice: "$0.99")
        let provider = StoreKitProductProvider(
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
