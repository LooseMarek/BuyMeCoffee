import SwiftUI

/// Visual theme defining all colour tokens used across the Buy Me Coffee drawer.
///
/// A `BuyMeCoffeeTheme` defines the complete colour palette for the tip jar drawer.
/// Use the built-in `.default` theme for a premium dark-mode aesthetic, or construct
/// a custom theme with your own colours to match your app's brand.
///
/// All colours are fixed (not adaptive to system appearance) to ensure consistent
/// presentation across light and dark system modes.
///
/// - Note: The theme applies to the entire drawer and all child views via the SwiftUI
///   environment. No prop-drilling required.
public struct BuyMeCoffeeTheme: Sendable, Equatable {

    // MARK: - Background & Surface

    /// Sheet / drawer background colour.
    ///
    /// Default: `#16182A` (dark blue-charcoal)
    public let backgroundColor: Color

    /// Product row card background colour.
    ///
    /// Default: `#1F2235` (elevated dark surface)
    public let productRowBackgroundColor: Color

    /// Elevated surfaces (e.g. pressed state, modal within modal).
    ///
    /// Default: `#272A40` (lighter elevated surface)
    public let surfaceElevatedColor: Color

    /// Hairline dividers between rows.
    ///
    /// Default: `#2E3150` (subtle separator)
    public let separatorColor: Color

    // MARK: - Text

    /// Primary text colour for headings, product names, and price labels.
    ///
    /// Default: `#FFFFFF` (white)
    public let primaryTextColor: Color

    /// Secondary text colour for subtitles, descriptions, and captions.
    ///
    /// Default: `#8B8FA8` (blue-grey muted)
    public let secondaryTextColor: Color

    /// Text colour rendered on top of the accent gradient.
    ///
    /// Default: `#FFFFFF` (white)
    public let textOnAccentColor: Color

    // MARK: - Accent (Gradient)

    /// Gradient start colour (warm amber).
    ///
    /// Default: `#F5A623`
    public let accentStartColor: Color

    /// Gradient end colour (warm orange).
    ///
    /// Default: `#F07242`
    public let accentEndColor: Color

    // MARK: - Semantic

    /// Success colour for confirmation states (e.g. thank-you screen).
    ///
    /// Default: `#52D38C` (green)
    public let successColor: Color

    /// Error colour for inline purchase error messages.
    ///
    /// Default: `#E05252` (red)
    public let errorColor: Color

    // MARK: - Initializer

    /// Creates a custom theme with the specified colours.
    ///
    /// All parameters are required. To start from the default theme with minor tweaks,
    /// copy `.default` and modify individual properties.
    public init(
        backgroundColor: Color,
        primaryTextColor: Color,
        secondaryTextColor: Color,
        accentStartColor: Color,
        accentEndColor: Color,
        productRowBackgroundColor: Color,
        separatorColor: Color,
        surfaceElevatedColor: Color,
        textOnAccentColor: Color,
        successColor: Color,
        errorColor: Color
    ) {
        self.backgroundColor = backgroundColor
        self.primaryTextColor = primaryTextColor
        self.secondaryTextColor = secondaryTextColor
        self.accentStartColor = accentStartColor
        self.accentEndColor = accentEndColor
        self.productRowBackgroundColor = productRowBackgroundColor
        self.separatorColor = separatorColor
        self.surfaceElevatedColor = surfaceElevatedColor
        self.textOnAccentColor = textOnAccentColor
        self.successColor = successColor
        self.errorColor = errorColor
    }

    // MARK: - Default Theme

    /// The built-in default theme with a premium dark-mode aesthetic.
    ///
    /// All colours are fixed (not adaptive) to ensure consistent presentation regardless
    /// of system appearance. This theme uses a dark blue-charcoal background with warm
    /// amber-to-orange accent gradient, matching the "coffee warmth" brand feel.
    public static let `default` = BuyMeCoffeeTheme(
        backgroundColor: Color(red: 0x16 / 255.0, green: 0x18 / 255.0, blue: 0x2A / 255.0),
        primaryTextColor: Color(red: 1.0, green: 1.0, blue: 1.0),
        secondaryTextColor: Color(red: 0x8B / 255.0, green: 0x8F / 255.0, blue: 0xA8 / 255.0),
        accentStartColor: Color(red: 0xF5 / 255.0, green: 0xA6 / 255.0, blue: 0x23 / 255.0),
        accentEndColor: Color(red: 0xF0 / 255.0, green: 0x72 / 255.0, blue: 0x42 / 255.0),
        productRowBackgroundColor: Color(red: 0x1F / 255.0, green: 0x22 / 255.0, blue: 0x35 / 255.0),
        separatorColor: Color(red: 0x2E / 255.0, green: 0x31 / 255.0, blue: 0x50 / 255.0),
        surfaceElevatedColor: Color(red: 0x27 / 255.0, green: 0x2A / 255.0, blue: 0x40 / 255.0),
        textOnAccentColor: Color(red: 1.0, green: 1.0, blue: 1.0),
        successColor: Color(red: 0x52 / 255.0, green: 0xD3 / 255.0, blue: 0x8C / 255.0),
        errorColor: Color(red: 0xE0 / 255.0, green: 0x52 / 255.0, blue: 0x52 / 255.0)
    )
}
