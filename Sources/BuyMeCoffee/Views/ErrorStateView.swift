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

    /// Label customisation object (icon and headline).
    let labels: ErrorStateLabels

    /// The error message to display as body text (derived from the thrown error).
    let errorMessage: String
    
    /// Closure called when the view should dismiss (either after timeout or on tap).
    let onDismiss: () -> Void

    // MARK: - Initializer

    /// Creates an error state view with customizable content.
    ///
    /// - Parameters:
    ///   - labels: Label customisation object. Defaults to `.init()`.
    ///   - errorMessage: The error message to display as body text.
    ///   - onDismiss: Closure called when the view dismisses.
    init(
        labels: ErrorStateLabels = .init(),
        errorMessage: String = "Something went wrong. Please try again later.",
        onDismiss: @escaping () -> Void
    ) {
        self.labels = labels
        self.errorMessage = errorMessage
        self.onDismiss = onDismiss
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Icon
            Image(systemName: labels.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundStyle(theme.errorColor)
                .accessibilityHidden(true)

            // Headline
            Text(labels.headline)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(theme.primaryTextColor)
                .padding(.top, 16)

            // Body
            Text(errorMessage)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(theme.secondaryTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(theme.backgroundColor)
        #if os(macOS)
        .onTapGesture {
            onDismiss()
        }
        #endif
    }
}

// MARK: - Previews

#Preview("Default Theme") {
    ErrorStateView(onDismiss: {})
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

    ErrorStateView(
        labels: ErrorStateLabels(iconName: "wifi.slash", headline: "Connection failed"),
        errorMessage: "Custom error message for demonstration.",
        onDismiss: {}
    )
        .environment(\.buyMeCoffeeTheme, customTheme)
        .frame(width: 375, height: 200)
}
