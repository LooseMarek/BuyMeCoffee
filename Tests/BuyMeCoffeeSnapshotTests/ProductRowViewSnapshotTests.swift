import XCTest
import SwiftUI
import SnapshotTesting
@testable import BuyMeCoffee

#if os(iOS)
import UIKit
typealias PlatformView = UIView
#elseif os(macOS)
import AppKit
typealias PlatformView = NSView
#endif

final class ProductRowViewSnapshotTests: XCTestCase {

    // MARK: - Test Data

    private let sampleProduct = TipProduct(
        id: "com.example.tip.small",
        displayName: "Small Coffee",
        description: "A little thank you for your support",
        displayPrice: "$0.99"
    )

    private let longNameProduct = TipProduct(
        id: "com.example.tip.large",
        displayName: "Extra Large Premium Coffee with Extended Name That Should Truncate",
        description: "This is a very long product description that should wrap to two lines and then truncate with ellipsis at the end",
        displayPrice: "$4.99"
    )

    private let customTheme = BuyMeCoffeeTheme(
        backgroundColor: Color(red: 0.1, green: 0.1, blue: 0.15),
        primaryTextColor: Color(red: 0.95, green: 0.95, blue: 1.0),
        secondaryTextColor: Color(red: 0.6, green: 0.6, blue: 0.7),
        accentStartColor: Color(red: 0.2, green: 0.6, blue: 1.0),
        accentEndColor: Color(red: 0.4, green: 0.3, blue: 0.9),
        productRowBackgroundColor: Color(red: 0.15, green: 0.15, blue: 0.2),
        separatorColor: Color(red: 0.25, green: 0.25, blue: 0.3),
        surfaceElevatedColor: Color(red: 0.2, green: 0.2, blue: 0.25),
        textOnAccentColor: Color.white,
        successColor: Color.green,
        errorColor: Color.red
    )

    // MARK: - iOS Snapshot Tests

    #if os(iOS)
    func testProductRowView_defaultTheme_iOS() {
        let view = ProductRowView(product: sampleProduct, onTap: {})
            .environment(\.buyMeCoffeeTheme, .default)
            .background(BuyMeCoffeeTheme.default.backgroundColor)
            .frame(width: 375, height: 100)

        let hostingController = UIHostingController(rootView: view)
        hostingController.view.bounds = CGRect(x: 0, y: 0, width: 375, height: 100)

        assertSnapshot(of: hostingController, as: .image, named: "defaultTheme-iOS")
    }

    func testProductRowView_longProductName_iOS() {
        let view = ProductRowView(product: longNameProduct, onTap: {})
            .environment(\.buyMeCoffeeTheme, .default)
            .background(BuyMeCoffeeTheme.default.backgroundColor)
            .frame(width: 375, height: 100)

        let hostingController = UIHostingController(rootView: view)
        hostingController.view.bounds = CGRect(x: 0, y: 0, width: 375, height: 100)

        assertSnapshot(of: hostingController, as: .image, named: "longProductName-iOS")
    }

    func testProductRowView_customTheme_iOS() {
        let view = ProductRowView(product: sampleProduct, onTap: {})
            .environment(\.buyMeCoffeeTheme, customTheme)
            .background(customTheme.backgroundColor)
            .frame(width: 375, height: 100)

        let hostingController = UIHostingController(rootView: view)
        hostingController.view.bounds = CGRect(x: 0, y: 0, width: 375, height: 100)

        assertSnapshot(of: hostingController, as: .image, named: "customTheme-iOS")
    }
    #endif

    // MARK: - macOS Snapshot Tests

    #if os(macOS)
    func testProductRowView_defaultTheme_macOS() {
        let view = ProductRowView(product: sampleProduct, onTap: {})
            .environment(\.buyMeCoffeeTheme, .default)
            .background(BuyMeCoffeeTheme.default.backgroundColor)
            .frame(width: 375, height: 100)

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: 375, height: 100)

        assertSnapshot(of: hostingView, as: .image(perceptualPrecision: 0.95), named: "defaultTheme-macOS")
    }

    func testProductRowView_longProductName_macOS() {
        let view = ProductRowView(product: longNameProduct, onTap: {})
            .environment(\.buyMeCoffeeTheme, .default)
            .background(BuyMeCoffeeTheme.default.backgroundColor)
            .frame(width: 375, height: 100)

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: 375, height: 100)

        assertSnapshot(of: hostingView, as: .image(perceptualPrecision: 0.95), named: "longProductName-macOS")
    }

    func testProductRowView_customTheme_macOS() {
        let view = ProductRowView(product: sampleProduct, onTap: {})
            .environment(\.buyMeCoffeeTheme, customTheme)
            .background(customTheme.backgroundColor)
            .frame(width: 375, height: 100)

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: 375, height: 100)

        assertSnapshot(of: hostingView, as: .image(perceptualPrecision: 0.95), named: "customTheme-macOS")
    }
    #endif
}
