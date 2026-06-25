import XCTest
import SwiftUI
import SnapshotTesting
@testable import BuyMeCoffee

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

final class ErrorStateViewSnapshotTests: XCTestCase {

    // MARK: - Test Data

    private let customTheme = BuyMeCoffeeTheme(
        backgroundColor: .white,
        primaryTextColor: .black,
        secondaryTextColor: .gray,
        accentStartColor: .blue,
        accentEndColor: .purple,
        productRowBackgroundColor: .white,
        separatorColor: Color.gray.opacity(0.3),
        surfaceElevatedColor: Color.gray.opacity(0.1),
        textOnAccentColor: .white,
        successColor: .green,
        errorColor: .red
    )

    // MARK: - iOS Snapshots

    #if os(iOS)
    @MainActor
    func testErrorStateView_defaultTheme_iOS() {
        // Given
        let theme = BuyMeCoffeeTheme.default
        let view = ErrorStateView(onDismiss: {})
            .environment(\.buyMeCoffeeTheme, theme)
            .frame(width: 375, height: 200)

        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 200)

        // When / Then
        assertSnapshot(
            of: hostingController.view,
            as: .image,
            named: "defaultTheme-iOS"
        )
    }

    @MainActor
    func testErrorStateView_customTheme_iOS() {
        // Given
        let view = ErrorStateView(
            labels: ErrorStateLabels(iconName: "wifi.slash", headline: "Connection failed"),
            errorMessage: "Custom error message for demonstration.",
            onDismiss: {}
        )
            .environment(\.buyMeCoffeeTheme, customTheme)
            .frame(width: 375, height: 200)

        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 200)

        // When / Then
        assertSnapshot(
            of: hostingController.view,
            as: .image,
            named: "customTheme-iOS"
        )
    }
    #endif

    // MARK: - macOS Snapshots

    #if os(macOS)
    @MainActor
    func testErrorStateView_defaultTheme_macOS() {
        // Given
        let theme = BuyMeCoffeeTheme.default
        let view = ErrorStateView(onDismiss: {})
            .environment(\.buyMeCoffeeTheme, theme)
            .frame(width: 375, height: 200)

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: 375, height: 200)

        // When / Then
        assertSnapshot(
            of: hostingView,
            as: .image,
            named: "defaultTheme-macOS"
        )
    }

    @MainActor
    func testErrorStateView_customTheme_macOS() {
        // Given
        let view = ErrorStateView(
            labels: ErrorStateLabels(iconName: "wifi.slash", headline: "Connection failed"),
            errorMessage: "Custom error message for demonstration.",
            onDismiss: {}
        )
            .environment(\.buyMeCoffeeTheme, customTheme)
            .frame(width: 375, height: 200)

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: 375, height: 200)

        // When / Then
        assertSnapshot(
            of: hostingView,
            as: .image,
            named: "customTheme-macOS"
        )
    }
    #endif
}
