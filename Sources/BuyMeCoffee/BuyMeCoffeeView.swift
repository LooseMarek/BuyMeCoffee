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
///         BuyMeCoffeeView(productPrefix: "com.example.tip")
///             .environment(\.buyMeCoffeeTheme, .default)
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
/// For Xcode Previews and unit tests, inject a `MockProductProvider`:
///
/// ```swift
/// BuyMeCoffeeView(
///     provider: MockProductProvider(products: [...]),
///     productPrefix: "com.example.tip"
/// )
/// ```
public struct BuyMeCoffeeView: View {

    // MARK: - Environment

    @Environment(\.buyMeCoffeeTheme) private var theme
    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    @StateObject private var viewModel: ViewModel

    // MARK: - Initializers

    /// Creates a BuyMeCoffeeView with the specified product provider and prefix.
    ///
    /// - Parameters:
    ///   - provider: The product provider. Use `StoreKitProductProvider.live(knownProductIDs:)` for production,
    ///     or `MockProductProvider` for Previews/tests.
    ///   - productPrefix: The product ID prefix to filter by (e.g., "com.example.tip").
    public init(
        provider: ProductProvider,
        productPrefix: String
    ) {
        _viewModel = StateObject(wrappedValue: ViewModel(provider: provider, productPrefix: productPrefix))
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
                    EmptyStateView()
                case .error(let message):
                    ErrorStateView(
                        headline: "Couldn't load tips",
                        bodyText: message
                    )
                case .thankYou:
                    ThankYouView(onDismiss: {
                        dismiss()
                    })
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Product list with staggered row animations.
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
            .padding(16)
        }
    }
}

// MARK: - View Model

extension BuyMeCoffeeView {
    @MainActor
    final class ViewModel: ObservableObject {
        enum State: Equatable {
            case loading
            case loaded([TipProduct])
            case empty
            case error(String)
            case thankYou

            static func == (lhs: State, rhs: State) -> Bool {
                switch (lhs, rhs) {
                case (.loading, .loading), (.empty, .empty), (.thankYou, .thankYou):
                    return true
                case (.loaded(let l), .loaded(let r)):
                    return l == r
                case (.error(let l), .error(let r)):
                    return l == r
                default:
                    return false
                }
            }
        }

        @Published var state: State = .loading

        private let provider: ProductProvider
        private let productPrefix: String

        init(provider: ProductProvider, productPrefix: String) {
            self.provider = provider
            self.productPrefix = productPrefix
        }

        func fetchProducts() async {
            do {
                let products = try await provider.fetchProducts(prefix: productPrefix)
                if products.isEmpty {
                    state = .empty
                } else {
                    state = .loaded(products)
                }
            } catch {
                state = .error(error.localizedDescription)
            }
        }

        func purchase(_ product: TipProduct) async {
            do {
                try await provider.purchase(product)
                state = .thankYou
            } catch let error as PurchaseError {
                // Handle purchase-specific errors
                switch error {
                case .cancelled:
                    // User cancelled - no action needed, stay in loaded state
                    break
                case .failed(let underlyingError):
                    state = .error("Purchase failed: \(underlyingError.localizedDescription)")
                case .pending:
                    state = .error("Purchase is pending approval.")
                }
            } catch {
                state = .error("Purchase failed: \(error.localizedDescription)")
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

    return BuyMeCoffeeView(provider: mockProvider, productPrefix: "mock.coffee")
        .environment(\.buyMeCoffeeTheme, .default)
}

#Preview("Empty State") {
    let mockProvider = MockProductProvider(products: [], purchaseOutcome: .success)

    return BuyMeCoffeeView(provider: mockProvider, productPrefix: "mock.coffee")
        .environment(\.buyMeCoffeeTheme, .default)
}

#Preview("Error State") {
    struct ErrorProvider: ProductProvider {
        func fetchProducts(prefix: String) async throws -> [TipProduct] {
            throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network connection failed"])
        }

        func purchase(_ product: TipProduct) async throws {
            throw PurchaseError.failed(NSError(domain: "TestError", code: 1))
        }
    }

    return BuyMeCoffeeView(provider: ErrorProvider(), productPrefix: "mock.coffee")
        .environment(\.buyMeCoffeeTheme, .default)
}
