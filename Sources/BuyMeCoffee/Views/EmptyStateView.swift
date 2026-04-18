import SwiftUI

/// Drawer-level empty state shown when no products are available.
///
/// Displays a centered message informing the user that no tip products were found,
/// with a developer-facing hint about App Store Connect configuration.
///
/// - Note: This is an internal view used by `BuyMeCoffeeView` when the product provider
///   returns an empty array.
struct EmptyStateView: View {

    // MARK: - Environment

    @Environment(\.buyMeCoffeeTheme) private var theme

    // MARK: - Properties

    /// The SF Symbol name for the icon.
    let iconName: String

    /// The headline text.
    let headline: String

    /// The body text.
    let bodyText: String

    // MARK: - Initializer

    /// Creates an empty state view with customizable content.
    ///
    /// - Parameters:
    ///   - iconName: SF Symbol name. Default: "cart.badge.questionmark"
    ///   - headline: Headline text. Default: "No tips available"
    ///   - bodyText: Body text. Default: "Check your product IDs are configured in App Store Connect."
    init(
        iconName: String = "cart.badge.questionmark",
        headline: String = "No tips available",
        bodyText: String = "Check your product IDs are configured in App Store Connect."
    ) {
        self.iconName = iconName
        self.headline = headline
        self.bodyText = bodyText
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Icon
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundStyle(theme.secondaryTextColor)
                .accessibilityHidden(true)

            // Headline
            Text(headline)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(theme.primaryTextColor)
                .padding(.top, 16)

            // Body
            Text(bodyText)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(theme.secondaryTextColor)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .padding(.horizontal, 32)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .frame(idealHeight: 200)
        .background(theme.backgroundColor)
    }
}

// MARK: - Previews

#Preview("Default Theme") {
    EmptyStateView()
        .environment(\.buyMeCoffeeTheme, .default)
        .frame(width: 375, height: 200)
}

#Preview("Custom Theme") {
    let customTheme = BuyMeCoffeeTheme(
        backgroundColor: .white,
        primaryTextColor: .black,
        secondaryTextColor: .gray,
        accentStartColor: .blue,
        accentEndColor: .purple,
        productRowBackgroundColor: .white,
        separatorColor: .gray.opacity(0.3),
        surfaceElevatedColor: .gray.opacity(0.1),
        textOnAccentColor: .white,
        successColor: .green,
        errorColor: .red
    )

    return EmptyStateView(
        iconName: "tray",
        headline: "Nothing here yet",
        bodyText: "Custom empty state message for demonstration."
    )
        .environment(\.buyMeCoffeeTheme, customTheme)
        .frame(width: 375, height: 200)
}
