import StoreKit

enum StoreKitProductProviderError: Error {
    case productNotFound
    case unverifiedTransaction
    case unknownPurchaseResult
}

/// A concrete `ProductProvider` that uses StoreKit 2 to fetch and purchase products.
///
/// Use `StoreKitProductProvider.live(knownProductIDs:)` for production.
/// Inject `fetcher` and `purchaser` in tests to avoid live StoreKit calls.
public final class StoreKitProductProvider: ProductProvider, @unchecked Sendable {

    public typealias ProductTuple = (id: String, displayName: String, description: String, displayPrice: String)
    public typealias Fetcher = @Sendable ([String]) async throws -> [ProductTuple]
    public typealias Purchaser = @Sendable (TipProduct) async throws -> Void

    private let knownProductIDs: [String]
    private let fetcher: Fetcher
    private let purchaser: Purchaser

    /// Creates a provider with injectable dependencies — intended for testing.
    public init(
        knownProductIDs: [String],
        fetcher: @escaping Fetcher,
        purchaser: @escaping Purchaser = { _ in }
    ) {
        self.knownProductIDs = knownProductIDs
        self.fetcher = fetcher
        self.purchaser = purchaser
    }

    /// Creates a production provider backed by the live StoreKit 2 APIs.
    public static func live(knownProductIDs: [String]) -> StoreKitProductProvider {
        StoreKitProductProvider(
            knownProductIDs: knownProductIDs,
            fetcher: { ids in
                try await Product.products(for: ids).map {
                    (id: $0.id, displayName: $0.displayName, description: $0.description, displayPrice: $0.displayPrice)
                }
            },
            purchaser: { product in
                let products = try await Product.products(for: [product.id])
                guard let storeProduct = products.first else {
                    throw PurchaseError.failed(StoreKitProductProviderError.productNotFound)
                }
                let result = try await storeProduct.purchase()
                switch result {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        await transaction.finish()
                    case .unverified:
                        throw PurchaseError.failed(StoreKitProductProviderError.unverifiedTransaction)
                    }
                case .userCancelled:
                    throw PurchaseError.cancelled
                case .pending:
                    throw PurchaseError.pending
                @unknown default:
                    throw PurchaseError.failed(StoreKitProductProviderError.unknownPurchaseResult)
                }
            }
        )
    }

    public func fetchProducts(prefix: String) async throws -> [TipProduct] {
        let tuples = try await fetcher(knownProductIDs)
        return tuples
            .filter { $0.id.hasPrefix(prefix) }
            .map { TipProduct(id: $0.id, displayName: $0.displayName, description: $0.description, displayPrice: $0.displayPrice) }
    }

    public func purchase(_ product: TipProduct) async throws {
        try await purchaser(product)
    }
}
