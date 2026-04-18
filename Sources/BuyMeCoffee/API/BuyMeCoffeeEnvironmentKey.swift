import SwiftUI

/// Environment key for accessing the drawer presentation state in the view hierarchy.
///
/// This key allows the presentation state to flow down the SwiftUI environment automatically,
/// enabling any child view to read or modify it via `@Environment(\.buyMeCoffeeIsPresented)`
/// without prop-drilling.
///
/// - Note: This key is internal. The public surface is the `.buyMeCoffee(...)` view modifier.
struct BuyMeCoffeeEnvironmentKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    /// The presentation state binding for the Buy Me a Coffee drawer.
    ///
    /// Read this value from any view in the hierarchy using:
    /// ```swift
    /// @Environment(\.buyMeCoffeeIsPresented) var isPresented
    /// ```
    ///
    /// Set or modify the presentation state:
    /// ```swift
    /// isPresented.wrappedValue = true  // Present the drawer
    /// isPresented.wrappedValue = false // Dismiss the drawer
    /// ```
    ///
    /// If no custom binding is set, the default binding (wrapping `false`) is used automatically.
    var buyMeCoffeeIsPresented: Binding<Bool> {
        get { self[BuyMeCoffeeEnvironmentKey.self] }
        set { self[BuyMeCoffeeEnvironmentKey.self] = newValue }
    }
}
