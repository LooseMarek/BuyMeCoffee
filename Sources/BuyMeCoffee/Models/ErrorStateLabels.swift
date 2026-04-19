import Foundation

/// Label customisation for the error state view.
///
/// All properties have default values. Callers can provide custom values for specific
/// properties while others retain their defaults — e.g., override only the icon while
/// keeping the default headline.
///
/// - Note: The body text is always derived from the thrown error's `localizedDescription` and is not customisable.
public struct ErrorStateLabels: Sendable {

    /// SF Symbol name for the icon. Default: "exclamationmark.triangle"
    public var iconName: String

    /// Headline text. Default: "Couldn't load tips"
    public var headline: String

    /// Creates an error state labels object.
    ///
    /// - Parameters:
    ///   - iconName: SF Symbol name. Defaults to "exclamationmark.triangle".
    ///   - headline: Headline text. Defaults to "Couldn't load tips".
    public init(
        iconName: String = "exclamationmark.triangle",
        headline: String = "Couldn't load tips"
    ) {
        self.iconName = iconName
        self.headline = headline
    }
}
