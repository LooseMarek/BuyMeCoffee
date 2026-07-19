import XCTest
import SwiftUI
@testable import BuyMeCoffee

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Unit tests for `BuyMeCoffeeInlineView` — the embeddable tip list component.
///
/// These verify that the inline view reuses the same `TipListViewModel` engine as the drawer
/// (no duplicated fetch/purchase logic) and works end-to-end with a `MockProductProvider`,
/// with no live StoreKit calls.
final class BuyMeCoffeeInlineViewTests: XCTestCase {

    // MARK: - Construction

    /// Verifies construction succeeds with a live-style injected `ProductProvider`.
    @MainActor
    func testInitAcceptsProviderAndProductIDs() {
        let mockProvider = MockProductProvider(products: [], purchaseOutcome: .success)

        let view = BuyMeCoffeeInlineView(
            provider: mockProvider,
            productIDs: ["test.coffee.small", "test.coffee.large"]
        )

        XCTAssertNotNil(view)
    }

    // MARK: - Shared View Model

    /// Verifies the inline view fetches via the SAME view-model type as the drawer
    /// (`TipListViewModel`), so behaviour stays in parity and no fetch logic is duplicated.
    @MainActor
    func testUsesSharedTipListViewModel() async {
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small", description: "Desc", displayPrice: "$1", price: 1),
            TipProduct(id: "test.coffee.large", displayName: "Large", description: "Desc", displayPrice: "$2", price: 2),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)

        // A TipListViewModel — the same shared engine the drawer uses — is injected.
        let viewModel = TipListViewModel(provider: mockProvider, productIDs: ["test.coffee.small", "test.coffee.large"])
        let view = BuyMeCoffeeInlineView(viewModel: viewModel)

        XCTAssertNotNil(view)
        XCTAssertEqual(viewModel.state, .loading)

        await viewModel.fetchProducts()

        if case .loaded(let products) = viewModel.state {
            XCTAssertEqual(products.count, 2)
        } else {
            XCTFail("Expected state to be .loaded, got \(viewModel.state)")
        }
    }

    // MARK: - Mock Provider End-to-End

    /// Verifies mock injection works end-to-end, synchronously, with no live StoreKit calls,
    /// producing the expected ordered set of products.
    @MainActor
    func testMockProviderProducesExpectedRows() async {
        // Provider returns products out of price order; the view model should sort ascending.
        let mockProducts = [
            TipProduct(id: "test.coffee.large", displayName: "Large Coffee", description: "A large cup", displayPrice: "$2.99", price: 2.99),
            TipProduct(id: "test.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99", price: 0.99),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: mockProvider, productIDs: ["test.coffee.large", "test.coffee.small"])

        _ = BuyMeCoffeeInlineView(viewModel: viewModel)

        await viewModel.fetchProducts()

        guard case .loaded(let products) = viewModel.state else {
            XCTFail("Expected .loaded state, got \(viewModel.state)")
            return
        }

        XCTAssertEqual(products.map(\.id), ["test.coffee.small", "test.coffee.large"], "Products should be sorted ascending by price")
    }

    // MARK: - Header Toggle

    /// Verifies `showHeader` defaults to `true`, giving parity with the drawer's always-visible
    /// header when a host does not explicitly opt out.
    @MainActor
    func testShowHeaderDefaultsToTrue() {
        let mockProvider = MockProductProvider(products: [], purchaseOutcome: .success)

        let view = BuyMeCoffeeInlineView(
            provider: mockProvider,
            productIDs: ["test.coffee.small"]
        )

        XCTAssertTrue(view.showHeader, "showHeader should default to true for drawer parity")
    }

    /// Verifies that when `showHeader` is `true`, the view is configured to render the header and
    /// the supplied `DrawerHeaderLabels` are stored for the header to consume. The view is hosted
    /// and laid out to prove the header renders without crashing.
    @MainActor
    func testShowHeaderTrueRendersHeader() {
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small", description: "Desc", displayPrice: "$1", price: 1),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: mockProvider, productIDs: ["test.coffee.small"])
        viewModel.state = .loaded(mockProducts)

        let customLabels = DrawerHeaderLabels(title: "Support Us", subtitle: "Thanks!")
        let view = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: true, headerLabels: customLabels)

        XCTAssertTrue(view.showHeader, "showHeader should be true")
        XCTAssertEqual(view.headerLabels.title, "Support Us", "Supplied header labels should be stored")
        XCTAssertEqual(view.headerLabels.subtitle, "Thanks!", "Supplied header labels should be stored")

        assertRendersWithoutCrash(view)
    }

    /// Verifies that when `showHeader` is `false`, the view is configured to omit the header.
    @MainActor
    func testShowHeaderFalseHidesHeader() {
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small", description: "Desc", displayPrice: "$1", price: 1),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: mockProvider, productIDs: ["test.coffee.small"])
        viewModel.state = .loaded(mockProducts)

        let view = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: false)

        XCTAssertFalse(view.showHeader, "showHeader should be false")

        assertRendersWithoutCrash(view)
    }

    /// Verifies the macOS header dismiss control, when shown inside the embedded inline view,
    /// is wired to a no-op — hosting and laying out the view with a visible header in a context
    /// that has no sheet presentation must not crash (there is no `\.dismiss` to call).
    @MainActor
    func testHeaderDismissControlIsNoOpWhenEmbedded() {
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small", description: "Desc", displayPrice: "$1", price: 1),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: mockProvider, productIDs: ["test.coffee.small"])
        viewModel.state = .loaded(mockProducts)

        // Header shown, but there is no enclosing sheet — must not attempt to dismiss / crash.
        let view = BuyMeCoffeeInlineView(viewModel: viewModel, showHeader: true)

        assertRendersWithoutCrash(view)
    }

    // MARK: - Background

    /// Verifies the inline view's background defaults to `.transparent`, so the host app's own
    /// background shows through unless the host opts into a solid colour. This is the key
    /// divergence from the drawer, which always fills `theme.backgroundColor`.
    @MainActor
    func testDefaultBackgroundIsTransparent() {
        let mockProvider = MockProductProvider(products: [], purchaseOutcome: .success)

        let view = BuyMeCoffeeInlineView(
            provider: mockProvider,
            productIDs: ["test.coffee.small"]
        )

        XCTAssertEqual(view.background, .transparent, "Inline view background should default to .transparent")
        XCTAssertEqual(
            BuyMeCoffeeInlineBackground.transparent.resolvedColor(theme: .default),
            .clear,
            ".transparent must resolve to Color.clear regardless of theme"
        )
    }

    /// Verifies that when a host supplies a `.custom` colour, the view stores it and it resolves
    /// to exactly that colour (independent of the theme's own background).
    @MainActor
    func testCustomBackgroundColorApplied() {
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small", description: "Desc", displayPrice: "$1", price: 1),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: mockProvider, productIDs: ["test.coffee.small"])
        viewModel.state = .loaded(mockProducts)

        let view = BuyMeCoffeeInlineView(viewModel: viewModel, background: .custom(.red))

        XCTAssertEqual(view.background, .custom(.red), "Supplied custom background should be stored")
        XCTAssertEqual(
            BuyMeCoffeeInlineBackground.custom(.red).resolvedColor(theme: .default),
            .red,
            ".custom(color) must resolve to that exact colour"
        )

        assertRendersWithoutCrash(view)
    }

    /// Verifies the `.themed` option resolves to the environment theme's own `backgroundColor`,
    /// giving drawer-parity background without changing `BuyMeCoffeeTheme` itself.
    @MainActor
    func testThemedBackgroundOptionAppliesThemeBackgroundColor() {
        let mockProducts = [
            TipProduct(id: "test.coffee.small", displayName: "Small", description: "Desc", displayPrice: "$1", price: 1),
        ]
        let mockProvider = MockProductProvider(products: mockProducts, purchaseOutcome: .success)
        let viewModel = TipListViewModel(provider: mockProvider, productIDs: ["test.coffee.small"])
        viewModel.state = .loaded(mockProducts)

        let view = BuyMeCoffeeInlineView(viewModel: viewModel, background: .themed)

        XCTAssertEqual(view.background, .themed, "Supplied themed background should be stored")
        XCTAssertEqual(
            BuyMeCoffeeInlineBackground.themed.resolvedColor(theme: .default),
            BuyMeCoffeeTheme.default.backgroundColor,
            ".themed must resolve to the theme's own backgroundColor"
        )

        assertRendersWithoutCrash(view)
    }

    // MARK: - Rendering Helper

    /// Hosts a view in a platform hosting container and forces a layout pass, proving the view's
    /// `body` (including any header) evaluates without crashing outside a sheet presentation.
    @MainActor
    private func assertRendersWithoutCrash(_ view: some View) {
        #if os(iOS)
        let controller = UIHostingController(rootView: view)
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 400)
        controller.view.layoutIfNeeded()
        XCTAssertNotNil(controller.view)
        #elseif os(macOS)
        let hosting = NSHostingView(rootView: view)
        hosting.frame = NSRect(x: 0, y: 0, width: 390, height: 400)
        hosting.layoutSubtreeIfNeeded()
        XCTAssertNotNil(hosting)
        #endif
    }
}
