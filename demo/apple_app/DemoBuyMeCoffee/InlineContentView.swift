import SwiftUI
import BuyMeCoffee

/// Demonstrates `BuyMeCoffeeInlineView` embedded directly inside an ordinary scrolling layout —
/// not presented as a sheet or drawer. It sits between regular page content to prove it flows
/// inline, and shows both the header-visible and header-hidden variants alongside a themed and a
/// default (transparent) background.
struct InlineContentView: View {
    private let productIDs = [
        "com.marekloose.DemoBuyMeCoffee.tip.small",
        "com.marekloose.DemoBuyMeCoffee.tip.medium",
        "com.marekloose.DemoBuyMeCoffee.tip.large"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("This tip list is embedded inline — it's part of the page, not a sheet or drawer. Content can appear above and below it.")
                    .font(.body)
                    .foregroundStyle(.secondary)

                Text("Header shown · themed background")
                    .font(.headline)
                BuyMeCoffeeInlineView(
                    provider: StoreKitProductProvider.live(),
                    productIDs: productIDs,
                    background: .themed,
                    showHeader: true,
                    headerLabels: .init(
                        subtitle: "Embedded right in the page — no sheet in sight."
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Text("Header hidden · transparent background")
                    .font(.headline)
                BuyMeCoffeeInlineView(
                    provider: StoreKitProductProvider.live(),
                    productIDs: productIDs,
                    showHeader: false
                )

                Text("More screen content can follow the tip list, showing it flows inline with the rest of the layout.")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
        }
        .environment(\.buyMeCoffeeTheme, .default)
        .navigationTitle("Inline Example")
    }
}

#Preview {
    NavigationStack {
        InlineContentView()
    }
}
