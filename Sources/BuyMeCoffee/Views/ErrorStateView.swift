import SwiftUI

/// Drawer-level error state shown when product fetching fails.
///
/// Displays a centered error message informing the user that tips couldn't be loaded,
/// with a generic fallback message.
///
/// - Note: This is an internal view used by `BuyMeCoffeeView` when the product provider
///   throws an error during fetch.
struct ErrorStateView: View {

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

    /// Creates an error state view with customizable content.
    ///
    /// - Parameters:
    ///   - iconName: SF Symbol name. Default: "exclamationmark.triangle"
    ///   - headline: Headline text. Default: "Couldn't load tips"
    ///   - bodyText: Body text. Default: "Something went wrong. Please try again later."
    init(
        iconName: String = "exclamationmark.triangle",
        headline: String = "Couldn't load tips",
        bodyText: String = "Something went wrong. Please try again later."
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
                .foregroundStyle(theme.errorColor)
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
    ErrorStateView()
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

    return ErrorStateView(
        iconName: "wifi.slash",
        headline: "Connection failed",
        bodyText: "Custom error message for demonstration."
    )
        .environment(\.buyMeCoffeeTheme, customTheme)
        .frame(width: 375, height: 200)
}
