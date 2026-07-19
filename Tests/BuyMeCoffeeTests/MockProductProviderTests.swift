import XCTest
@testable import BuyMeCoffee

final class MockProductProviderTests: XCTestCase {

    private let products = [
        TipProduct(id: "mock.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99", price: 0.99),
        TipProduct(id: "mock.coffee.large", displayName: "Large Coffee", description: "A large cup", displayPrice: "$2.99", price: 2.99),
    ]

    func testFetchProducts_returnsConfiguredProducts() async throws {
        let provider = MockProductProvider(products: products)

        let result = try await provider.fetchProducts(productIDs: ["mock.coffee.small", "mock.coffee.large"])

        XCTAssertEqual(result, products)
    }

    func testPurchase_successMode_returnsSuccess() async throws {
        let provider = MockProductProvider(products: products, purchaseOutcome: .success)

        try await provider.purchase(products[0])
    }

    func testMockProductsIncludeRawPrice() {
        let expectedPrices: [String: Decimal] = [
            "mock.coffee.small": 0.99,
            "mock.coffee.large": 2.99,
            "mock.coffee.mega": 4.99,
        ]

        for product in MockProductProvider.defaultProducts {
            let expected = expectedPrices[product.id]
            XCTAssertNotNil(expected, "Unexpected mock product id: \(product.id)")
            XCTAssertEqual(product.price, expected)
        }
    }

    func testPurchase_failureMode_throwsError() async {
        let provider = MockProductProvider(products: products, purchaseOutcome: .failure(.cancelled))

        do {
            try await provider.purchase(products[0])
            XCTFail("Expected PurchaseError.cancelled")
        } catch PurchaseError.cancelled {
            // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
