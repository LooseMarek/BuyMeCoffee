import XCTest
@testable import BuyMeCoffee

final class ErrorStateLabelsTests: XCTestCase {

    func testDefaultInitContainsExpectedValues() {
        // Given: A labels object created with .init() (all defaults)
        let labels = ErrorStateLabels()

        // Then: All properties should match expected default values
        XCTAssertEqual(labels.iconName, "exclamationmark.triangle")
        XCTAssertEqual(labels.headline, "Couldn't load tips")
    }

    func testPartialInitUsesDefaultsForOmittedParameters() {
        // Given: A partial labels object with only iconName set
        let partialLabels = ErrorStateLabels(iconName: "xmark.circle")

        // When: We check the properties
        // Then: Omitted properties should use their default values
        XCTAssertEqual(partialLabels.iconName, "xmark.circle")
        XCTAssertEqual(partialLabels.headline, "Couldn't load tips")
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

        // Then: All properties should be set to custom values
        XCTAssertEqual(labels.iconName, customIcon)
        XCTAssertEqual(labels.headline, customHeadline)
    }
}
