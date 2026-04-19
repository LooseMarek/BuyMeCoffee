import SnapshotTesting
import SwiftUI
import XCTest
@testable import BuyMeCoffee

@MainActor
final class DrawerHeaderViewSnapshotTests: XCTestCase {

    // MARK: - Test AC 1: testDrawerHeaderView_defaultTheme

    func testDrawerHeaderView_defaultTheme() {
        // Given - a drawer header with default theme and sample content
        let testView = DrawerHeaderView(
            labels: DrawerHeaderLabels(
                iconImage: Image(systemName: "cup.and.saucer.fill"),
                title: "Buy Me a Coffee",
                subtitle: "Support my work with a small tip"
            )
        )
        .environment(\.buyMeCoffeeTheme, .default)
        .frame(width: 360)
        .padding()
        .background(BuyMeCoffeeTheme.default.backgroundColor)

        // Then - the snapshot shows the header with default theme colors
#if canImport(AppKit)
        let hostingView = NSHostingView(rootView: testView)
        hostingView.frame = NSRect(x: 0, y: 0, width: 360, height: 120)
        assertSnapshot(of: hostingView, as: .image(perceptualPrecision: 0.95), named: "defaultTheme-macOS")
#elseif canImport(UIKit)
        let hostingController = UIHostingController(rootView: testView)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 360, height: 120)
        assertSnapshot(of: hostingController.view, as: .image(perceptualPrecision: 0.98), named: "defaultTheme-iOS")
#endif
    }

    // MARK: - Test AC 2: testDrawerHeaderView_customTheme

    func testDrawerHeaderView_customTheme() {
        // Given - a custom theme with distinctive purple accent colors
        let customTheme = BuyMeCoffeeTheme(
            backgroundColor: Color(red: 0x16 / 255.0, green: 0x18 / 255.0, blue: 0x2A / 255.0),
            primaryTextColor: Color(red: 0xFF / 255.0, green: 0xD7 / 255.0, blue: 0x00 / 255.0), // Gold
            secondaryTextColor: Color(red: 0xFF / 255.0, green: 0xA5 / 255.0, blue: 0x00 / 255.0), // Orange
            accentStartColor: .purple,
            accentEndColor: .pink,
            productRowBackgroundColor: Color(red: 0x1F / 255.0, green: 0x22 / 255.0, blue: 0x35 / 255.0),
            separatorColor: Color(red: 0x2E / 255.0, green: 0x31 / 255.0, blue: 0x50 / 255.0),
            surfaceElevatedColor: Color(red: 0x27 / 255.0, green: 0x2A / 255.0, blue: 0x40 / 255.0),
            textOnAccentColor: .white,
            successColor: Color(red: 0x52 / 255.0, green: 0xD3 / 255.0, blue: 0x8C / 255.0),
            errorColor: Color(red: 0xE0 / 255.0, green: 0x52 / 255.0, blue: 0x52 / 255.0)
        )

        // When - the header is rendered with the custom theme
        let testView = DrawerHeaderView(
            labels: DrawerHeaderLabels(
                iconImage: Image(systemName: "heart.fill"),
                title: "Support This App",
                subtitle: "Your tips help keep development going"
            )
        )
        .environment(\.buyMeCoffeeTheme, customTheme)
        .frame(width: 360)
        .padding()
        .background(customTheme.backgroundColor)

        // Then - the snapshot shows the custom theme colors applied
#if canImport(AppKit)
        let hostingView = NSHostingView(rootView: testView)
        hostingView.frame = NSRect(x: 0, y: 0, width: 360, height: 120)
        assertSnapshot(of: hostingView, as: .image(perceptualPrecision: 0.95), named: "customTheme-macOS")
#elseif canImport(UIKit)
        let hostingController = UIHostingController(rootView: testView)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 360, height: 120)
        assertSnapshot(of: hostingController.view, as: .image(perceptualPrecision: 0.98), named: "customTheme-iOS")
#endif
    }
}
