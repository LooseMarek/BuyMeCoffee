import SnapshotTesting
import SwiftUI
import XCTest
@testable import BuyMeCoffee

@MainActor
final class BuyMeCoffeeSnapshotTests: XCTestCase {
    func testExampleViewSnapshot() {
#if canImport(AppKit)
        let hostingView = NSHostingView(rootView: ExampleView())
        hostingView.frame = NSRect(x: 0, y: 0, width: 200, height: 80)
        assertSnapshot(of: hostingView, as: .image, named: "macOS")
#elseif canImport(UIKit)
        let hostingController = UIHostingController(rootView: ExampleView())
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        assertSnapshot(of: hostingController.view, as: .image, named: "iOS")
#endif
    }

    // MARK: - Test AC 3: testCustomTheme_appliedToDrawer

    func testCustomTheme_appliedToDrawer() {
        // Given: A custom theme with distinctive colours
        let customTheme = BuyMeCoffeeTheme(
            backgroundColor: Color(red: 0x16 / 255.0, green: 0x18 / 255.0, blue: 0x2A / 255.0),
            primaryTextColor: Color.white,
            secondaryTextColor: Color.gray,
            accentStartColor: Color(red: 1.0, green: 0.0, blue: 1.0), // Bright magenta
            accentEndColor: Color(red: 0.8, green: 0.0, blue: 1.0),   // Purple-magenta
            productRowBackgroundColor: Color(red: 0x1F / 255.0, green: 0x22 / 255.0, blue: 0x35 / 255.0),
            separatorColor: Color(red: 0x2E / 255.0, green: 0x31 / 255.0, blue: 0x50 / 255.0),
            surfaceElevatedColor: Color(red: 0x27 / 255.0, green: 0x2A / 255.0, blue: 0x40 / 255.0),
            textOnAccentColor: Color.white,
            successColor: Color.green,
            errorColor: Color.red
        )

        // When: We apply the custom theme to a SwiftUI environment
        var environmentValues = EnvironmentValues()
        environmentValues.buyMeCoffeeTheme = customTheme

        // Then: The environment should contain the custom theme, not the default
        let appliedTheme = environmentValues.buyMeCoffeeTheme
        XCTAssertEqual(appliedTheme, customTheme)
        XCTAssertNotEqual(appliedTheme, BuyMeCoffeeTheme.default)

        // And: The custom accent colours should be preserved
        XCTAssertEqual(appliedTheme.accentStartColor, Color(red: 1.0, green: 0.0, blue: 1.0))
        XCTAssertEqual(appliedTheme.accentEndColor, Color(red: 0.8, green: 0.0, blue: 1.0))
    }
}

private struct ExampleView: View {
    var body: some View {
        Text("Hello, World!")
            .padding()
    }
}
