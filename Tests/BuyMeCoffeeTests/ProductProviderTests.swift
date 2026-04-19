import XCTest
@testable import BuyMeCoffee

final class ProductProviderTests: XCTestCase {

    // MARK: - Test Protocol Conformance

    /// Verifies a simple mock struct can conform to ProductProvider without importing StoreKit
    func testProtocolConformance_mockCompiles() {
        // Given a simple mock that conforms to ProductProvider
        struct SimpleMock: ProductProvider {
            func fetchProducts(productIDs: [String]) async throws -> [TipProduct] {
                []
            }

            func purchase(_ product: TipProduct) async throws {
                // Success case
            }
        }

        // When we instantiate it
        let mock = SimpleMock()

        // Then it compiles and conforms without StoreKit imports
        XCTAssertNotNil(mock)
    }

    // MARK: - Test Purchase Error Cases

    /// Verifies all PurchaseError cases are representable (cancelled, failed, pending)
    func testPurchaseResult_coversSuccessCancelledFailed() {
        // Given the PurchaseError enum exists
        // When we construct each error case
        let cancelledError = PurchaseError.cancelled
        let failedError = PurchaseError.failed(NSError(domain: "test", code: 1))
        let pendingError = PurchaseError.pending

        // Then all cases are representable
        XCTAssertNotNil(cancelledError)
        XCTAssertNotNil(failedError)
        XCTAssertNotNil(pendingError)

        // And they are distinct cases
        switch cancelledError {
        case .cancelled:
            break // Expected
        default:
            XCTFail("Expected .cancelled case")
        }

        switch failedError {
        case .failed:
            break // Expected
        default:
            XCTFail("Expected .failed case")
        }

        switch pendingError {
        case .pending:
            break // Expected
        default:
            XCTFail("Expected .pending case")
        }
    }
}
