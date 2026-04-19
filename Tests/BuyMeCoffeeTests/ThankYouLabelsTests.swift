import XCTest
@testable import BuyMeCoffee

final class ThankYouLabelsTests: XCTestCase {

    func testDefaultInitContainsExpectedValues() {
        // Given: A labels object created with .init() (all defaults)
        let labels = ThankYouLabels()

        // Then: All properties should match expected default values
        XCTAssertEqual(labels.title, "Thank you!")
        XCTAssertEqual(labels.subtitle, "Your support means a lot.")
        XCTAssertEqual(labels.iconName, "cup.and.saucer.fill")
        XCTAssertEqual(labels.dismissAccessibilityLabel, "Dismiss")
        XCTAssertEqual(labels.dismissAccessibilityHint, "Tap to dismiss")
        XCTAssertEqual(labels.voiceOverAnnouncement, "Thank you! Purchase complete.")
    }

    func testPartialInitUsesDefaultsForOmittedParameters() {
        // Given: A partial labels object with only title set
        let partialLabels = ThankYouLabels(title: "Thanks!")

        // When: We check the properties
        // Then: Omitted properties should use their default values
        XCTAssertEqual(partialLabels.title, "Thanks!")
        XCTAssertEqual(partialLabels.subtitle, "Your support means a lot.")
        XCTAssertEqual(partialLabels.iconName, "cup.and.saucer.fill")
        XCTAssertEqual(partialLabels.dismissAccessibilityLabel, "Dismiss")
        XCTAssertEqual(partialLabels.dismissAccessibilityHint, "Tap to dismiss")
        XCTAssertEqual(partialLabels.voiceOverAnnouncement, "Thank you! Purchase complete.")
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

        // Then: All properties should be set to custom values
        XCTAssertEqual(labels.title, customTitle)
        XCTAssertEqual(labels.subtitle, customSubtitle)
        XCTAssertEqual(labels.iconName, customIcon)
        XCTAssertEqual(labels.dismissAccessibilityLabel, customDismissLabel)
        XCTAssertEqual(labels.dismissAccessibilityHint, customDismissHint)
        XCTAssertEqual(labels.voiceOverAnnouncement, customAnnouncement)
    }
}
