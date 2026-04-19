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

    /// Label customisation object.
    let labels: EmptyStateLabels
    
    /// Closure called when the view should dismiss.
    let onDismiss: () -> Void

    // MARK: - Initializer

    /// Creates a empty state view with customizable content.
    ///
    /// - Parameters:
    ///   - labels: Label customisation object. Defaults to `.init()`.
    ///   - onDismiss: Closure called when the view dismisses.
    init(
        labels: EmptyStateLabels = .init(),
        onDismiss: @escaping () -> Void
    ) {
        self.labels = labels
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
                .foregroundStyle(theme.secondaryTextColor)
                .accessibilityHidden(true)

            // Headline
            Text(labels.headline)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(theme.primaryTextColor)
                .padding(.top, 16)

            // Body
            Text(labels.bodyText)
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
    EmptyStateView(onDismiss: {})
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

    EmptyStateView(
        labels: EmptyStateLabels(
            iconName: "tray",
            headline: "Nothing here yet",
            bodyText: "Custom empty state message for demonstration."
        ),
        onDismiss: {}
    )
    .environment(\.buyMeCoffeeTheme, customTheme)
    .frame(width: 375, height: 200)
}
