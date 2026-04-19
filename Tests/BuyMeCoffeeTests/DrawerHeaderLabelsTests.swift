import XCTest
import SwiftUI
@testable import BuyMeCoffee

final class DrawerHeaderLabelsTests: XCTestCase {

    func testDefaultInitContainsExpectedValues() {
        // Given: A labels object created with .init() (all defaults)
        let labels = DrawerHeaderLabels()

        // Then: All properties should match expected default values
        XCTAssertEqual(labels.title, "Buy Me a Coffee")
        XCTAssertEqual(labels.subtitle, "Support my work with a small tip")
        // iconImage is Image(systemName: "cup.and.saucer.fill"), verified via rendering
    }

    func testPartialInitUsesDefaultsForOmittedParameters() {
        // Given: A partial labels object with only title set
        let partialLabels = DrawerHeaderLabels(title: "Custom Title")

        // When: We check the properties
        // Then: Omitted properties should use their default values
        XCTAssertEqual(partialLabels.title, "Custom Title")
        XCTAssertEqual(partialLabels.subtitle, "Support my work with a small tip")
        // iconImage is default: Image(systemName: "cup.and.saucer.fill")
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

        // Then: All properties should be set to custom values
        XCTAssertEqual(labels.title, customTitle)
        XCTAssertEqual(labels.subtitle, customSubtitle)
        // iconImage is custom, verified via rendering
    }
}
