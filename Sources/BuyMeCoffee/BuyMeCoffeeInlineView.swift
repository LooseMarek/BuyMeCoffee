import SwiftUI

/// An embeddable tip product list you can drop directly inside any host-app SwiftUI layout.
///
/// Unlike `BuyMeCoffeeView` — which is designed to be presented as a `.sheet` with state
/// screens and sheet chrome — `BuyMeCoffeeInlineView` renders an optional header plus the tip
/// product row list (one `ProductRowView` per product) with no sheet, popover, or modal chrome,
/// so you can place a tip section inline (e.g. on a settings or about screen).
///
/// It is backed by the same shared `TipListViewModel` engine as the drawer, so product fetching
/// and sorting behave identically — no duplicated StoreKit/purchase logic.
///
/// ## Header
///
/// By default (`showHeader: true`) the same `DrawerHeaderView` the drawer uses is rendered above
/// the rows, customisable via `headerLabels`. Because the inline view lives inside a host layout
/// with no sheet to dismiss, the header's macOS dismiss control is wired to a no-op — it is never
/// connected to `\.dismiss`. Pass `showHeader: false` to render a bare list of tip rows (no
/// header, dismiss control, or icon container) when the host screen already provides its own
/// title/context.
///
/// ## Usage
///
/// ```swift
/// VStack {
///     Text("Enjoying the app?")
///     BuyMeCoffeeInlineView(
///         provider: StoreKitProductProvider.live(),
///         productIDs: ["com.example.tip.small", "com.example.tip.large"],
///         showHeader: false
///     )
/// }
/// .environment(\.buyMeCoffeeTheme, .default)
/// ```
///
/// ## Background & Theming
///
/// The inline view's background defaults to ``BuyMeCoffeeInlineBackground/transparent`` — it does
/// **not** paint a full-bleed background, so it inherits the host's background and blends into your
/// layout. To opt into a fill, pass a `background`: use
/// ``BuyMeCoffeeInlineBackground/themed`` for drawer-parity (`theme.backgroundColor`) or
/// ``BuyMeCoffeeInlineBackground/custom(_:)`` for any solid colour (e.g. inside a card). This is
/// separate from `BuyMeCoffeeTheme`, whose contract is unchanged. `ProductRowView` children pick up
/// the `BuyMeCoffeeTheme` from the environment exactly like the drawer does.
///
/// ## Scope
///
/// This component renders the loaded product list with an optional header; background theming and
/// full purchase/state wiring are provided by other components in this package. The inline view
/// renders rows for the `.loaded` state and nothing for other states.
public struct BuyMeCoffeeInlineView: View {

    // MARK: - Environment

    @Environment(\.buyMeCoffeeTheme) private var theme

    // MARK: - State

    @StateObject private var viewModel: TipListViewModel

    // MARK: - Sort Order

    /// The order tip products are displayed in, by price. Defaults to `.ascending`.
    let sortOrder: TipSortOrder

    // MARK: - Background Configuration

    /// The background fill painted behind the inline content. Defaults to `.transparent` so the
    /// host app's own background shows through — unlike the drawer, which always fills
    /// `theme.backgroundColor`.
    let background: BuyMeCoffeeInlineBackground

    // MARK: - Header Configuration

    /// Whether the `DrawerHeaderView` is rendered above the product rows. Defaults to `true`.
    let showHeader: Bool

    /// Header label customisation used when `showHeader` is `true`. Defaults to `.init()`.
    let headerLabels: DrawerHeaderLabels

    // MARK: - Initializers

    /// Creates a `BuyMeCoffeeInlineView` with the specified product provider and product IDs.
    ///
    /// - Parameters:
    ///   - provider: The product provider. Use `StoreKitProductProvider.live()` for production,
    ///     or `MockProductProvider` in previews and tests.
    ///   - productIDs: The exact product IDs to fetch (e.g., ["com.example.tip.small", "com.example.tip.large"]).
    ///   - sortOrder: The order products are displayed in, by price. Defaults to `.ascending`.
    ///   - background: The background fill painted behind the inline content. Defaults to
    ///     `.transparent` so the host app's own background shows through. Pass `.themed` for
    ///     drawer-parity (`theme.backgroundColor`) or `.custom(_:)` for any solid colour.
    ///   - showHeader: Whether to render the `DrawerHeaderView` above the product rows. Defaults
    ///     to `true` for parity with the drawer's always-visible header. Pass `false` to render a
    ///     bare list of tip rows when the host screen already provides its own title/context.
    ///   - headerLabels: Header label customisation applied when `showHeader` is `true`. Defaults
    ///     to `.init()` (SPM defaults).
    public init(
        provider: ProductProvider,
        productIDs: [String],
        sortOrder: TipSortOrder = .ascending,
        background: BuyMeCoffeeInlineBackground = .transparent,
        showHeader: Bool = true,
        headerLabels: DrawerHeaderLabels = .init()
    ) {
        self.init(
            viewModel: TipListViewModel(provider: provider, productIDs: productIDs, sortOrder: sortOrder),
            sortOrder: sortOrder,
            background: background,
            showHeader: showHeader,
            headerLabels: headerLabels
        )
    }

    /// Creates a `BuyMeCoffeeInlineView` with a pre-configured `TipListViewModel`.
    ///
    /// Module-internal so tests (via `@testable import BuyMeCoffee`) can inject a view model in a
    /// specific state. The type is intentionally not exposed to host apps.
    init(
        viewModel: TipListViewModel,
        sortOrder: TipSortOrder = .ascending,
        background: BuyMeCoffeeInlineBackground = .transparent,
        showHeader: Bool = true,
        headerLabels: DrawerHeaderLabels = .init()
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.sortOrder = sortOrder
        self.background = background
        self.showHeader = showHeader
        self.headerLabels = headerLabels
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
        .background(background.resolvedColor(theme: theme))
        .task {
            await viewModel.fetchProducts()
        }
    }

    // MARK: - Subviews

    /// The tip product row list, optionally preceded by the shared `DrawerHeaderView`.
    ///
    /// When `showHeader` is `true`, the same `DrawerHeaderView` the drawer uses is rendered above
    /// the rows with the supplied `headerLabels`. Its dismiss control is wired to a no-op closure
    /// (`onDismiss: {}`) — the inline view is embedded in a host layout with no sheet to dismiss,
    /// so it must never be connected to `\.dismiss`.
    ///
    /// When `showHeader` is `false`, only the bare `VStack(spacing: 12)` of `ProductRowView` rows
    /// renders — no header, no dismiss control, no icon container.
    private func loadedView(products: [TipProduct]) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                if showHeader {
                    DrawerHeaderView(labels: headerLabels, onDismiss: {})
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 24)
                }

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
