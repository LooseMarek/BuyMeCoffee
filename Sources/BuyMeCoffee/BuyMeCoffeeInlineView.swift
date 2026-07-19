import SwiftUI

/// An embeddable tip product list you can drop directly inside any host-app SwiftUI layout.
///
/// Unlike `BuyMeCoffeeView` — which is designed to be presented as a `.sheet` with header,
/// state screens, and sheet chrome — `BuyMeCoffeeInlineView` renders only the tip product row
/// list (one `ProductRowView` per product). It presents no sheet, popover, or modal chrome,
/// no header, and no separator, so you can place a tip section inline (e.g. on a settings or
/// about screen).
///
/// It is backed by the same shared `TipListViewModel` engine as the drawer, so product fetching
/// and sorting behave identically — no duplicated StoreKit/purchase logic.
///
/// ## Usage
///
/// ```swift
/// VStack {
///     Text("Enjoying the app?")
///     BuyMeCoffeeInlineView(
///         provider: StoreKitProductProvider.live(),
///         productIDs: ["com.example.tip.small", "com.example.tip.large"]
///     )
/// }
/// .environment(\.buyMeCoffeeTheme, .default)
/// ```
///
/// ## Background & Theming
///
/// The inline view intentionally does **not** paint a full-bleed background — it inherits the
/// host's background so it blends into your layout. `ProductRowView` children pick up the
/// `BuyMeCoffeeTheme` from the environment exactly like the drawer does.
///
/// ## Scope
///
/// This component renders the loaded product list. Header show/hide, background theming, and
/// full purchase/state wiring are provided by other components in this package; the inline view
/// renders rows for the `.loaded` state and nothing for other states.
public struct BuyMeCoffeeInlineView: View {

    // MARK: - Environment

    @Environment(\.buyMeCoffeeTheme) private var theme

    // MARK: - State

    @StateObject private var viewModel: TipListViewModel

    // MARK: - Sort Order

    /// The order tip products are displayed in, by price. Defaults to `.ascending`.
    let sortOrder: TipSortOrder

    // MARK: - Initializers

    /// Creates a `BuyMeCoffeeInlineView` with the specified product provider and product IDs.
    ///
    /// - Parameters:
    ///   - provider: The product provider. Use `StoreKitProductProvider.live()` for production,
    ///     or `MockProductProvider` in previews and tests.
    ///   - productIDs: The exact product IDs to fetch (e.g., ["com.example.tip.small", "com.example.tip.large"]).
    ///   - sortOrder: The order products are displayed in, by price. Defaults to `.ascending`.
    public init(
        provider: ProductProvider,
        productIDs: [String],
        sortOrder: TipSortOrder = .ascending
    ) {
        self.init(
            viewModel: TipListViewModel(provider: provider, productIDs: productIDs, sortOrder: sortOrder),
            sortOrder: sortOrder
        )
    }

    /// Creates a `BuyMeCoffeeInlineView` with a pre-configured `TipListViewModel`.
    ///
    /// Module-internal so tests (via `@testable import BuyMeCoffee`) can inject a view model in a
    /// specific state. The type is intentionally not exposed to host apps.
    init(
        viewModel: TipListViewModel,
        sortOrder: TipSortOrder = .ascending
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.sortOrder = sortOrder
    }

    // MARK: - Body

    public var body: some View {
        Group {
            switch viewModel.state {
            case .loaded(let products):
                loadedView(products: products)
            case .loading, .empty, .error, .thankYou:
                EmptyView()
            }
        }
        .task {
            await viewModel.fetchProducts()
        }
    }

    // MARK: - Subviews

    /// The tip product row list, mirroring the drawer's loaded-row block minus the header and
    /// sheet chrome: a `VStack(spacing: 12)` of `ProductRowView` rows with a 16pt horizontal
    /// inset, wrapped in a `ScrollView` like the drawer.
    private func loadedView(products: [TipProduct]) -> some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(Array(products.enumerated()), id: \.element.id) { index, product in
                    ProductRowView(product: product) {
                        Task {
                            await viewModel.purchase(product)
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .animation(
                        .easeOut(duration: 0.25).delay(Double(index) * 0.05),
                        value: viewModel.state
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Previews

#Preview("Loaded — Inline") {
    let mockProvider = MockProductProvider(
        products: [
            TipProduct(id: "mock.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99", price: 0.99),
            TipProduct(id: "mock.coffee.large", displayName: "Large Coffee", description: "A large cup", displayPrice: "$2.99", price: 2.99),
        ],
        purchaseOutcome: .success
    )

    return VStack(spacing: 16) {
        Text("Enjoying the app?")
        BuyMeCoffeeInlineView(
            provider: mockProvider,
            productIDs: ["mock.coffee.small", "mock.coffee.large"]
        )
        Text("Thanks for your support!")
    }
    .environment(\.buyMeCoffeeTheme, .default)
}
