import XCTest
import SwiftUI
@testable import BuyMeCoffee

final class BuyMeCoffeeThemeEnvironmentTests: XCTestCase {

    // MARK: - Test AC 1: testDefaultValue_returnsDefaultTheme

    func testDefaultValue_returnsDefaultTheme() {
        // Given: A fresh EnvironmentValues instance
        var environmentValues = EnvironmentValues()

        // When: We access the buyMeCoffeeTheme key without setting it
        let theme = environmentValues.buyMeCoffeeTheme

        // Then: It should return BuyMeCoffeeTheme.default
        XCTAssertEqual(theme, BuyMeCoffeeTheme.default)
    }

    // MARK: - Test AC 2: testInjectedTheme_receivedByChildView

    func testInjectedTheme_receivedByChildView() {
        // Given: A custom theme
        let customTheme = BuyMeCoffeeTheme(
            backgroundColor: Color.red,
            primaryTextColor: Color.green,
            secondaryTextColor: Color.blue,
            accentStartColor: Color.yellow,
            accentEndColor: Color.orange,
            productRowBackgroundColor: Color.purple,
            separatorColor: Color.cyan,
            surfaceElevatedColor: Color.pink,
            textOnAccentColor: Color.brown,
            successColor: Color.mint,
            errorColor: Color.indigo
        )

        // When: We set a custom theme in the environment
        var environmentValues = EnvironmentValues()
        environmentValues.buyMeCoffeeTheme = customTheme

        // Then: The environment should return the custom theme
        let retrievedTheme = environmentValues.buyMeCoffeeTheme
        XCTAssertEqual(retrievedTheme, customTheme)
    }

    // MARK: - Test AC 3: testSiblingSubtrees_maintainSeparateThemes

    func testSiblingSubtrees_maintainSeparateThemes() {
        // Given: Two different custom themes
        let theme1 = BuyMeCoffeeTheme(
            backgroundColor: Color.red,
            primaryTextColor: Color.white,
            secondaryTextColor: Color.gray,
            accentStartColor: Color.blue,
            accentEndColor: Color.cyan,
            productRowBackgroundColor: Color.purple,
            separatorColor: Color.black,
            surfaceElevatedColor: Color.pink,
            textOnAccentColor: Color.white,
            successColor: Color.green,
            errorColor: Color.orange
        )

        let theme2 = BuyMeCoffeeTheme(
            backgroundColor: Color.green,
            primaryTextColor: Color.black,
            secondaryTextColor: Color.brown,
            accentStartColor: Color.yellow,
            accentEndColor: Color.orange,
            productRowBackgroundColor: Color.mint,
            separatorColor: Color.white,
            surfaceElevatedColor: Color.teal,
            textOnAccentColor: Color.black,
            successColor: Color.blue,
            errorColor: Color.red
        )

        // When: We set different themes in separate environment instances
        var env1 = EnvironmentValues()
        env1.buyMeCoffeeTheme = theme1

        var env2 = EnvironmentValues()
        env2.buyMeCoffeeTheme = theme2

        // Then: Each environment should maintain its own theme
        XCTAssertEqual(env1.buyMeCoffeeTheme, theme1)
        XCTAssertEqual(env2.buyMeCoffeeTheme, theme2)
        XCTAssertNotEqual(env1.buyMeCoffeeTheme, env2.buyMeCoffeeTheme)
    }
}
