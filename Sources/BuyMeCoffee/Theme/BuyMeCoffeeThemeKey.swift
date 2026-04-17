import SwiftUI

/// Environment key for accessing the `BuyMeCoffeeTheme` in the view hierarchy.
///
/// This key allows the theme to flow down the SwiftUI environment automatically,
/// enabling any child view to read it via `@Environment(\.buyMeCoffeeTheme)` without
/// prop-drilling.
///
/// - Note: This key is internal. Only `BuyMeCoffeeTheme` itself is public.
struct BuyMeCoffeeThemeKey: EnvironmentKey {
    static let defaultValue: BuyMeCoffeeTheme = .default
}

extension EnvironmentValues {
    /// The theme for the Buy Me a Coffee drawer.
    ///
    /// Read this value from any view in the hierarchy using:
    /// ```swift
    /// @Environment(\.buyMeCoffeeTheme) var theme
    /// ```
    ///
    /// Set a custom theme on a parent view using:
    /// ```swift
    /// SomeView()
    ///     .environment(\.buyMeCoffeeTheme, customTheme)
    /// ```
    ///
    /// If no custom theme is set, the default theme is used automatically.
    public var buyMeCoffeeTheme: BuyMeCoffeeTheme {
        get { self[BuyMeCoffeeThemeKey.self] }
        set { self[BuyMeCoffeeThemeKey.self] = newValue }
    }
}
