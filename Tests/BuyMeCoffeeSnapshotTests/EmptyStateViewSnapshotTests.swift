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

    // MARK: - iOS Snapshots

    #if os(iOS)
    @MainActor
    func testEmptyStateView_defaultTheme_iOS() {
        // Given
        let theme = BuyMeCoffeeTheme.default
        let view = EmptyStateView()
            .environment(\.buyMeCoffeeTheme, theme)
            .frame(width: 375, height: 200)

        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 200)

        // When / Then
        assertSnapshot(
            of: hostingController.view,
            as: .image(perceptualPrecision: 0.98),
            named: "defaultTheme-iOS"
        )
    }
    #endif

    // MARK: - macOS Snapshots

    #if os(macOS)
    @MainActor
    func testEmptyStateView_defaultTheme_macOS() {
        // Given
        let theme = BuyMeCoffeeTheme.default
        let view = EmptyStateView()
            .environment(\.buyMeCoffeeTheme, theme)
            .frame(width: 375, height: 200)

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: 375, height: 200)

        // When / Then
        assertSnapshot(
            of: hostingView,
            as: .image(perceptualPrecision: 0.95),
            named: "defaultTheme-macOS"
        )
    }
    #endif
}
