import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("DemoBuyMeCoffee")
                .font(.headline)
            Text("Replace this view with your BuyMeCoffee integration.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
