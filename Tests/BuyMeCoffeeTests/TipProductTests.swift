import XCTest
@testable import BuyMeCoffee

final class TipProductTests: XCTestCase {

    // MARK: - Test AC 1: testInitFromProduct_populatesAllFields

    func testInitFromProduct_populatesAllFields() {
        // Given
        let id = "com.example.coffee.small"
        let displayName = "Small Coffee"
        let description = "A small cup of coffee"
        let displayPrice = "$0.99"
        let price: Decimal = 0.99

        // When
        let product = TipProduct(
            id: id,
            displayName: displayName,
            description: description,
            displayPrice: displayPrice,
            price: price
        )

        // Then
        XCTAssertEqual(product.id, id)
        XCTAssertEqual(product.displayName, displayName)
        XCTAssertEqual(product.description, description)
        XCTAssertEqual(product.displayPrice, displayPrice)
        XCTAssertEqual(product.price, price)
    }

    // MARK: - Test AC 2: testEquatable_sameID_areEqual

    func testEquatable_sameID_areEqual() {
        // Given
        let product1 = TipProduct(
            id: "com.example.coffee.small",
            displayName: "Small Coffee",
            description: "A small cup",
            displayPrice: "$0.99",
            price: 0.99
        )
        let product2 = TipProduct(
            id: "com.example.coffee.small",
            displayName: "Different Name",
            description: "Different description",
            displayPrice: "$1.99",
            price: 1.99
        )

        // When & Then
        XCTAssertEqual(product1, product2)
    }

    func testEquatable_differentID_areNotEqual() {
        // Given
        let product1 = TipProduct(
            id: "com.example.coffee.small",
            displayName: "Small Coffee",
            description: "A small cup",
            displayPrice: "$0.99",
            price: 0.99
        )
        let product2 = TipProduct(
            id: "com.example.coffee.large",
            displayName: "Small Coffee",
            description: "A small cup",
            displayPrice: "$0.99",
            price: 0.99
        )

        // When & Then
        XCTAssertNotEqual(product1, product2)
    }

    // MARK: - Test AC: testPriceProperty

    func testPriceProperty() {
        // Given
        let product = TipProduct(
            id: "com.example.coffee.small",
            displayName: "Small Coffee",
            description: "A small cup",
            displayPrice: "$0.99",
            price: 0.99
        )

        // Then — price is stored correctly
        XCTAssertEqual(product.price, 0.99)

        // And — equality remains ID-based, unaffected by differing price
        let sameIDDifferentPrice = TipProduct(
            id: "com.example.coffee.small",
            displayName: "Small Coffee",
            description: "A small cup",
            displayPrice: "$4.99",
            price: 4.99
        )
        XCTAssertEqual(product, sameIDDifferentPrice)
    }

    // MARK: - Test AC 3: testIdentifiable_idMatchesProductID

    func testIdentifiable_idMatchesProductID() {
        // Given
        let productID = "com.example.coffee.medium"
        let product = TipProduct(
            id: productID,
            displayName: "Medium Coffee",
            description: "A medium cup of coffee",
            displayPrice: "$1.49",
            price: 1.49
        )

        // When & Then
        XCTAssertEqual(product.id, productID)

        // Verify it can be used in collections that require Identifiable
        let products = [product]
        XCTAssertEqual(products.first?.id, productID)
    }
}
