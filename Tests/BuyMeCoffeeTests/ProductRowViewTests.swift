import XCTest
@testable import BuyMeCoffee

@MainActor
final class ProductRowViewTests: XCTestCase {

    private let sampleProduct = TipProduct(
        id: "com.example.tip.small",
        displayName: "Small Coffee",
        description: "A little thank you for your support",
        displayPrice: "$0.99",
        price: 0.99
    )

    func testOnTap_calledOnce() {
        var callCount = 0
        let view = ProductRowView(product: sampleProduct, onTap: { callCount += 1 })

        view.onTap()

        XCTAssertEqual(callCount, 1)
    }
}
