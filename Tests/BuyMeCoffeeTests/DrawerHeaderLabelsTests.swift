import XCTest
import SwiftUI
@testable import BuyMeCoffee

final class DrawerHeaderLabelsTests: XCTestCase {

    func testDefaultLabelsMatchExpectedValues() {
        // Given: The .default static property
        let labels = DrawerHeaderLabels.default

        // Then: All properties should match expected default values
        XCTAssertNotNil(labels.iconImage, "Default icon should not be nil")
        XCTAssertEqual(labels.title, "Buy Me a Coffee")
        XCTAssertEqual(labels.subtitle, "Support my work with a small tip")
    }

    func testPartialLabelsUseDefaultsForNilProperties() {
        // Given: A partial labels object with only iconImage set
        let partialLabels = DrawerHeaderLabels(
            iconImage: Image(systemName: "heart.fill"),
            title: nil,
            subtitle: nil
        )

        // When: We check the properties
        // Then: Nil properties should be nil (defaults will be applied at view rendering)
        XCTAssertNotNil(partialLabels.iconImage)
        XCTAssertNil(partialLabels.title)
        XCTAssertNil(partialLabels.subtitle)
    }

    func testInitWithAllProperties() {
        // Given: Custom values for all properties
        let customIcon = Image(systemName: "star.fill")
        let customTitle = "Support the Project"
        let customSubtitle = "Every contribution helps"

        // When: We create a labels object with all properties
        let labels = DrawerHeaderLabels(
            iconImage: customIcon,
            title: customTitle,
            subtitle: customSubtitle
        )

        // Then: All properties should be set
        XCTAssertNotNil(labels.iconImage)
        XCTAssertEqual(labels.title, customTitle)
        XCTAssertEqual(labels.subtitle, customSubtitle)
    }
}
