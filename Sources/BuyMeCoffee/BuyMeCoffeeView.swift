import SwiftUI

/// The root container view for the Buy Me a Coffee tip jar drawer.
///
/// `BuyMeCoffeeView` orchestrates the entire tip flow: fetches products via the injected
/// `ProductProvider`, displays a loading spinner → product list / empty state / error state,
/// handles purchase attempts, and transitions to a thank-you screen on success.
///
/// ## Platform Presentation
///
/// - **iOS:** Designed for presentation as a `.sheet` with `.presentationDetents([.medium, .large])`.
/// - **macOS:** Designed for presentation as a standard `.sheet` with a fixed 360pt width.
///
/// ## Usage
///
/// ```swift
/// @State private var isPresented = false
///
/// var body: some View {
///     Button("Support") {
///         isPresented = true
///     }
///     .sheet(isPresented: $isPresented) {
///         BuyMeCoffeeView(
///             provider: StoreKitProductProvider.live(),
///             productIDs: ["com.example.tip.small", "com.example.tip.large"]
///         )
///         .environment(\.buyMeCoffeeTheme, .default)
///     }
/// }
/// ```
///
/// ## Theming
///
/// Pass a `BuyMeCoffeeTheme` via `.environment(\.buyMeCoffeeTheme, theme)` to customize colors.
/// Defaults to `.default` if not specified.
///
/// ## Testing
///
/// For unit tests, use `@testable import BuyMeCoffee` to access the internal `MockProductProvider`.
public struct BuyMeCoffeeView: View {

    // MARK: - Environment

    @Environment(\.buyMeCoffeeTheme) private var theme
    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    @StateObject private var viewModel: TipListViewModel

    // MARK: - Customizable Labels

    /// Header label customisation. Defaults to `.init()`.
    let headerLabels: DrawerHeaderLabels

    /// Empty state label customisation. Defaults to `.init()`.
    let emptyStateLabels: EmptyStateLabels

    /// Error state label customisation. Defaults to `.init()`.
    let errorStateLabels: ErrorStateLabels

    /// Thank-you screen label customisation. Defaults to `.init()`.
    let thankYouLabels: ThankYouLabels

    // MARK: - Initializers

    /// Creates a BuyMeCoffeeView with the specified product provider and product IDs.
    ///
    /// - Parameters:
    ///   - provider: The product provider. Use `StoreKitProductProvider.live()` for production.
    ///   - productIDs: The exact product IDs to fetch (e.g., ["com.example.tip.small", "com.example.tip.large"]).
    ///   - headerLabels: Header label customisation. Defaults to `.init()` (SPM defaults).
    ///   - emptyStateLabels: Empty state label customisation. Defaults to `.init()` (SPM defaults).
    ///   - errorStateLabels: Error state label customisation. Defaults to `.init()` (SPM defaults).
    ///   - thankYouLabels: Thank-you screen label customisation. Defaults to `.init()` (SPM defaults).
    public init(
        provider: ProductProvider,
        productIDs: [String],
        headerLabels: DrawerHeaderLabels = .init(),
        emptyStateLabels: EmptyStateLabels = .init(),
        errorStateLabels: ErrorStateLabels = .init(),
        thankYouLabels: ThankYouLabels = .init()
    ) {
        self.init(
            viewModel: TipListViewModel(provider: provider, productIDs: productIDs),
            headerLabels: headerLabels,
            emptyStateLabels: emptyStateLabels,
            errorStateLabels: errorStateLabels,
            thankYouLabels: thankYouLabels
        )
    }

    /// Creates a BuyMeCoffeeView with a pre-configured `TipListViewModel`.
    ///
    /// Module-internal so tests (via `@testable import BuyMeCoffee`) can inject a view model in a
    /// specific state. The type is intentionally not exposed to host apps.
    init(
        viewModel: TipListViewModel,
        headerLabels: DrawerHeaderLabels = .init(),
        emptyStateLabels: EmptyStateLabels = .init(),
        errorStateLabels: ErrorStateLabels = .init(),
        thankYouLabels: ThankYouLabels = .init()
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.headerLabels = headerLabels
        self.emptyStateLabels = emptyStateLabels
        self.errorStateLabels = errorStateLabels
        self.thankYouLabels = thankYouLabels
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea()

            Group {
                switch viewModel.state {
                case .loading:
                    loadingView
                case .loaded(let products):
                    loadedView(products: products)
                case .empty:
                    EmptyStateView(labels: emptyStateLabels, onDismiss: { dismiss() })
                case .error(let message):
                    ErrorStateView(labels: errorStateLabels, errorMessage: message, onDismiss: { dismiss() })
                case .thankYou:
                    ThankYouView(labels: thankYouLabels, onDismiss: { dismiss() })
                }
            }
        }
        .task {
            await viewModel.fetchProducts()
        }
    }

    // MARK: - Subviews

    /// Loading spinner shown during product fetch.
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: theme.secondaryTextColor))
                .scaleEffect(1.2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }

    /// Product list with header and staggered row animations.
    private func loadedView(products: [TipProduct]) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                DrawerHeaderView(labels: headerLabels, onDismiss: { dismiss() })
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 24)

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
                .padding(.bottom, 16)
            }
        }
    }
}

// MARK: - Previews

#Preview("Loaded State") {
    let mockProvider = MockProductProvider(
        products: [
            TipProduct(id: "mock.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99"),
            TipProduct(id: "mock.coffee.large", displayName: "Large Coffee", description: "A large cup", displayPrice: "$2.99"),
        ],
        purchaseOutcome: .success
    )

    return BuyMeCoffeeView(
        provider: mockProvider,
        productIDs: ["mock.coffee.small", "mock.coffee.large"]
    )
    .environment(\.buyMeCoffeeTheme, .default)
}

#Preview("Empty State") {
    let mockProvider = MockProductProvider(products: [], purchaseOutcome: .success)

    return BuyMeCoffeeView(
        provider: mockProvider,
        productIDs: []
    )
    .environment(\.buyMeCoffeeTheme, .default)
}

#Preview("Error State") {
    struct ErrorProvider: ProductProvider {
        func fetchProducts(productIDs: [String]) async throws -> [TipProduct] {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network connection failed"])
        }

        func purchase(_ product: TipProduct) async throws {
            throw PurchaseError.failed(NSError(domain: "TestError", code: 1))
        }
    }

    return BuyMeCoffeeView(
        provider: ErrorProvider(),
        productIDs: ["mock.coffee.small"]
    )
    .environment(\.buyMeCoffeeTheme, .default)
}
