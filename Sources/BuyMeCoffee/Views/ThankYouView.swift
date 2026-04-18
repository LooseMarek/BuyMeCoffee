import SwiftUI

/// Full-drawer confirmation screen shown after a successful StoreKit purchase.
///
/// `ThankYouView` displays a centered icon, headline, and body text with animated entrance.
/// The view auto-dismisses after 3 seconds or immediately when tapped anywhere.
///
/// - Note: This is an internal view used by `BuyMeCoffeeView` when transitioning to the
///   thank-you state after purchase completion.
struct ThankYouView: View {

    // MARK: - Environment

    @Environment(\.buyMeCoffeeTheme) private var theme

    // MARK: - State

    @State private var containerOpacity: Double = 0
    @State private var containerScale: CGFloat = 0.85
    @State private var iconOpacity: Double = 0
    @State private var iconScale: CGFloat = 0.5

    // MARK: - Properties

    /// Closure called when the view should dismiss (either after timeout or on tap).
    let onDismiss: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 4) {
                // Icon
                Image(systemName: "cup.and.saucer.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64, height: 64)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [theme.accentStartColor, theme.accentEndColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .opacity(iconOpacity)
                    .scaleEffect(iconScale)
                    .accessibilityHidden(true)

                // Headline
                Text("Thank you!")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(theme.primaryTextColor)
                    .padding(.top, 24)
                    .accessibilityAddTraits(.isHeader)

                // Body
                Text("Your support means a lot.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(theme.secondaryTextColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 32)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.backgroundColor)
        .opacity(containerOpacity)
        .scaleEffect(containerScale)
        .contentShape(Rectangle())
        .onTapGesture {
            onDismiss()
        }
        .accessibilityLabel("Dismiss")
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("Tap to dismiss")
        .onAppear {
            playEntranceAnimation()
            scheduleAutoDismiss()
            announceToVoiceOver()
        }
    }

    // MARK: - Private Methods

    /// Plays the two-beat entrance animation: container fades/scales in, then icon pops.
    private func playEntranceAnimation() {
        // Beat 1: Container fade-in with spring scale
        withAnimation(.easeOut(duration: 0.30)) {
            containerOpacity = 1.0
        }
        withAnimation(.spring(dampingFraction: 0.75, blendDuration: 0.30)) {
            containerScale = 1.0
        }

        // Beat 2: Icon pop with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.20)) {
                iconOpacity = 1.0
            }
            withAnimation(.spring(dampingFraction: 0.6, blendDuration: 0.40)) {
                iconScale = 1.0
            }
        }
    }

    /// Schedules auto-dismiss after 3 seconds.
    private func scheduleAutoDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            onDismiss()
        }
    }

    /// Announces purchase completion to VoiceOver users.
    private func announceToVoiceOver() {
        #if os(iOS)
        UIAccessibility.post(
            notification: .announcement,
            argument: "Thank you! Purchase complete."
        )
        #elseif os(macOS)
        NSAccessibility.post(
            element: NSApp as Any,
            notification: .announcementRequested,
            userInfo: [.announcement: "Thank you! Purchase complete."]
        )
        #endif
    }
}

// MARK: - Previews

#Preview("Default Theme") {
    ThankYouView(onDismiss: {})
        .environment(\.buyMeCoffeeTheme, .default)
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

    return ThankYouView(onDismiss: {})
        .environment(\.buyMeCoffeeTheme, customTheme)
}
