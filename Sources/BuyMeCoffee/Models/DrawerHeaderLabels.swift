import SwiftUI

/// Label customisation for the drawer header.
///
/// All properties are optional. When a property is `nil`, the view uses its hardcoded default.
/// This allows partial customisation — e.g., only override the icon while keeping the default title and subtitle.
public struct DrawerHeaderLabels: Sendable {

    /// Optional custom icon image. Default: SF Symbol "cup.and.saucer.fill"
    public var iconImage: Image?

    /// Optional custom title. Default: "Buy Me a Coffee"
    public var title: String?

    /// Optional custom subtitle. Default: "Support my work with a small tip"
    public var subtitle: String?

    /// Creates a drawer header labels object.
    ///
    /// - Parameters:
    ///   - iconImage: Optional icon image. If `nil`, falls back to default.
    ///   - title: Optional title text. If `nil`, falls back to default.
    ///   - subtitle: Optional subtitle text. If `nil`, falls back to default.
    public init(
        iconImage: Image? = nil,
        title: String? = nil,
        subtitle: String? = nil
    ) {
        self.iconImage = iconImage
        self.title = title
        self.subtitle = subtitle
    }

    /// Default label values matching SPM-internal defaults.
    public static let `default` = DrawerHeaderLabels(
        iconImage: Image(systemName: "cup.and.saucer.fill"),
        title: "Buy Me a Coffee",
        subtitle: "Support my work with a small tip"
    )
}
