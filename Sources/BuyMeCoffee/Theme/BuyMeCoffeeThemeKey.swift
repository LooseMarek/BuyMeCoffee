import SwiftUI

/// Environment key for accessing the `BuyMeCoffeeTheme` throughout the view hierarchy.
///
/// This key allows the theme to flow down the SwiftUI environment automatically,
/// eliminating the need for prop-drilling. Any internal view can read the theme
/// using `@Environment(\.buyMeCoffeeTheme)`.
///
/// The default value is `BuyMeCoffeeTheme.default` when no theme has been explicitly set.
struct BuyMeCoffeeThemeKey: EnvironmentKey {
    static let defaultValue: BuyMeCoffeeTheme = .default
}

extension EnvironmentValues {
    /// The current `BuyMeCoffeeTheme` for the Buy Me Coffee drawer.
    ///
    /// Use this environment value to access the theme's colour tokens throughout
    /// the drawer's view hierarchy. The theme can be set at any level using
    /// `.environment(\.buyMeCoffeeTheme, customTheme)`.
    ///
    /// Example:
    /// ```swift
    /// struct MyView: View {
    ///     @Environment(\.buyMeCoffeeTheme) private var theme
    ///
    ///     var body: some View {
    ///         Text("Hello")
    ///             .foregroundStyle(theme.primaryTextColor)
    ///     }
    /// }
    /// ```
    public var buyMeCoffeeTheme: BuyMeCoffeeTheme {
        get { self[BuyMeCoffeeThemeKey.self] }
        set { self[BuyMeCoffeeThemeKey.self] = newValue }
    }
}
