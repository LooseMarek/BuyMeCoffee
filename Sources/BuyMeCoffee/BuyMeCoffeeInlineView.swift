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
/// This component renders the full `TipListViewModel` state machine — loading, loaded, empty,
/// error, and thank-you — with the same subviews as the drawer, but wired for an embedded
/// (non-modal) context. Because there is no sheet to close, the empty/error dismiss affordances
/// are no-ops, and the thank-you state returns to the product list via the macOS tap-to-dismiss
/// (which calls the view model's `reset()` to re-fetch) and/or the optional `onThankYouDismiss`
/// host closure. On iOS, where `ThankYouView` has no tap affordance, the host relies on
/// `onThankYouDismiss` / view reconstruction to leave the thank-you state.
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

    /// Empty state label customisation. Defaults to `.init()`.
    let emptyStateLabels: EmptyStateLabels

    /// Error state label customisation. Defaults to `.init()`.
    let errorStateLabels: ErrorStateLabels

    /// Thank-you screen label customisation. Defaults to `.init()`.
    let thankYouLabels: ThankYouLabels

    // MARK: - Host Callbacks

    /// Optional host-facing closure invoked when the thank-you state is cleared. Because the inline
    /// view has no sheet to dismiss, this is the documented mechanism for a host to know the
    /// thank-you state was dismissed / should reset (e.g. to scroll away or re-construct the view).
    /// Defaults to `nil`.
    let onThankYouDismiss: (() -> Void)?

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
    ///   - emptyStateLabels: Empty state label customisation. Defaults to `.init()` (SPM defaults).
    ///   - errorStateLabels: Error state label customisation. Defaults to `.init()` (SPM defaults).
    ///   - thankYouLabels: Thank-you screen label customisation. Defaults to `.init()` (SPM defaults).
    ///   - onThankYouDismiss: Optional closure invoked when the thank-you state is cleared. Since
    ///     the inline view has no sheet to dismiss, this lets the host respond (e.g. reset or
    ///     re-construct the view). Defaults to `nil`.
    public init(
        provider: ProductProvider,
        productIDs: [String],
        sortOrder: TipSortOrder = .ascending,
        background: BuyMeCoffeeInlineBackground = .transparent,
        showHeader: Bool = true,
        headerLabels: DrawerHeaderLabels = .init(),
        emptyStateLabels: EmptyStateLabels = .init(),
        errorStateLabels: ErrorStateLabels = .init(),
        thankYouLabels: ThankYouLabels = .init(),
        onThankYouDismiss: (() -> Void)? = nil
    ) {
        self.init(
            viewModel: TipListViewModel(provider: provider, productIDs: productIDs, sortOrder: sortOrder),
            sortOrder: sortOrder,
            background: background,
            showHeader: showHeader,
            headerLabels: headerLabels,
            emptyStateLabels: emptyStateLabels,
            errorStateLabels: errorStateLabels,
            thankYouLabels: thankYouLabels,
            onThankYouDismiss: onThankYouDismiss
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
        headerLabels: DrawerHeaderLabels = .init(),
        emptyStateLabels: EmptyStateLabels = .init(),
        errorStateLabels: ErrorStateLabels = .init(),
        thankYouLabels: ThankYouLabels = .init(),
        onThankYouDismiss: (() -> Void)? = nil
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.sortOrder = sortOrder
        self.background = background
        self.showHeader = showHeader
        self.headerLabels = headerLabels
        self.emptyStateLabels = emptyStateLabels
        self.errorStateLabels = errorStateLabels
        self.thankYouLabels = thankYouLabels
        self.onThankYouDismiss = onThankYouDismiss
    }

    // MARK: - Body

    public var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                loadingView
            case .loaded(let products):
                loadedView(products: products)
            case .empty:
                EmptyStateView(labels: emptyStateLabels, onDismiss: {})
            case .error(let message):
                ErrorStateView(labels: errorStateLabels, errorMessage: message, onDismiss: {})
            case .thankYou:
                ThankYouView(labels: thankYouLabels, onDismiss: {
                    Task { await viewModel.reset() }
                    onThankYouDismiss?()
                })
            }
        }
        .background(background.resolvedColor(theme: theme))
        .task {
            await viewModel.fetchProducts()
        }
    }

    // MARK: - Padding

    /// Whether a visible background fill is painted behind the content. When `false`
    /// (`.transparent`), there is no card edge to separate content from, so the inline view sits
    /// flush against the host layout with no surrounding padding.
    var hasVisibleBackground: Bool {
        background != .transparent
    }

    /// Padding applied around the header. Preserves the card-appropriate insets when a background
    /// fill is visible; collapses to zero when the background is `.transparent`.
    var headerPadding: EdgeInsets {
        hasVisibleBackground ? EdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16) : EdgeInsets()
    }

    /// Padding applied around the tip row list. Preserves the card-appropriate insets when a
    /// background fill is visible; collapses to zero when the background is `.transparent`.
    var rowListPadding: EdgeInsets {
        hasVisibleBackground ? EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16) : EdgeInsets()
    }

    // MARK: - Subviews

    /// Loading spinner shown during product fetch. Copied from the drawer's `loadingView` for
    /// parity — a centered `ProgressView` tinted with the theme's secondary text colour.
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: theme.secondaryTextColor))
                .scaleEffect(1.2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }

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
                        .padding(headerPadding)
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
                .padding(rowListPadding)
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
