import Foundation

/// Label customisation for the error state view.
///
/// All properties are optional. When a property is `nil`, the view uses its hardcoded default.
/// This allows partial customisation — e.g., only override the icon while keeping the default headline.
///
/// - Note: The body text is always derived from the thrown error's `localizedDescription` and is not customisable.
public struct ErrorStateLabels: Sendable {

    /// Optional custom icon name. Default: "exclamationmark.triangle"
    public var iconName: String?

    /// Optional custom headline. Default: "Couldn't load tips"
    public var headline: String?

    /// Creates an error state labels object.
    ///
    /// - Parameters:
    ///   - iconName: Optional SF Symbol name. If `nil`, falls back to default.
    ///   - headline: Optional headline text. If `nil`, falls back to default.
    public init(
        iconName: String? = nil,
        headline: String? = nil
    ) {
        self.iconName = iconName
        self.headline = headline
    }

    /// Default label values matching SPM-internal defaults.
    public static let `default` = ErrorStateLabels(
        iconName: "exclamationmark.triangle",
        headline: "Couldn't load tips"
    )
}
