import XCTest
import SwiftUI
@testable import BuyMeCoffee

final class BuyMeCoffeeThemeTests: XCTestCase {

    // MARK: - Test AC 1: testDefaultTheme_hasExpectedBackgroundColor

    func testDefaultTheme_hasExpectedBackgroundColor() {
        // Given
        let expectedBackgroundColor = Color(red: 0x16 / 255.0, green: 0x18 / 255.0, blue: 0x2A / 255.0)

        // When
        let theme = BuyMeCoffeeTheme.default

        // Then
        // SwiftUI Color equality is tricky, so we'll verify through UIColor/NSColor conversion
        #if os(iOS)
        let themeUIColor = UIColor(theme.backgroundColor)
        let expectedUIColor = UIColor(expectedBackgroundColor)

        var themeRed: CGFloat = 0, themeGreen: CGFloat = 0, themeBlue: CGFloat = 0, themeAlpha: CGFloat = 0
        var expectedRed: CGFloat = 0, expectedGreen: CGFloat = 0, expectedBlue: CGFloat = 0, expectedAlpha: CGFloat = 0

        themeUIColor.getRed(&themeRed, green: &themeGreen, blue: &themeBlue, alpha: &themeAlpha)
        expectedUIColor.getRed(&expectedRed, green: &expectedGreen, blue: &expectedBlue, alpha: &expectedAlpha)

        XCTAssertEqual(themeRed, expectedRed, accuracy: 0.01)
        XCTAssertEqual(themeGreen, expectedGreen, accuracy: 0.01)
        XCTAssertEqual(themeBlue, expectedBlue, accuracy: 0.01)
        #elseif os(macOS)
        let themeNSColor = NSColor(theme.backgroundColor)
        let expectedNSColor = NSColor(expectedBackgroundColor)

        guard let themeRGB = themeNSColor.usingColorSpace(.sRGB),
              let expectedRGB = expectedNSColor.usingColorSpace(.sRGB) else {
            XCTFail("Failed to convert colors to sRGB color space")
            return
        }

        XCTAssertEqual(themeRGB.redComponent, expectedRGB.redComponent, accuracy: 0.01)
        XCTAssertEqual(themeRGB.greenComponent, expectedRGB.greenComponent, accuracy: 0.01)
        XCTAssertEqual(themeRGB.blueComponent, expectedRGB.blueComponent, accuracy: 0.01)
        #endif
    }

    // MARK: - Test AC 2: testCustomTheme_allTokensSet

    func testCustomTheme_allTokensSet() {
        // Given
        let customBackground = Color.red
        let customPrimaryText = Color.green
        let customSecondaryText = Color.blue
        let customAccentStart = Color.yellow
        let customAccentEnd = Color.orange
        let customProductRowBackground = Color.purple
        let customSeparator = Color.cyan
        let customSurfaceElevated = Color.pink
        let customTextOnAccent = Color.brown
        let customSuccess = Color.mint
        let customError = Color.indigo

        // When
        let theme = BuyMeCoffeeTheme(
            backgroundColor: customBackground,
            primaryTextColor: customPrimaryText,
            secondaryTextColor: customSecondaryText,
            accentStartColor: customAccentStart,
            accentEndColor: customAccentEnd,
            productRowBackgroundColor: customProductRowBackground,
            separatorColor: customSeparator,
            surfaceElevatedColor: customSurfaceElevated,
            textOnAccentColor: customTextOnAccent,
            successColor: customSuccess,
            errorColor: customError
        )

        // Then
        XCTAssertEqual(theme.backgroundColor, customBackground)
        XCTAssertEqual(theme.primaryTextColor, customPrimaryText)
        XCTAssertEqual(theme.secondaryTextColor, customSecondaryText)
        XCTAssertEqual(theme.accentStartColor, customAccentStart)
        XCTAssertEqual(theme.accentEndColor, customAccentEnd)
        XCTAssertEqual(theme.productRowBackgroundColor, customProductRowBackground)
        XCTAssertEqual(theme.separatorColor, customSeparator)
        XCTAssertEqual(theme.surfaceElevatedColor, customSurfaceElevated)
        XCTAssertEqual(theme.textOnAccentColor, customTextOnAccent)
        XCTAssertEqual(theme.successColor, customSuccess)
        XCTAssertEqual(theme.errorColor, customError)
    }
}
