import Foundation

/// Label customisation for the empty state view.
///
/// All properties are optional. When a property is `nil`, the view uses its hardcoded default.
/// This allows partial customisation — e.g., only override the icon while keeping the default texts.
public struct EmptyStateLabels: Sendable {

    /// Optional custom icon name. Default: "cart.badge.questionmark"
    public var iconName: String?

    /// Optional custom headline. Default: "No tips available"
    public var headline: String?

    /// Optional custom body text. Default: "Check your product IDs are configured in App Store Connect."
    public var bodyText: String?

    /// Creates an empty state labels object.
    ///
    /// - Parameters:
    ///   - iconName: Optional SF Symbol name. If `nil`, falls back to default.
    ///   - headline: Optional headline text. If `nil`, falls back to default.
    ///   - bodyText: Optional body text. If `nil`, falls back to default.
    public init(
        iconName: String? = nil,
        headline: String? = nil,
        bodyText: String? = nil
    ) {
        self.iconName = iconName
        self.headline = headline
        self.bodyText = bodyText
    }

    /// Default label values matching SPM-internal defaults.
    public static let `default` = EmptyStateLabels(
        iconName: "cart.badge.questionmark",
        headline: "No tips available",
        bodyText: "Check your product IDs are configured in App Store Connect."
    )
}
