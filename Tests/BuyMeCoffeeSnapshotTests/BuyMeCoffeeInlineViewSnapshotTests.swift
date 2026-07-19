import XCTest
import SnapshotTesting
import SwiftUI
@testable import BuyMeCoffee

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Snapshot tests for `BuyMeCoffeeInlineView` — the embeddable tip list component.
///
/// Unlike the drawer snapshots, the inline view is rendered inside a plain host container
/// (a `VStack` on a normal background, NOT a sheet) to verify it presents no sheet/modal
/// chrome and inherits the host's background.
@MainActor
final class BuyMeCoffeeInlineViewSnapshotTests: XCTestCase {

    private let provider: ProductProvider = MockProductProvider(products: [])
    private let productIDs: [String] = []

    private let loadedProducts = [
        TipProduct(id: "test.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99", price: 0.99),
        TipProduct(id: "test.coffee.large", displayName: "Large Coffee", description: "A large cup", displayPrice: "$2.99", price: 2.99),
    ]

    /// A custom theme with distinctive accent colours, matching the definition used in
    /// `BuyMeCoffeeSnapshotTests`.
    private let customTheme = BuyMeCoffeeTheme(
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

    // MARK: - Helpers

    /// Embeds the inline view inside a plain host layout — a VStack on a normal background,
    /// with surrounding host content, so the snapshot proves there is no sheet/modal chrome.
    private func host<Content: View>(_ inlineView: Content) -> some View {
        VStack(spacing: 16) {
            Text("Host App Content")
            inlineView
            Text("More Host Content")
        }
        .padding(.vertical, 24)
        .frame(width: 390)
        .background(Color.white)
    }

    // MARK: - Loaded State

    func testLoadedState_iOS() {
        #if os(iOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: host(inlineView))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingController.view, as: .image, named: "loadedState-iOS")
        #endif
    }

    func testLoadedState_macOS() {
        #if os(macOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel)
        let hostingView = NSHostingView(rootView: host(inlineView))
        hostingView.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingView, as: .image, named: "loadedState-macOS")
        #endif
    }

    // MARK: - Custom Theme

    func testCustomTheme_iOS() {
        #if os(iOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel)
            .environment(\.buyMeCoffeeTheme, customTheme)
        let hostingController = UIHostingController(rootView: host(inlineView))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingController.view, as: .image, named: "customTheme-iOS")
        #endif
    }

    func testCustomTheme_macOS() {
        #if os(macOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel)
            .environment(\.buyMeCoffeeTheme, customTheme)
        let hostingView = NSHostingView(rootView: host(inlineView))
        hostingView.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingView, as: .image, named: "customTheme-macOS")
        #endif
    }
}
