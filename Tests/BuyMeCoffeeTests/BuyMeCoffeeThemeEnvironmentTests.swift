import XCTest
import SwiftUI
@testable import BuyMeCoffee

final class BuyMeCoffeeThemeEnvironmentTests: XCTestCase {

    // MARK: - Test AC 1: testDefaultValue_returnsDefaultTheme

    func testDefaultValue_returnsDefaultTheme() {
        // EnvironmentValues() has no injected theme, so the key's defaultValue must be returned.
        let values = EnvironmentValues()
        XCTAssertEqual(values.buyMeCoffeeTheme, BuyMeCoffeeTheme.default)
    }

    // MARK: - Test AC 2: testInjectedTheme_receivedByChildView

    func testInjectedTheme_receivedByChildView() {
        // Setting the key on an EnvironmentValues instance and reading it back exercises
        // the subscript path that SwiftUI uses when propagating values down the hierarchy.
        let customTheme = BuyMeCoffeeTheme(
            backgroundColor: .red,
            primaryTextColor: .blue,
            secondaryTextColor: .green,
            accentStartColor: .yellow,
            accentEndColor: .orange,
            productRowBackgroundColor: .purple,
            separatorColor: .cyan,
            surfaceElevatedColor: .pink,
            textOnAccentColor: .brown,
            successColor: .mint,
            errorColor: .indigo
        )

        var values = EnvironmentValues()
        values.buyMeCoffeeTheme = customTheme

        XCTAssertEqual(values.buyMeCoffeeTheme, customTheme)
    }

    // MARK: - Test AC 3: testSiblingSubtrees_maintainIndependentThemes

    func testSiblingSubtrees_maintainIndependentThemes() {
        // Two separate EnvironmentValues instances represent two sibling subtrees.
        // Injecting different themes into each must not bleed between them.
        let themeA = BuyMeCoffeeTheme(
            backgroundColor: .red,
            primaryTextColor: .white,
            secondaryTextColor: .gray,
            accentStartColor: .yellow,
            accentEndColor: .orange,
            productRowBackgroundColor: .black,
            separatorColor: .gray,
            surfaceElevatedColor: .black,
            textOnAccentColor: .white,
            successColor: .green,
            errorColor: .red
        )
        let themeB = BuyMeCoffeeTheme(
            backgroundColor: .blue,
            primaryTextColor: .black,
            secondaryTextColor: .gray,
            accentStartColor: .cyan,
            accentEndColor: .mint,
            productRowBackgroundColor: .white,
            separatorColor: .gray,
            surfaceElevatedColor: .white,
            textOnAccentColor: .black,
            successColor: .green,
            errorColor: .pink
        )

        var envA = EnvironmentValues()
        envA.buyMeCoffeeTheme = themeA

        var envB = EnvironmentValues()
        envB.buyMeCoffeeTheme = themeB

        XCTAssertEqual(envA.buyMeCoffeeTheme, themeA)
        XCTAssertEqual(envB.buyMeCoffeeTheme, themeB)
        XCTAssertNotEqual(envA.buyMeCoffeeTheme, envB.buyMeCoffeeTheme)
    }
}
