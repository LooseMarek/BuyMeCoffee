import Foundation

/// Label customisation for the empty state view.
///
/// All properties have default values. Callers can provide custom values for specific
/// properties while others retain their defaults — e.g., override only the icon while
/// keeping the default texts.
public struct EmptyStateLabels: Sendable {

    /// SF Symbol name for the icon. Default: "cart.badge.questionmark"
    public var iconName: String

    /// Headline text. Default: "No tips available"
    public var headline: String

    /// Body text. Default: "Check your product IDs are configured in App Store Connect."
    public var bodyText: String

    /// Creates an empty state labels object.
    ///
    /// - Parameters:
    ///   - iconName: SF Symbol name. Defaults to "cart.badge.questionmark".
    ///   - headline: Headline text. Defaults to "No tips available".
    ///   - bodyText: Body text. Defaults to "Check your product IDs are configured in App Store Connect."
    public init(
        iconName: String = "cart.badge.questionmark",
        headline: String = "No tips available",
        bodyText: String = "Check your product IDs are configured in App Store Connect."
    ) {
        self.iconName = iconName
        self.headline = headline
        self.bodyText = bodyText
    }
}
