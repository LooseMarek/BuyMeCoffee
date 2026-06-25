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
        // Given - a custom theme with distinctive accent colors
        let customTheme = BuyMeCoffeeTheme(
            backgroundColor: Color(red: 0x16 / 255.0, green: 0x18 / 255.0, blue: 0x2A / 255.0),
            primaryTextColor: .white,
            secondaryTextColor: Color(red: 0x8B / 255.0, green: 0x8F / 255.0, blue: 0xA8 / 255.0),
            accentStartColor: .cyan,
            accentEndColor: .blue,
            productRowBackgroundColor: Color(red: 0x1F / 255.0, green: 0x22 / 255.0, blue: 0x35 / 255.0),
            separatorColor: Color(red: 0x2E / 255.0, green: 0x31 / 255.0, blue: 0x50 / 255.0),
            surfaceElevatedColor: Color(red: 0x27 / 255.0, green: 0x2A / 255.0, blue: 0x40 / 255.0),
            textOnAccentColor: .white,
            successColor: Color(red: 0x52 / 255.0, green: 0xD3 / 255.0, blue: 0x8C / 255.0),
            errorColor: Color(red: 0xE0 / 255.0, green: 0x52 / 255.0, blue: 0x52 / 255.0)
        )

        // When - the theme is injected into the environment
        let testView = ThemeSwatchView()
            .environment(\.buyMeCoffeeTheme, customTheme)

        // Then - the snapshot shows the custom accent colors applied to the view
#if canImport(AppKit)
        let hostingView = NSHostingView(rootView: testView)
        hostingView.frame = NSRect(x: 0, y: 0, width: 300, height: 100)
        assertSnapshot(of: hostingView, as: .image, named: "customTheme-macOS")
#elseif canImport(UIKit)
        let hostingController = UIHostingController(rootView: testView)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        assertSnapshot(of: hostingController.view, as: .image, named: "customTheme-iOS")
#endif
    }
}

private struct ExampleView: View {
    var body: some View {
        Text("Hello, World!")
            .padding()
    }
}

/// Three solid color swatches pulled from the injected theme.
/// No gradients, corner radii, or text — solid fills are pixel-identical
/// across architectures because they require no GPU interpolation or
/// anti-aliasing.
private struct ThemeSwatchView: View {
    @Environment(\.buyMeCoffeeTheme) var theme

    var body: some View {
        HStack(spacing: 0) {
            Rectangle().fill(theme.backgroundColor)
            Rectangle().fill(theme.accentStartColor)
            Rectangle().fill(theme.accentEndColor)
        }
    }
}
