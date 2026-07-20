# BuyMeCoffee

[![Build and Test SPM (iOS)](https://github.com/LooseMarek/BuyMeCoffee/actions/workflows/spm_ios_build_test.yml/badge.svg)](https://github.com/LooseMarek/BuyMeCoffee/actions/workflows/spm_ios_build_test.yml)
[![Build and Test SPM (macOS)](https://github.com/LooseMarek/BuyMeCoffee/actions/workflows/spm_macos_build_test.yml/badge.svg)](https://github.com/LooseMarek/BuyMeCoffee/actions/workflows/spm_macos_build_test.yml)

A SwiftUI-native StoreKit 2 tip-jar Swift Package that any iOS or macOS app can drop in to present a configurable "Buy Me a Coffee" bottom drawer with zero boilerplate.

---

## Requirements

| Platform | Minimum Version |
|----------|----------------|
| iOS      | 17.0+          |
| macOS    | 14.0+          |
| Swift    | 6.2+           |
| Xcode    | 16.0+          |

---

## Installation

### Swift Package Manager

Add the package to your app target in Xcode:

1. In Xcode, go to **File > Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/LooseMarek/BuyMeCoffee
   ```
3. Select **Up to Next Major Version** starting from the latest release.
4. Add the `BuyMeCoffee` library to your app target.

Or add it directly to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/LooseMarek/BuyMeCoffee",
        from: "1.0.0"
    ),
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "BuyMeCoffee", package: "BuyMeCoffee"),
        ]
    ),
]
```

---

## Usage

> **Recommended:** Use the `.buyMeCoffee()` view modifier for the simplest integration.

### 1. Configure products in App Store Connect

Create consumable in-app purchase products in App Store Connect. Configure them with unique product IDs:

```
com.yourapp.tip.small
com.yourapp.tip.medium
com.yourapp.tip.large
```

### 2. Apply the `.buyMeCoffee` modifier

Import the package and attach the modifier to any view. Toggling `isPresented` to `true` presents the drawer as a sheet.

```swift
import SwiftUI
import BuyMeCoffee

struct ContentView: View {
    @State private var showTipJar = false

    var body: some View {
        Button("Buy Me a Coffee") {
            showTipJar = true
        }
        .buyMeCoffee(
            isPresented: $showTipJar,
            productIDs: [
                "com.yourapp.tip.small",
                "com.yourapp.tip.medium",
                "com.yourapp.tip.large"
            ]
        )
    }
}
```

The drawer fetches the specified products, displays them with their localised names and prices, and handles the full StoreKit 2 purchase flow — including loading, error, and thank-you states.

### 3. Alternative: Environment key for nested views

If you need to trigger the drawer from a deeply nested view without prop-drilling, use the environment key:

```swift
struct ContentView: View {
    @State private var showTipJar = false

    var body: some View {
        NavigationStack {
            DeepChildView()
        }
        .buyMeCoffee(
            isPresented: $showTipJar,
            productIDs: ["com.yourapp.tip.small", "com.yourapp.tip.large"]
        )
    }
}

struct DeepChildView: View {
    @Environment(\.buyMeCoffeeIsPresented) private var isPresented

    var body: some View {
        Button("Support") {
            isPresented.wrappedValue = true
        }
    }
}
```

### 4. Alternative: Embed the tip list inline

If you want the tip list to live *inside* your own layout — on a settings or about screen, for example — instead of being presented as a sheet, use `BuyMeCoffeeInlineView`. It renders the same product rows (and, optionally, the same header) as the drawer, but with no sheet, popover, or modal chrome, so it flows with the surrounding content.

```swift
import SwiftUI
import BuyMeCoffee

struct AboutView: View {
    private let productIDs = [
        "com.yourapp.tip.small",
        "com.yourapp.tip.medium",
        "com.yourapp.tip.large"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Enjoying the app?")
                    .font(.headline)

                BuyMeCoffeeInlineView(
                    provider: StoreKitProductProvider.live(),
                    productIDs: productIDs,
                    sortOrder: .ascending,
                    background: .themed,
                    showHeader: false
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

                Text("Thanks for your support!")
                    .foregroundStyle(.secondary)
            }
            .padding(24)
        }
        .environment(\.buyMeCoffeeTheme, .default)
    }
}
```

The inline view takes the same `provider` / `productIDs` / `sortOrder` inputs as the drawer and adds two presentation options:

| Parameter    | Type                        | Default        | Description |
|--------------|-----------------------------|----------------|-------------|
| `sortOrder`  | `TipSortOrder`              | `.ascending`   | Order tip products are displayed in, by price (`.ascending` or `.descending`) |
| `showHeader` | `Bool`                      | `true`         | Whether the drawer's header (icon, title, subtitle) is rendered above the rows. Pass `false` for a bare list of tip rows when your screen already provides its own title/context |
| `background` | `BuyMeCoffeeInlineBackground`| `.transparent` | Background fill painted behind the content (see below) |

Unlike the drawer — which always fills `theme.backgroundColor` — the inline view is **transparent by default** so it inherits the host's background and blends into your layout. Opt into a fill via `background`:

- `.transparent` (default): host background shows through.
- `.themed`: drawer-parity fill using the environment `BuyMeCoffeeTheme`'s `backgroundColor`.
- `.custom(Color)`: any solid colour, e.g. `.custom(.white)` inside a card.

`ProductRowView` children pick up the `BuyMeCoffeeTheme` from the environment exactly like the drawer does, so theming is configured the same way (see [Theming](#theming) below).

### 5. Alternative: Direct sheet presentation

For custom presentation control, use `BuyMeCoffeeView` directly in a sheet:

```swift
import SwiftUI
import BuyMeCoffee

struct ContentView: View {
    @State private var showTipJar = false

    var body: some View {
        Button("Buy Me a Coffee") {
            showTipJar = true
        }
        .sheet(isPresented: $showTipJar) {
            BuyMeCoffeeView(
                provider: StoreKitProductProvider.live(),
                productIDs: [
                    "com.yourapp.tip.small",
                    "com.yourapp.tip.large"
                ]
            )
            .presentationDetents([.medium])
            .environment(\.buyMeCoffeeTheme, .default)
        }
    }
}
```

---

## Configuration

### Parameters

| Parameter         | Type                   | Default                  | Description |
|-------------------|------------------------|--------------------------|-------------|
| `isPresented`     | `Binding<Bool>`        | —                        | Controls whether the drawer is presented |
| `productIDs`      | `[String]`             | —                        | Exact App Store Connect product IDs to fetch |
| `theme`           | `BuyMeCoffeeTheme`     | `.default`               | Visual theme for the drawer |
| `sortOrder`       | `TipSortOrder`         | `.ascending`             | Order tip products are displayed in, by price (`.ascending` or `.descending`) |
| `headerLabels`    | `DrawerHeaderLabels`   | `.init()`                | Header label customisation (icon, title, subtitle) |
| `emptyStateLabels`| `EmptyStateLabels`     | `.init()`                | Empty state label customisation |
| `errorStateLabels`| `ErrorStateLabels`     | `.init()`                | Error state label customisation |
| `thankYouLabels`  | `ThankYouLabels`       | `.init()`                | Thank-you screen label customisation |

### Theming

Customise the drawer to match your app's brand by passing a `BuyMeCoffeeTheme`:

```swift
let myTheme = BuyMeCoffeeTheme(
    backgroundColor: .black,
    primaryTextColor: .white,
    secondaryTextColor: .gray,
    accentStartColor: .orange,
    accentEndColor: .red,
    productRowBackgroundColor: Color(white: 0.1),
    separatorColor: Color(white: 0.15),
    surfaceElevatedColor: Color(white: 0.2),
    textOnAccentColor: .white,
    successColor: .green,
    errorColor: .red
)

Button("Support") { showTipJar = true }
    .buyMeCoffee(
        isPresented: $showTipJar,
        productIDs: ["com.yourapp.tip.small", "com.yourapp.tip.large"],
        theme: myTheme
    )
```

All colours are fixed (not adaptive to system appearance) so the drawer looks consistent in both light and dark mode.

### Sort Order

Tip products are displayed sorted by price. `sortOrder` defaults to `.ascending` (cheapest first); pass `.descending` for most-expensive first. It is accepted by the `.buyMeCoffee` modifier, `BuyMeCoffeeView`, and `BuyMeCoffeeInlineView` alike:

```swift
.buyMeCoffee(
    isPresented: $showTipJar,
    productIDs: ["com.yourapp.tip.small", "com.yourapp.tip.large"],
    sortOrder: .descending
)
```

### Label Customisation

Customise the text and icons for specific screens while leaving others as defaults:

```swift
.buyMeCoffee(
    isPresented: $showTipJar,
    productIDs: ["com.yourapp.tip.small"],
    headerLabels: DrawerHeaderLabels(
        iconImage: Image(systemName: "heart.fill"),
        title: "Support This App"
        // subtitle omitted — uses SPM default
    ),
    thankYouLabels: ThankYouLabels(title: "You're awesome!")
    // emptyStateLabels and errorStateLabels omitted — use SPM defaults
)
```

Each label struct provides default values for all properties. You only need to override the specific values you want to change.

#### Default theme colour tokens

| Token                    | Default hex  | Usage |
|--------------------------|-------------|-------|
| `backgroundColor`        | `#16182A`   | Sheet/drawer background |
| `productRowBackgroundColor` | `#1F2235` | Product row card background |
| `surfaceElevatedColor`   | `#272A40`   | Elevated surfaces |
| `separatorColor`         | `#2E3150`   | Hairline dividers |
| `primaryTextColor`       | `#FFFFFF`   | Headings, product names, prices |
| `secondaryTextColor`     | `#8B8FA8`   | Subtitles, descriptions, captions |
| `textOnAccentColor`      | `#FFFFFF`   | Text on accent gradient |
| `accentStartColor`       | `#F5A623`   | Gradient start (warm amber) |
| `accentEndColor`         | `#F07242`   | Gradient end (warm orange) |
| `successColor`           | `#52D38C`   | Thank-you / confirmation state |
| `errorColor`             | `#E05252`   | Inline purchase error messages |

---

## Local Testing with StoreKit Configuration

For local testing without hitting the App Store sandbox, use a StoreKit Configuration file:

### 1. Create a StoreKit Configuration file

In your app's Xcode project:
1. Go to **File → New → File**
2. Select **StoreKit Configuration File**
3. Name it (e.g., `Products.storekit`)
4. Save it in your app's project directory

### 2. Add consumable products

In the `.storekit` file, add consumable products matching your real App Store Connect product IDs:
- Product ID: `com.yourapp.tip.small`
- Product ID: `com.yourapp.tip.medium`
- Product ID: `com.yourapp.tip.large`

Configure the display names, prices, and descriptions as they appear in App Store Connect.

### 3. Configure the scheme

1. In Xcode, go to **Product → Scheme → Edit Scheme**
2. Select **Run → Options**
3. Under **StoreKit Configuration**, select your `.storekit` file
4. Click **Close**

### 4. Run the app

Run your app in the simulator or on a device. StoreKit purchases will use the local configuration file instead of the sandbox server.

**Note:** For unit tests and Xcode Previews, use `@testable import BuyMeCoffee` to access the internal `MockProductProvider`.

---

## License

Private — all rights reserved.
