import SwiftUI

/// The background fill applied behind `BuyMeCoffeeInlineView`'s content.
///
/// Unlike `BuyMeCoffeeView` — the drawer, which always fills `theme.backgroundColor` — the inline
/// view is designed to sit inside a host layout, so it is **transparent by default** and lets the
/// host's own background show through. Use this type to opt into a solid fill when a context needs
/// visual separation (e.g. inside a card).
///
/// This is deliberately a small, standalone type rather than an addition to `BuyMeCoffeeTheme`: it
/// keeps the drawer's theme contract unchanged and avoids introducing a parallel theme mechanism.
///
/// ## Cases
///
/// - ``transparent``: fully transparent (`Color.clear`) — the default. The host background shows
///   through.
/// - ``themed``: drawer-parity fill using the environment `BuyMeCoffeeTheme`'s own
///   `backgroundColor`, without modifying the theme itself.
/// - ``custom(_:)``: any host-supplied `Color`.
///
/// ## Usage
///
/// ```swift
/// // Transparent (default) — blends into the host screen.
/// BuyMeCoffeeInlineView(provider: provider, productIDs: ids)
///
/// // Drawer-parity themed background.
/// BuyMeCoffeeInlineView(provider: provider, productIDs: ids, background: .themed)
///
/// // Custom solid colour, e.g. inside a card.
/// BuyMeCoffeeInlineView(provider: provider, productIDs: ids, background: .custom(.white))
/// ```
public enum BuyMeCoffeeInlineBackground: Equatable, Sendable {

    /// Fully transparent (`Color.clear`). The host app's own background shows through. Default.
    case transparent

    /// Drawer-parity fill using the environment `BuyMeCoffeeTheme`'s own `backgroundColor`.
    case themed

    /// A host-supplied solid background colour.
    case custom(Color)

    /// Resolves this case to a concrete `Color`, reading the theme only when `.themed`.
    ///
    /// - Parameter theme: The environment `BuyMeCoffeeTheme`, used only by the `.themed` case.
    /// - Returns: `Color.clear` for `.transparent`, `theme.backgroundColor` for `.themed`, or the
    ///   wrapped colour for `.custom`.
    func resolvedColor(theme: BuyMeCoffeeTheme) -> Color {
        switch self {
        case .transparent:
            return .clear
        case .themed:
            return theme.backgroundColor
        case .custom(let color):
            return color
        }
    }
}
