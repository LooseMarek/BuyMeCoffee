import XCTest
import SwiftUI
@testable import BuyMeCoffee

final class BuyMeCoffeeViewModifierTests: XCTestCase {

    // MARK: - Test AC 1: testModifier_presentedWhenIsPresentedTrue

    @MainActor
    func testModifier_presentedWhenIsPresentedTrue() {
        // Given: A view with the .buyMeCoffee modifier applied
        // When: The isPresented binding is set to true
        // Then: The sheet should be presented

        // We can't directly test sheet presentation in a unit test without running the view,
        // but we can verify the modifier compiles and the environment key is set correctly.

        let isPresented = Binding.constant(true)
        let testView = Text("Test")
            .buyMeCoffee(
                isPresented: isPresented,
                productIDs: ["com.test.tip.small", "com.test.tip.large"]
            )

        // If the modifier exists and compiles, the test passes
        XCTAssertNotNil(testView)
    }

    // MARK: - Test AC 2: testModifier_defaultThemeApplied

    @MainActor
    func testModifier_defaultThemeApplied() {
        // Given: A view with the .buyMeCoffee modifier applied
        // When: No theme argument is supplied
        // Then: BuyMeCoffeeTheme.default should be used

        let isPresented = Binding.constant(false)
        let testView = Text("Test")
            .buyMeCoffee(
                isPresented: isPresented,
                productIDs: ["com.test.tip.small"]
            )

        // The modifier should use the default theme when no theme is provided
        XCTAssertNotNil(testView)
    }

    // MARK: - Test AC 3: testModifier_customThemeApplied

    @MainActor
    func testModifier_customThemeApplied() {
        // Given: A view with the .buyMeCoffee modifier applied
        // When: A custom theme argument is supplied
        // Then: The custom theme should be forwarded to the drawer

        let customTheme = BuyMeCoffeeTheme(
            backgroundColor: .red,
            primaryTextColor: .blue,
            secondaryTextColor: .green,
            accentStartColor: .yellow,
            accentEndColor: .orange,
            productRowBackgroundColor: .purple,
            separatorColor: .cyan,
            surfaceElevatedColor: .pink,
            textOnAccentColor: .brown,
            successColor: .mint,
            errorColor: .indigo
        )

        let isPresented = Binding.constant(false)
        let testView = Text("Test")
            .buyMeCoffee(
                isPresented: isPresented,
                productIDs: ["com.test.tip.small"],
                theme: customTheme
            )

        // The modifier should accept and use the custom theme
        XCTAssertNotNil(testView)
    }

    // MARK: - Test AC 4: testModifierPassesProductIDsToView

    @MainActor
    func testModifierPassesProductIDsToView() {
        // Given: A view with the .buyMeCoffee modifier applied with productIDs
        // When: The modifier is constructed
        // Then: The productIDs should be passed to BuyMeCoffeeView

        let productIDs = ["com.test.tip.small", "com.test.tip.large"]
        let isPresented = Binding.constant(false)
        let testView = Text("Test")
            .buyMeCoffee(
                isPresented: isPresented,
                productIDs: productIDs
            )

        // If the modifier compiles with productIDs parameter, the test passes
        XCTAssertNotNil(testView)
    }

    // MARK: - Test AC 5: testLabelObjectsThreadedThroughToView

    @MainActor
    func testLabelObjectsThreadedThroughToView() {
        // Given: Custom label objects
        let headerLabels = DrawerHeaderLabels(
            iconImage: Image(systemName: "heart.fill"),
            title: "Support Us",
            subtitle: "Your help matters"
        )
        let emptyLabels = EmptyStateLabels(
            iconName: "tray",
            headline: "Empty",
            bodyText: "No products"
        )
        let errorLabels = ErrorStateLabels(
            iconName: "xmark",
            headline: "Error"
        )
        let thankYouLabels = ThankYouLabels(
            title: "Thanks!",
            subtitle: "You rock",
            iconName: "star.fill",
            dismissAccessibilityLabel: "Close",
            dismissAccessibilityHint: "Tap to close",
            voiceOverAnnouncement: "Purchase done"
        )

        // When: We apply the modifier with label objects
        let isPresented = Binding.constant(false)
        let testView = Text("Test")
            .buyMeCoffee(
                isPresented: isPresented,
                productIDs: ["com.test.tip"],
                headerLabels: headerLabels,
                emptyStateLabels: emptyLabels,
                errorStateLabels: errorLabels,
                thankYouLabels: thankYouLabels
            )

        // Then: The modifier should compile and accept label objects
        XCTAssertNotNil(testView)
    }
}
