import XCTest
@testable import BuyMeCoffee

final class EmptyStateLabelsTests: XCTestCase {

    func testDefaultLabelsMatchExpectedValues() {
        // Given: The .default static property
        let labels = EmptyStateLabels.default

        // Then: All properties should match expected default values
        XCTAssertEqual(labels.iconName, "cart.badge.questionmark")
        XCTAssertEqual(labels.headline, "No tips available")
        XCTAssertEqual(labels.bodyText, "Check your product IDs are configured in App Store Connect.")
    }

    func testPartialLabelsUseDefaultsForNilProperties() {
        // Given: A partial labels object with only iconName set
        let partialLabels = EmptyStateLabels(
            iconName: "tray.fill",
            headline: nil,
            bodyText: nil
        )

        // When: We check the properties
        // Then: Nil properties should be nil (defaults will be applied at view rendering)
        XCTAssertEqual(partialLabels.iconName, "tray.fill")
        XCTAssertNil(partialLabels.headline)
        XCTAssertNil(partialLabels.bodyText)
    }

    func testInitWithAllProperties() {
        // Given: Custom values for all properties
        let customIcon = "star"
        let customHeadline = "No Products"
        let customBody = "Please check your configuration"

        // When: We create a labels object with all properties
        let labels = EmptyStateLabels(
            iconName: customIcon,
            headline: customHeadline,
            bodyText: customBody
        )

        // Then: All properties should be set
        XCTAssertEqual(labels.iconName, customIcon)
        XCTAssertEqual(labels.headline, customHeadline)
        XCTAssertEqual(labels.bodyText, customBody)
    }
}
