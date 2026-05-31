import SwiftUI
import BuyMeCoffee

struct ContentView: View {
    @State private var isBuyMeCoffeePresented = false

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundStyle(.indigo)

            Text("Custom Configuration")
                .font(.title2.bold())

            Text("Every BuyMeCoffee option is customised — theme colours, header, empty state, error state, and thank-you labels.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("Support the Dev") {
                isBuyMeCoffeePresented = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
        }
        .padding(32)
        .buyMeCoffee(
            isPresented: $isBuyMeCoffeePresented,
            productIDs: [
                "com.marekloose.DemoBuyMeCoffee.tip.small",
                "com.marekloose.DemoBuyMeCoffee.tip.medium",
                "com.marekloose.DemoBuyMeCoffee.tip.large"
            ],
            theme: .light,
            headerLabels: .init(
                iconImage: Image(systemName: "heart.fill"),
                title: "Support the Dev",
                subtitle: "Every tip helps me spend more time building features you love and squashing bugs before you find them."
            ),
            emptyStateLabels: .init(
                iconName: "tray",
                headline: "Nothing here yet",
                bodyText: "Tip options aren't available right now. Please try again later."
            ),
            errorStateLabels: .init(
                iconName: "wifi.slash",
                headline: "Something went wrong"
            ),
            thankYouLabels: .init(
                title: "You're amazing!",
                subtitle: "Your generosity keeps this app alive. Seriously, thank you.",
                iconName: "heart.fill",
                dismissAccessibilityLabel: "Close",
                dismissAccessibilityHint: "Tap to close the thank you screen",
                voiceOverAnnouncement: "You're amazing! Thank you for your support."
            )
        )
    }
}

extension BuyMeCoffeeTheme {
    /// Light minimal theme — white background, dark text, indigo-to-purple accent gradient.
    static let light = BuyMeCoffeeTheme(
        backgroundColor: Color(red: 0xFA / 255.0, green: 0xFA / 255.0, blue: 0xFA / 255.0),
        primaryTextColor: Color(red: 0x1C / 255.0, green: 0x1C / 255.0, blue: 0x1E / 255.0),
        secondaryTextColor: Color(red: 0x6C / 255.0, green: 0x6C / 255.0, blue: 0x80 / 255.0),
        accentStartColor: Color(red: 0x58 / 255.0, green: 0x56 / 255.0, blue: 0xD6 / 255.0),
        accentEndColor: Color(red: 0xAF / 255.0, green: 0x52 / 255.0, blue: 0xDE / 255.0),
        productRowBackgroundColor: Color(red: 0xF0 / 255.0, green: 0xF0 / 255.0, blue: 0xF5 / 255.0),
        separatorColor: Color(red: 0xD1 / 255.0, green: 0xD1 / 255.0, blue: 0xDA / 255.0),
        surfaceElevatedColor: Color(red: 0xE8 / 255.0, green: 0xE8 / 255.0, blue: 0xEF / 255.0),
        textOnAccentColor: Color(red: 1.0, green: 1.0, blue: 1.0),
        successColor: Color(red: 0x34 / 255.0, green: 0xC7 / 255.0, blue: 0x59 / 255.0),
        errorColor: Color(red: 1.0, green: 0x3B / 255.0, blue: 0x30 / 255.0)
    )
}

#Preview {
    ContentView()
}
