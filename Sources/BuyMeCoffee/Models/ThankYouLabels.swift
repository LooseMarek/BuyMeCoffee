import Foundation

/// Label customisation for the thank-you view.
///
/// All properties have default values. Callers can provide custom values for specific
/// properties while others retain their defaults — e.g., override only the title while
/// keeping the default subtitle and accessibility labels.
public struct ThankYouLabels: Sendable {

    /// Title text. Default: "Thank you!"
    public var title: String

    /// Subtitle text. Default: "Your support means a lot."
    public var subtitle: String

    /// SF Symbol name for the icon. Default: "cup.and.saucer.fill"
    public var iconName: String

    /// Accessibility label for the dismiss action. Default: "Dismiss"
    public var dismissAccessibilityLabel: String

    /// Accessibility hint for the dismiss action. Default: "Tap to dismiss"
    public var dismissAccessibilityHint: String

    /// VoiceOver announcement on appear. Default: "Thank you! Purchase complete."
    public var voiceOverAnnouncement: String

    /// Creates a thank-you labels object.
    ///
    /// - Parameters:
    ///   - title: Title text. Defaults to "Thank you!".
    ///   - subtitle: Subtitle text. Defaults to "Your support means a lot."
    ///   - iconName: SF Symbol name. Defaults to "cup.and.saucer.fill".
    ///   - dismissAccessibilityLabel: Accessibility label. Defaults to "Dismiss".
    ///   - dismissAccessibilityHint: Accessibility hint. Defaults to "Tap to dismiss".
    ///   - voiceOverAnnouncement: VoiceOver announcement. Defaults to "Thank you! Purchase complete."
    public init(
        title: String = "Thank you!",
        subtitle: String = "Your support means a lot.",
        iconName: String = "cup.and.saucer.fill",
        dismissAccessibilityLabel: String = "Dismiss",
        dismissAccessibilityHint: String = "Tap to dismiss",
        voiceOverAnnouncement: String = "Thank you! Purchase complete."
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.dismissAccessibilityLabel = dismissAccessibilityLabel
        self.dismissAccessibilityHint = dismissAccessibilityHint
        self.voiceOverAnnouncement = voiceOverAnnouncement
    }
}
