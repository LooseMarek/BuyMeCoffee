import SwiftUI

/// Label customisation for the drawer header.
///
/// All properties have default values. Callers can provide custom values for specific
/// properties while others retain their defaults — e.g., override only the icon while
/// keeping the default title and subtitle.
public struct DrawerHeaderLabels: Sendable {

    /// Icon image. Default: SF Symbol "cup.and.saucer.fill"
    public var iconImage: Image

    /// Title text. Default: "Buy Me a Coffee"
    public var title: String

    /// Subtitle text. Default: "Support my work with a small tip"
    public var subtitle: String

    /// Creates a drawer header labels object.
    ///
    /// - Parameters:
    ///   - iconImage: Icon image. Defaults to SF Symbol "cup.and.saucer.fill".
    ///   - title: Title text. Defaults to "Buy Me a Coffee".
    ///   - subtitle: Subtitle text. Defaults to "Support my work with a small tip".
    public init(
        iconImage: Image = Image(systemName: "cup.and.saucer.fill"),
        title: String = "Buy Me a Coffee",
        subtitle: String = "Support my work with a small tip"
    ) {
        self.iconImage = iconImage
        self.title = title
        self.subtitle = subtitle
    }
}
