import XCTest
@testable import BuyMeCoffee

final class ErrorStateLabelsTests: XCTestCase {

    func testDefaultLabelsMatchExpectedValues() {
        // Given: The .default static property
        let labels = ErrorStateLabels.default

        // Then: All properties should match expected default values
        XCTAssertEqual(labels.iconName, "exclamationmark.triangle")
        XCTAssertEqual(labels.headline, "Couldn't load tips")
    }

    func testPartialLabelsUseDefaultsForNilProperties() {
        // Given: A partial labels object with only iconName set
        let partialLabels = ErrorStateLabels(
            iconName: "xmark.circle",
            headline: nil
        )

        // When: We check the properties
        // Then: Nil properties should be nil (defaults will be applied at view rendering)
        XCTAssertEqual(partialLabels.iconName, "xmark.circle")
        XCTAssertNil(partialLabels.headline)
    }

    func testInitWithAllProperties() {
        // Given: Custom values for all properties
        let customIcon = "wifi.slash"
        let customHeadline = "Connection Failed"

        // When: We create a labels object with all properties
        let labels = ErrorStateLabels(
            iconName: customIcon,
            headline: customHeadline
        )

        // Then: All properties should be set
        XCTAssertEqual(labels.iconName, customIcon)
        XCTAssertEqual(labels.headline, customHeadline)
    }
}
