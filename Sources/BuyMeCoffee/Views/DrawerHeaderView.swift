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

    /// Label customisation object.
    let labels: DrawerHeaderLabels
    
    /// Closure called when the view should dismiss.
    let onDismiss: () -> Void

    // MARK: - Initializer

    /// Creates a drawer header  view with customizable content.
    ///
    /// - Parameters:
    ///   - labels: Label customisation object. Defaults to `.init()`.
    ///   - onDismiss: Closure called when the view dismisses.
    init(
        labels: DrawerHeaderLabels = .init(),
        onDismiss: @escaping () -> Void
    ) {
        self.labels = labels
        self.onDismiss = onDismiss
    }

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Icon container: 30pt icon centred in 56×56pt surface, 16pt corner radius
            labels.iconImage
                .resizable()
                .scaledToFit()
                .foregroundStyle(theme.primaryTextColor)
                .frame(width: 30, height: 30)
                .frame(width: 56, height: 56)
                .background(theme.productRowBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            // Text block (title + subtitle)
            VStack(alignment: .leading, spacing: 4) {
                #if os(macOS)
                HStack {
                    Text(labels.title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(theme.primaryTextColor)
                        .accessibilityHeading(.h1)
                    Spacer()
                    Image(systemName: "xmark")
                        .foregroundStyle(theme.primaryTextColor)
                        .frame(width: 32, height: 32)
                        .onTapGesture {
                            onDismiss()
                        }
                }
                #else
                Text(labels.title)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(theme.primaryTextColor)
                    .accessibilityHeading(.h1)
                #endif

                Text(labels.subtitle)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(theme.secondaryTextColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 56)
    }
}

// MARK: - Previews

#Preview("Default Theme") {
    DrawerHeaderView(labels: .init(), onDismiss: {})
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
        labels: DrawerHeaderLabels(
            iconImage: Image(systemName: "heart.fill"),
            title: "Support This App",
            subtitle: "Your tips help keep development going"
        ),
        onDismiss: {}
    )
    .environment(\.buyMeCoffeeTheme, customTheme)
    .frame(width: 360)
    .padding()
    .background(customTheme.backgroundColor)
}

#Preview("Custom Title") {
    DrawerHeaderView(
        labels: DrawerHeaderLabels(
            title: "Support This Project"
        ),
        onDismiss: {}
    )
    .environment(\.buyMeCoffeeTheme, .default)
    .frame(width: 360)
    .padding()
    .background(BuyMeCoffeeTheme.default.backgroundColor)
}
