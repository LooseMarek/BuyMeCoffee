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

    /// Embeds the inline view over a distinctive, non-default (yellow) host background so that a
    /// transparent inline background lets the host colour show through, while a solid/custom inline
    /// background visibly covers it. Used by the background-focused snapshots.
    private func transparencyHost<Content: View>(_ inlineView: Content) -> some View {
        VStack(spacing: 16) {
            Text("Host App Content")
            inlineView
            Text("More Host Content")
        }
        .padding(.vertical, 24)
        .frame(width: 390)
        .background(Color.yellow)
    }

    // MARK: - Loaded State

    func testLoadedState_iOS() {
        #if os(iOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        // Explicit `showHeader: false` preserves this test's original bare-list intent now that
        // the inline view defaults `showHeader` to `true`. Header coverage lives in testWithHeader.
        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: false)
        let hostingController = UIHostingController(rootView: host(inlineView))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingController.view, as: .image, named: "loadedState-iOS")
        #endif
    }

    func testLoadedState_macOS() {
        #if os(macOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        // Explicit `showHeader: false` preserves this test's original bare-list intent now that
        // the inline view defaults `showHeader` to `true`. Header coverage lives in testWithHeader.
        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: false)
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

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: false)
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

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: false)
            .environment(\.buyMeCoffeeTheme, customTheme)
        let hostingView = NSHostingView(rootView: host(inlineView))
        hostingView.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingView, as: .image, named: "customTheme-macOS")
        #endif
    }

    // MARK: - With Header

    func testWithHeader_iOS() {
        #if os(iOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: true)
        let hostingController = UIHostingController(rootView: host(inlineView))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 500)
        assertSnapshot(of: hostingController.view, as: .image, named: "withHeader-iOS")
        #endif
    }

    func testWithHeader_macOS() {
        #if os(macOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: true)
        let hostingView = NSHostingView(rootView: host(inlineView))
        hostingView.frame = NSRect(x: 0, y: 0, width: 390, height: 500)
        assertSnapshot(of: hostingView, as: .image, named: "withHeader-macOS")
        #endif
    }

    // MARK: - Transparent Background (default)

    /// Rendered over a non-default (yellow) host background to visually confirm the inline view's
    /// default `.transparent` background lets the host colour show through behind the tip rows.
    func testTransparentBackground_iOS() {
        #if os(iOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: false)
        let hostingController = UIHostingController(rootView: transparencyHost(inlineView))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingController.view, as: .image, named: "transparentBackground-iOS")
        #endif
    }

    func testTransparentBackground_macOS() {
        #if os(macOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: false)
        let hostingView = NSHostingView(rootView: transparencyHost(inlineView))
        hostingView.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingView, as: .image, named: "transparentBackground-macOS")
        #endif
    }

    // MARK: - Custom Background Colour

    /// A host supplies a solid custom background colour; the inline view fills that colour behind
    /// the rows instead of letting the host background show through.
    func testCustomBackgroundColor_iOS() {
        #if os(iOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, background: .custom(.green), showHeader: false)
        let hostingController = UIHostingController(rootView: transparencyHost(inlineView))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingController.view, as: .image, named: "customBackgroundColor-iOS")
        #endif
    }

    func testCustomBackgroundColor_macOS() {
        #if os(macOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, background: .custom(.green), showHeader: false)
        let hostingView = NSHostingView(rootView: transparencyHost(inlineView))
        hostingView.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingView, as: .image, named: "customBackgroundColor-macOS")
        #endif
    }

    // MARK: - Transparent Background — No Padding (flush layout)

    /// With the default `.transparent` background there is no visible card edge, so the inline
    /// content must sit flush against the host layout with no surrounding padding. Rendered over a
    /// non-default (yellow) host background — both with and without the header — so the flush,
    /// no-inset layout is visible against the host colour.
    func testTransparentBackgroundNoPadding_iOS() {
        #if os(iOS)
        let withHeaderViewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        withHeaderViewModel.state = .loaded(loadedProducts)
        let withHeaderView = BuyMeCoffeeInlineView(viewModel: withHeaderViewModel, background: .transparent, showHeader: true)
        let withHeaderController = UIHostingController(rootView: transparencyHost(withHeaderView))
        withHeaderController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 500)
        assertSnapshot(of: withHeaderController.view, as: .image, named: "transparentNoPaddingWithHeader-iOS")

        let noHeaderViewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        noHeaderViewModel.state = .loaded(loadedProducts)
        let noHeaderView = BuyMeCoffeeInlineView(viewModel: noHeaderViewModel, background: .transparent, showHeader: false)
        let noHeaderController = UIHostingController(rootView: transparencyHost(noHeaderView))
        noHeaderController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: noHeaderController.view, as: .image, named: "transparentNoPaddingNoHeader-iOS")
        #endif
    }

    func testTransparentBackgroundNoPadding_macOS() {
        #if os(macOS)
        let withHeaderViewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        withHeaderViewModel.state = .loaded(loadedProducts)
        let withHeaderView = BuyMeCoffeeInlineView(viewModel: withHeaderViewModel, background: .transparent, showHeader: true)
        let withHeaderHosting = NSHostingView(rootView: transparencyHost(withHeaderView))
        withHeaderHosting.frame = NSRect(x: 0, y: 0, width: 390, height: 500)
        assertSnapshot(of: withHeaderHosting, as: .image, named: "transparentNoPaddingWithHeader-macOS")

        let noHeaderViewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        noHeaderViewModel.state = .loaded(loadedProducts)
        let noHeaderView = BuyMeCoffeeInlineView(viewModel: noHeaderViewModel, background: .transparent, showHeader: false)
        let noHeaderHosting = NSHostingView(rootView: transparencyHost(noHeaderView))
        noHeaderHosting.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: noHeaderHosting, as: .image, named: "transparentNoPaddingNoHeader-macOS")
        #endif
    }

    // MARK: - Thank-You State

    func testThankYouState_iOS() {
        #if os(iOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .thankYou

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: host(inlineView))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingController.view, as: .image, named: "inlineThankYouState-iOS")
        #endif
    }

    func testThankYouState_macOS() {
        #if os(macOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .thankYou

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel)
        let hostingView = NSHostingView(rootView: host(inlineView))
        hostingView.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingView, as: .image, named: "inlineThankYouState-macOS")
        #endif
    }

    // MARK: - Empty State

    func testEmptyState_iOS() {
        #if os(iOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .empty

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: host(inlineView))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingController.view, as: .image, named: "inlineEmptyState-iOS")
        #endif
    }

    func testEmptyState_macOS() {
        #if os(macOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .empty

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel)
        let hostingView = NSHostingView(rootView: host(inlineView))
        hostingView.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingView, as: .image, named: "inlineEmptyState-macOS")
        #endif
    }

    // MARK: - Error State

    func testErrorState_iOS() {
        #if os(iOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .error("Something went wrong. Please try again later.")

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: host(inlineView))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingController.view, as: .image, named: "inlineErrorState-iOS")
        #endif
    }

    func testErrorState_macOS() {
        #if os(macOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .error("Something went wrong. Please try again later.")

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel)
        let hostingView = NSHostingView(rootView: host(inlineView))
        hostingView.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingView, as: .image, named: "inlineErrorState-macOS")
        #endif
    }

    // MARK: - Without Header

    func testWithoutHeader_iOS() {
        #if os(iOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: false)
        let hostingController = UIHostingController(rootView: host(inlineView))
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingController.view, as: .image, named: "withoutHeader-iOS")
        #endif
    }

    func testWithoutHeader_macOS() {
        #if os(macOS)
        let viewModel = TipListViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded(loadedProducts)

        let inlineView = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: false)
        let hostingView = NSHostingView(rootView: host(inlineView))
        hostingView.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        assertSnapshot(of: hostingView, as: .image, named: "withoutHeader-macOS")
        #endif
    }
}
