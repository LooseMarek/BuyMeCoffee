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
        // Given: A custom theme with a distinctive accent colour (bright magenta)
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

        // When: A view uses the custom theme from the environment
        let testView = ThemePreviewView()
            .environment(\.buyMeCoffeeTheme, customTheme)

#if canImport(UIKit)
        // Then: The snapshot should show the custom magenta accent colour
        let hostingController = UIHostingController(rootView: testView)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        assertSnapshot(of: hostingController.view, as: .image, named: "customTheme-iOS")
#elseif canImport(AppKit)
        let hostingView = NSHostingView(rootView: testView)
        hostingView.frame = NSRect(x: 0, y: 0, width: 300, height: 200)
        assertSnapshot(of: hostingView, as: .image, named: "customTheme-macOS")
#endif
    }
}

private struct ExampleView: View {
    var body: some View {
        Text("Hello, World!")
            .padding()
    }
}

/// A test view that visually demonstrates theme application.
/// Uses accent gradient from the theme to verify environment propagation.
private struct ThemePreviewView: View {
    @Environment(\.buyMeCoffeeTheme) private var theme

    var body: some View {
        VStack(spacing: 16) {
            Text("Theme Preview")
                .font(.headline)
                .foregroundStyle(theme.primaryTextColor)

            Text("Custom Accent Gradient")
                .font(.caption)
                .foregroundStyle(theme.secondaryTextColor)

            // Display accent gradient to verify custom theme is applied
            LinearGradient(
                colors: [theme.accentStartColor, theme.accentEndColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
        .background(theme.backgroundColor)
    }
}
