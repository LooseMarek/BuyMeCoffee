import SwiftUI

/// Drives the product-fetch and purchase flow for a tip list.
///
/// This is the shared, presentation-agnostic engine behind the tip jar: it fetches products
/// via the injected `ProductProvider` and drives a `loading → loaded / empty / error / thankYou`
/// state machine. `BuyMeCoffeeView` uses it today; other presentation modes (e.g. an inline
/// view) can reuse it without duplicating StoreKit/purchase logic.
///
/// Deliberately module-internal: it is a shared building block for views within this package,
/// not part of the public API surface host apps consume.
@MainActor
final class TipListViewModel: ObservableObject {
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
    private let productIDs: [String]
    private let sortOrder: TipSortOrder

    init(provider: ProductProvider, productIDs: [String], sortOrder: TipSortOrder = .ascending) {
        self.provider = provider
        self.productIDs = productIDs
        self.sortOrder = sortOrder
    }

    func fetchProducts() async {
        do {
            let products = try await provider.fetchProducts(productIDs: productIDs)
            if products.isEmpty {
                state = .empty
            } else {
                state = .loaded(sorted(products))
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    /// Sorts products by price for the configured order. `sorted(by:)` is a guaranteed-stable
    /// sort, so equal-price products keep the provider's original order.
    private func sorted(_ products: [TipProduct]) -> [TipProduct] {
        products.sorted { lhs, rhs in
            switch sortOrder {
            case .ascending:
                return lhs.price < rhs.price
            case .descending:
                return lhs.price > rhs.price
            }
        }
    }

    /// Returns to the loaded product list after a thank-you (embedded contexts have no sheet to
    /// dismiss). Re-fetches products, matching the drawer's "reopen triggers a fresh fetch" model.
    func reset() async {
        await fetchProducts()
    }

    func purchase(_ product: TipProduct) async {
        do {
            try await provider.purchase(product)
            state = .thankYou
        } catch let error as PurchaseError {
            switch error {
            case .cancelled:
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
