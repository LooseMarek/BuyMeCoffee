import XCTest
@testable import BuyMeCoffee

final class ThankYouLabelsTests: XCTestCase {

    func testDefaultLabelsMatchExpectedValues() {
        // Given: The .default static property
        let labels = ThankYouLabels.default

        // Then: All properties should match expected default values
        XCTAssertEqual(labels.title, "Thank you!")
        XCTAssertEqual(labels.subtitle, "Your support means a lot.")
        XCTAssertEqual(labels.iconName, "cup.and.saucer.fill")
        XCTAssertEqual(labels.dismissAccessibilityLabel, "Dismiss")
        XCTAssertEqual(labels.dismissAccessibilityHint, "Tap to dismiss")
        XCTAssertEqual(labels.voiceOverAnnouncement, "Thank you! Purchase complete.")
    }

    func testPartialLabelsUseDefaultsForNilProperties() {
        // Given: A partial labels object with only title set
        let partialLabels = ThankYouLabels(
            title: "Thanks!",
            subtitle: nil,
            iconName: nil,
            dismissAccessibilityLabel: nil,
            dismissAccessibilityHint: nil,
            voiceOverAnnouncement: nil
        )

        // When: We check the properties
        // Then: Nil properties should be nil (defaults will be applied at view rendering)
        XCTAssertEqual(partialLabels.title, "Thanks!")
        XCTAssertNil(partialLabels.subtitle)
        XCTAssertNil(partialLabels.iconName)
        XCTAssertNil(partialLabels.dismissAccessibilityLabel)
        XCTAssertNil(partialLabels.dismissAccessibilityHint)
        XCTAssertNil(partialLabels.voiceOverAnnouncement)
    }

    func testInitWithAllProperties() {
        // Given: Custom values for all properties
        let customTitle = "Awesome!"
        let customSubtitle = "You're the best"
        let customIcon = "heart.fill"
        let customDismissLabel = "Close"
        let customDismissHint = "Tap to close"
        let customAnnouncement = "Purchase successful"

        // When: We create a labels object with all properties
        let labels = ThankYouLabels(
            title: customTitle,
            subtitle: customSubtitle,
            iconName: customIcon,
            dismissAccessibilityLabel: customDismissLabel,
            dismissAccessibilityHint: customDismissHint,
            voiceOverAnnouncement: customAnnouncement
        )

        // Then: All properties should be set
        XCTAssertEqual(labels.title, customTitle)
        XCTAssertEqual(labels.subtitle, customSubtitle)
        XCTAssertEqual(labels.iconName, customIcon)
        XCTAssertEqual(labels.dismissAccessibilityLabel, customDismissLabel)
        XCTAssertEqual(labels.dismissAccessibilityHint, customDismissHint)
        XCTAssertEqual(labels.voiceOverAnnouncement, customAnnouncement)
    }
}
