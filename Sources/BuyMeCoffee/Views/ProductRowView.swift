import SwiftUI

/// An internal view that displays a single tip product with name, description, and price button.
///
/// This view renders one `TipProduct` in the tip jar drawer's product list. The price button
/// triggers purchase when tapped. All visual tokens are sourced from `BuyMeCoffeeTheme` via
/// the SwiftUI environment.
struct ProductRowView: View {
    // MARK: - Properties

    /// The tip product to display
    let product: TipProduct

    /// Action closure called when the price button is tapped
    let onTap: () -> Void

    // MARK: - Environment

    @Environment(\.buyMeCoffeeTheme) private var theme

    // MARK: - Body

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Text Block (leading, flexible width)
            VStack(alignment: .leading, spacing: 4) {
                // Product Name
                Text(product.displayName)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(theme.primaryTextColor)
                    .lineLimit(1)
                    .truncationMode(.tail)

                // Product Description
                Text(product.description)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(theme.secondaryTextColor)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 8)

            // Price Button (trailing, fixed min width)
            Button(action: onTap) {
                Text(product.displayPrice)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(theme.textOnAccentColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(minWidth: 70)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [theme.accentStartColor, theme.accentEndColor]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel("Buy \(product.displayName) for \(product.displayPrice)")
        }
        .padding(16)
        .background(theme.productRowBackgroundColor)
        .cornerRadius(16)
    }
}
