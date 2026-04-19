import XCTest
@testable import BuyMeCoffee

final class EmptyStateLabelsTests: XCTestCase {

    func testDefaultInitContainsExpectedValues() {
        // Given: A labels object created with .init() (all defaults)
        let labels = EmptyStateLabels()

        // Then: All properties should match expected default values
        XCTAssertEqual(labels.iconName, "cart.badge.questionmark")
        XCTAssertEqual(labels.headline, "No tips available")
        XCTAssertEqual(labels.bodyText, "Check your product IDs are configured in App Store Connect.")
    }

    func testPartialInitUsesDefaultsForOmittedParameters() {
        // Given: A partial labels object with only iconName set
        let partialLabels = EmptyStateLabels(iconName: "tray.fill")

        // When: We check the properties
        // Then: Omitted properties should use their default values
        XCTAssertEqual(partialLabels.iconName, "tray.fill")
        XCTAssertEqual(partialLabels.headline, "No tips available")
        XCTAssertEqual(partialLabels.bodyText, "Check your product IDs are configured in App Store Connect.")
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

        // Then: All properties should be set to custom values
        XCTAssertEqual(labels.iconName, customIcon)
        XCTAssertEqual(labels.headline, customHeadline)
        XCTAssertEqual(labels.bodyText, customBody)
    }
}
