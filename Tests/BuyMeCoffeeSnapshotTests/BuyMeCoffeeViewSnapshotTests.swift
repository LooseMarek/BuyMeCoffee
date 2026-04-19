import XCTest
import SnapshotTesting
import SwiftUI
@testable import BuyMeCoffee

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Snapshot tests for BuyMeCoffeeView on both iOS and macOS platforms.
final class BuyMeCoffeeViewSnapshotTests: XCTestCase {

    // MARK: - Loaded State

    /// Snapshot test for loaded state with mock products on iOS.
    func testBuyMeCoffeeView_loadedState_iOS() {
        #if os(iOS)
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99"),
            TipProduct(id: "test.coffee.large", displayName: "Large Coffee", description: "A large cup", displayPrice: "$2.99"),
        ]

        let view = ScrollView {
            VStack(spacing: 0) {
                DrawerHeaderView(
                    labels: DrawerHeaderLabels(
                        iconImage: Image(systemName: "cup.and.saucer.fill"),
                        title: "Buy Me a Coffee",
                        subtitle: "Support my work with a small tip"
                    ),
                    onDismiss: {}
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)

                VStack(spacing: 12) {
                    ForEach(Array(mockProducts.enumerated()), id: \.element.id) { _, product in
                        ProductRowView(product: product) {}
                    }
                }
                .padding(16)
            }
        }
        .background(BuyMeCoffeeTheme.default.backgroundColor)
        .environment(\.buyMeCoffeeTheme, .default)
        .frame(width: 375, height: 500)

        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 500)

        assertSnapshot(of: hostingController, as: .image(perceptualPrecision: 0.98), named: "loadedState-iOS")
        #endif
    }

    /// Snapshot test for loaded state with mock products on macOS.
    func testBuyMeCoffeeView_loadedState_macOS() {
        #if os(macOS)
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99"),
            TipProduct(id: "test.coffee.large", displayName: "Large Coffee", description: "A large cup", displayPrice: "$2.99"),
        ]

        let view = ScrollView {
            VStack(spacing: 0) {
                DrawerHeaderView(
                    labels: DrawerHeaderLabels(
                        iconImage: Image(systemName: "cup.and.saucer.fill"),
                        title: "Buy Me a Coffee",
                        subtitle: "Support my work with a small tip"
                    ),
                    onDismiss: {}
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 8)

                VStack(spacing: 12) {
                    ForEach(Array(mockProducts.enumerated()), id: \.element.id) { _, product in
                        ProductRowView(product: product) {}
                    }
                }
                .padding(16)
            }
        }
        .background(BuyMeCoffeeTheme.default.backgroundColor)
        .environment(\.buyMeCoffeeTheme, .default)
        .frame(width: 360, height: 500)

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: 360, height: 500)

        assertSnapshot(of: hostingView, as: .image(perceptualPrecision: 0.95), named: "loadedState-macOS")
        #endif
    }

    // MARK: - Empty State

    /// Snapshot test for empty state on iOS.
    func testBuyMeCoffeeView_emptyState_iOS() {
        #if os(iOS)
        // Snapshot EmptyStateView directly to avoid async loading state
        let view = EmptyStateView(onDismiss: {})
            .environment(\.buyMeCoffeeTheme, .default)
            .frame(width: 375, height: 200)

        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 200)

        assertSnapshot(of: hostingController, as: .image(perceptualPrecision: 0.98), named: "emptyState-iOS")
        #endif
    }

    /// Snapshot test for empty state on macOS.
    func testBuyMeCoffeeView_emptyState_macOS() {
        #if os(macOS)
        // Snapshot EmptyStateView directly to avoid async loading state
        let view = EmptyStateView(onDismiss: {})
            .environment(\.buyMeCoffeeTheme, .default)
            .frame(width: 360, height: 200)

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: 360, height: 200)

        assertSnapshot(of: hostingView, as: .image(perceptualPrecision: 0.95), named: "emptyState-macOS")
        #endif
    }

    // MARK: - Error State

    /// Snapshot test for error state on iOS.
    func testBuyMeCoffeeView_errorState_iOS() {
        #if os(iOS)
        // Snapshot ErrorStateView directly
        let view = ErrorStateView(onDismiss: {})
            .environment(\.buyMeCoffeeTheme, .default)
            .frame(width: 375, height: 200)

        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 200)

        assertSnapshot(of: hostingController, as: .image(perceptualPrecision: 0.98), named: "errorState-iOS")
        #endif
    }

    /// Snapshot test for error state on macOS.
    func testBuyMeCoffeeView_errorState_macOS() {
        #if os(macOS)
        // Snapshot ErrorStateView directly
        let view = ErrorStateView(onDismiss: {})
            .environment(\.buyMeCoffeeTheme, .default)
            .frame(width: 360, height: 200)

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: 360, height: 200)

        assertSnapshot(of: hostingView, as: .image(perceptualPrecision: 0.95), named: "errorState-macOS")
        #endif
    }

    // MARK: - Thank You State

    /// Snapshot test for thank-you state on iOS.
    func testBuyMeCoffeeView_thankYouState_iOS() {
        #if os(iOS)
        // For snapshot testing the thank-you state, we'll use a simplified view
        // that directly shows ThankYouView since triggering a purchase in a snapshot test is complex
        let view = ThankYouView(onDismiss: {})
            .environment(\.buyMeCoffeeTheme, .default)
            .frame(width: 375, height: 600)

        let hostingController = UIHostingController(rootView: view)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 600)

        assertSnapshot(of: hostingController, as: .image(perceptualPrecision: 0.98), named: "thankYouState-iOS")
        #endif
    }

    /// Snapshot test for thank-you state on macOS.
    func testBuyMeCoffeeView_thankYouState_macOS() {
        #if os(macOS)
        // For snapshot testing the thank-you state, we'll use a simplified view
        // that directly shows ThankYouView since triggering a purchase in a snapshot test is complex
        let view = ThankYouView(onDismiss: {})
            .environment(\.buyMeCoffeeTheme, .default)
            .frame(width: 360, height: 500)

        let hostingView = NSHostingView(rootView: view)
        hostingView.frame = CGRect(x: 0, y: 0, width: 360, height: 500)

        assertSnapshot(of: hostingView, as: .image(perceptualPrecision: 0.95), named: "thankYouState-macOS")
        #endif
    }
}
