# BuyMeCoffee

> A SwiftUI-native StoreKit 2 tip-jar Swift Package that any iOS or macOS app can drop in to present a configurable 'Buy Me a Coffee' bottom drawer with zero boilerplate.

---

## Requirements

- See individual component folders for platform-specific requirements.

---

## Getting Started

### Clone the repository

```bash
git clone https://github.com/LooseMarek/BuyMeCoffee.git
cd BuyMeCoffee
```

---

## Project Structure

```
BuyMeCoffee/
├── docs/               # Architecture, ADRs, product, and design docs
├── Package.swift
├── Sources/BuyMeCoffee/
├── Tests/BuyMeCoffeeTests/
```

---

## CI/CD

### GitHub Actions

Workflows in `.github/workflows/` support two trigger modes:

- **Automatic** — triggered on push to `main`/`develop` or on a pull request to `main`, scoped to the relevant component folder.
- **Manual** — all workflows can be triggered from the GitHub Actions tab at any time.

**Beta workflows** (TestFlight / Play Store uploads) are manual-only and restricted to the `main` branch.

### Fastlane

Fastlane lanes mirror each GitHub Actions workflow and can be run locally — useful as a fallback when the self-hosted runner is offline.

```sh
# Run tests (omit udid to use the default simulator)
bundle exec fastlane ios test
bundle exec fastlane ios test udid:YOUR-DEVICE-UUID

# Upload to TestFlight
bundle exec fastlane ios beta
```

> Run `bundle install` first to install Fastlane via Bundler.

---

## Development

Refer to `CLAUDE.md` for agent workflow, coding conventions, and architecture decisions.

---

## License

Private — all rights reserved.
