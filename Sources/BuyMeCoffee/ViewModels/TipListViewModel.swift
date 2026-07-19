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

    init(provider: ProductProvider, productIDs: [String]) {
        self.provider = provider
        self.productIDs = productIDs
    }

    func fetchProducts() async {
        do {
            let products = try await provider.fetchProducts(productIDs: productIDs)
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
