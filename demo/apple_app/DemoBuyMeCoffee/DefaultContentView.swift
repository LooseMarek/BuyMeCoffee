import SwiftUI
import BuyMeCoffee

struct ContentView: View {
    @State private var isBuyMeCoffeePresented = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)

                Text("Default Configuration")
                    .font(.title2.bold())

                Text("All default BuyMeCoffee settings — only productIDs and a custom subtitle are provided.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Button("Buy Me a Coffee") {
                    isBuyMeCoffeePresented = true
                }
                .buttonStyle(.borderedProminent)

                NavigationLink("View Inline Example") {
                    InlineContentView()
                }
            }
            .padding(32)
        }
        .buyMeCoffee(
            isPresented: $isBuyMeCoffeePresented,
            productIDs: [
                "com.marekloose.DemoBuyMeCoffee.tip.small",
                "com.marekloose.DemoBuyMeCoffee.tip.medium",
                "com.marekloose.DemoBuyMeCoffee.tip.large"
            ],
            headerLabels: .init(
                subtitle: "I'm an indie developer who builds apps without subscriptions, paywalls, or ads. Your tip helps keep this app free for everyone."
            )
        )
    }
}

#Preview {
    ContentView()
}
