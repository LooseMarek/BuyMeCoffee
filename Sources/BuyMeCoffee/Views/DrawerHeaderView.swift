import SwiftUI

/// Header view for the Buy Me Coffee drawer, displaying an optional icon, title, and subtitle.
///
/// This internal view renders the configurable header at the top of the tip drawer.
/// All visual tokens (colours, spacing, typography) are pulled from `BuyMeCoffeeTheme`
/// via the SwiftUI environment.
///
/// - Note: All parameters are optional. If `iconImage` is omitted, the icon container is
///   not rendered and the text block fills the full width.
struct DrawerHeaderView: View {

    // MARK: - Environment

    @Environment(\.buyMeCoffeeTheme) private var theme

    // MARK: - Properties

    /// Optional icon image (SF Symbol or custom asset).
    let iconImage: Image?

    /// Optional title text (e.g., "Buy Me a Coffee").
    let title: String?

    /// Optional subtitle/description text (e.g., "Support my work with a small tip").
    let subtitle: String?

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Icon container (56×56pt, rounded 24pt corner radius)
            if let iconImage {
                iconImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .background(theme.productRowBackgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }

            // Text block (title + subtitle)
            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(theme.primaryTextColor)
                        .lineLimit(2)
                        .accessibilityHeading(.h1)
                }

                if let subtitle {
                    Text(subtitle)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(theme.secondaryTextColor)
                        .lineLimit(3)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 56)
    }
}

// MARK: - Previews

#Preview("Default Theme") {
    DrawerHeaderView(
        iconImage: Image(systemName: "cup.and.saucer.fill"),
        title: "Buy Me a Coffee",
        subtitle: "Support my work with a small tip"
    )
    .environment(\.buyMeCoffeeTheme, .default)
    .frame(width: 360)
    .padding()
    .background(BuyMeCoffeeTheme.default.backgroundColor)
}

#Preview("Custom Theme") {
    let customTheme = BuyMeCoffeeTheme(
        backgroundColor: Color(red: 0x16 / 255.0, green: 0x18 / 255.0, blue: 0x2A / 255.0),
        primaryTextColor: Color(red: 0xFF / 255.0, green: 0xD7 / 255.0, blue: 0x00 / 255.0),
        secondaryTextColor: Color(red: 0xFF / 255.0, green: 0xA5 / 255.0, blue: 0x00 / 255.0),
        accentStartColor: .purple,
        accentEndColor: .pink,
        productRowBackgroundColor: Color(red: 0x1F / 255.0, green: 0x22 / 255.0, blue: 0x35 / 255.0),
        separatorColor: Color(red: 0x2E / 255.0, green: 0x31 / 255.0, blue: 0x50 / 255.0),
        surfaceElevatedColor: Color(red: 0x27 / 255.0, green: 0x2A / 255.0, blue: 0x40 / 255.0),
        textOnAccentColor: .white,
        successColor: Color(red: 0x52 / 255.0, green: 0xD3 / 255.0, blue: 0x8C / 255.0),
        errorColor: Color(red: 0xE0 / 255.0, green: 0x52 / 255.0, blue: 0x52 / 255.0)
    )

    return DrawerHeaderView(
        iconImage: Image(systemName: "heart.fill"),
        title: "Support This App",
        subtitle: "Your tips help keep development going"
    )
    .environment(\.buyMeCoffeeTheme, customTheme)
    .frame(width: 360)
    .padding()
    .background(customTheme.backgroundColor)
}

#Preview("No Icon") {
    DrawerHeaderView(
        iconImage: nil,
        title: "Buy Me a Coffee",
        subtitle: "Support my work with a small tip"
    )
    .environment(\.buyMeCoffeeTheme, .default)
    .frame(width: 360)
    .padding()
    .background(BuyMeCoffeeTheme.default.backgroundColor)
}

#Preview("Title Only") {
    DrawerHeaderView(
        iconImage: Image(systemName: "cup.and.saucer.fill"),
        title: "Buy Me a Coffee",
        subtitle: nil
    )
    .environment(\.buyMeCoffeeTheme, .default)
    .frame(width: 360)
    .padding()
    .background(BuyMeCoffeeTheme.default.backgroundColor)
}
