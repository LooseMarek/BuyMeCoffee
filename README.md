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

### 1. Configure products in App Store Connect

Create consumable in-app purchase products in App Store Connect. BuyMeCoffee discovers them by a shared prefix, so name them consistently:

```
com.yourapp.tip.small
com.yourapp.tip.medium
com.yourapp.tip.large
```

You can use any prefix — just make sure all tip products share it.

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
            productIDPrefix: "com.yourapp.tip"
        )
    }
}
```

The drawer fetches all products whose App Store Connect IDs begin with the supplied prefix, displays them with their localised names and prices, and handles the full StoreKit 2 purchase flow — including loading, error, and thank-you states.

---

## Configuration

### Parameters

| Parameter         | Type                   | Default                  | Description |
|-------------------|------------------------|--------------------------|-------------|
| `isPresented`     | `Binding<Bool>`        | —                        | Controls whether the drawer is presented |
| `productIDPrefix` | `String`               | —                        | App Store Connect product ID prefix shared by all tip products |
| `theme`           | `BuyMeCoffeeTheme`     | `.default`               | Visual theme for the drawer |

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
        productIDPrefix: "com.yourapp.tip",
        theme: myTheme
    )
```

All colours are fixed (not adaptive to system appearance) so the drawer looks consistent in both light and dark mode.

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

## License

Private — all rights reserved.
