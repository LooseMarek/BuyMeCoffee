import XCTest
import SwiftUI
@testable import BuyMeCoffee

final class BuyMeCoffeeEnvironmentKeyTests: XCTestCase {

    // MARK: - Test AC 1: testDefaultValue_isFalse

    func testDefaultValue_isFalse() {
        // EnvironmentValues() has no injected presentation binding, so the key's defaultValue
        // must return a binding wrapping `false`.
        let values = EnvironmentValues()
        XCTAssertFalse(values.buyMeCoffeeIsPresented.wrappedValue)
    }

    // MARK: - Test AC 2: testInjectedValue_receivedByDescendant

    func testInjectedValue_receivedByDescendant() {
        // Setting the key on an EnvironmentValues instance and reading it back exercises
        // the subscript path that SwiftUI uses when propagating values down the hierarchy.
        let binding = Binding.constant(true)

        var values = EnvironmentValues()
        values.buyMeCoffeeIsPresented = binding

        XCTAssertTrue(values.buyMeCoffeeIsPresented.wrappedValue)
    }
}
