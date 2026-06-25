import XCTest
import SwiftUI
import SnapshotTesting
@testable import BuyMeCoffee

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

final class EmptyStateViewSnapshotTests: XCTestCase {

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
    func testEmptyStateView_defaultTheme_iOS() {
        // Given
        let theme = BuyMeCoffeeTheme.default
        let view = EmptyStateView(onDismiss: {})
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
    func testEmptyStateView_customTheme_iOS() {
        // Given
        let view = EmptyStateView(
            labels: EmptyStateLabels(
                iconName: "tray",
                headline: "Nothing here yet",
                bodyText: "Custom empty state message for demonstration."
            ),
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
    func testEmptyStateView_defaultTheme_macOS() {
        // Given
        let theme = BuyMeCoffeeTheme.default
        let view = EmptyStateView(onDismiss: {})
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
    func testEmptyStateView_customTheme_macOS() {
        // Given
        let view = EmptyStateView(
            labels: EmptyStateLabels(
                iconName: "tray",
                headline: "Nothing here yet",
                bodyText: "Custom empty state message for demonstration."
            ),
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
