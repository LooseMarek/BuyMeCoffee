import SwiftUI

/// A view modifier that presents the Buy Me a Coffee drawer as a sheet.
///
/// This is the primary integration point for host apps. Apply it to any view to enable
/// tip drawer presentation with a single line of code.
///
/// ## Usage
///
/// ```swift
/// @State private var showTipJar = false
///
/// var body: some View {
///     Button("Support") {
///         showTipJar = true
///     }
///     .buyMeCoffee(
///         isPresented: $showTipJar,
///         productIDs: [
///             "com.example.tip.small",
///             "com.example.tip.medium",
///             "com.example.tip.large"
///         ]
///     )
/// }
/// ```
///
/// ## Parameters
///
/// - `isPresented`: A binding that controls whether the drawer is presented
/// - `productIDs`: The exact App Store Connect product IDs to fetch
/// - `theme`: Optional theme. Defaults to `BuyMeCoffeeTheme.default`
struct BuyMeCoffeeViewModifier: ViewModifier {

    @Binding var isPresented: Bool
    let productIDs: [String]
    let theme: BuyMeCoffeeTheme

    func body(content: Content) -> some View {
        content
            .environment(\.buyMeCoffeeIsPresented, $isPresented)
            .sheet(isPresented: $isPresented) {
                BuyMeCoffeeView(
                    provider: StoreKitProductProvider.live(),
                    productIDs: productIDs
                )
                .environment(\.buyMeCoffeeTheme, theme)
            }
    }
}

extension View {
    /// Presents the Buy Me a Coffee tip drawer as a sheet.
    ///
    /// Apply this modifier to any view to enable tip drawer presentation. The drawer is
    /// presented as a sheet when `isPresented` becomes `true`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// @State private var showTipJar = false
    ///
    /// var body: some View {
    ///     Button("Support") {
    ///         showTipJar = true
    ///     }
    ///     .buyMeCoffee(
    ///         isPresented: $showTipJar,
    ///         productIDs: [
    ///             "com.example.tip.small",
    ///             "com.example.tip.medium",
    ///             "com.example.tip.large"
    ///         ]
    ///     )
    /// }
    /// ```
    ///
    /// ## Parameters
    ///
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the drawer is presented
    ///   - productIDs: The exact App Store Connect product IDs to fetch.
    ///     The drawer will fetch all products matching these IDs.
    ///   - theme: Optional theme. Defaults to `BuyMeCoffeeTheme.default`
    ///
    /// ## Product ID Configuration
    ///
    /// Configure your tip products in App Store Connect with IDs like:
    /// - `com.example.tip.small`
    /// - `com.example.tip.medium`
    /// - `com.example.tip.large`
    ///
    /// Then pass them as an array to `productIDs`.
    ///
    /// ## Theming
    ///
    /// Customize the drawer's appearance by passing a custom theme:
    ///
    /// ```swift
    /// .buyMeCoffee(
    ///     isPresented: $showTipJar,
    ///     productIDs: ["com.example.tip.small", "com.example.tip.large"],
    ///     theme: myCustomTheme
    /// )
    /// ```
    public func buyMeCoffee(
        isPresented: Binding<Bool>,
        productIDs: [String],
        theme: BuyMeCoffeeTheme = .default
    ) -> some View {
        modifier(
            BuyMeCoffeeViewModifier(
                isPresented: isPresented,
                productIDs: productIDs,
                theme: theme
            )
        )
    }
}
