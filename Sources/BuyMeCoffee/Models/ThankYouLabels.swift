import Foundation

/// Label customisation for the thank-you view.
///
/// All properties are optional. When a property is `nil`, the view uses its hardcoded default.
/// This allows partial customisation — e.g., only override the title while keeping the default subtitle and accessibility labels.
public struct ThankYouLabels: Sendable {

    /// Optional custom title. Default: "Thank you!"
    public var title: String?

    /// Optional custom subtitle. Default: "Your support means a lot."
    public var subtitle: String?

    /// Optional custom icon name. Default: "cup.and.saucer.fill"
    public var iconName: String?

    /// Optional custom accessibility label for the dismiss action. Default: "Dismiss"
    public var dismissAccessibilityLabel: String?

    /// Optional custom accessibility hint for the dismiss action. Default: "Tap to dismiss"
    public var dismissAccessibilityHint: String?

    /// Optional custom VoiceOver announcement on appear. Default: "Thank you! Purchase complete."
    public var voiceOverAnnouncement: String?

    /// Creates a thank-you labels object.
    ///
    /// - Parameters:
    ///   - title: Optional title text. If `nil`, falls back to default.
    ///   - subtitle: Optional subtitle text. If `nil`, falls back to default.
    ///   - iconName: Optional SF Symbol name. If `nil`, falls back to default.
    ///   - dismissAccessibilityLabel: Optional accessibility label. If `nil`, falls back to default.
    ///   - dismissAccessibilityHint: Optional accessibility hint. If `nil`, falls back to default.
    ///   - voiceOverAnnouncement: Optional VoiceOver announcement. If `nil`, falls back to default.
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        iconName: String? = nil,
        dismissAccessibilityLabel: String? = nil,
        dismissAccessibilityHint: String? = nil,
        voiceOverAnnouncement: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.dismissAccessibilityLabel = dismissAccessibilityLabel
        self.dismissAccessibilityHint = dismissAccessibilityHint
        self.voiceOverAnnouncement = voiceOverAnnouncement
    }

    /// Default label values matching SPM-internal defaults.
    public static let `default` = ThankYouLabels(
        title: "Thank you!",
        subtitle: "Your support means a lot.",
        iconName: "cup.and.saucer.fill",
        dismissAccessibilityLabel: "Dismiss",
        dismissAccessibilityHint: "Tap to dismiss",
        voiceOverAnnouncement: "Thank you! Purchase complete."
    )
}
