import XCTest
import SnapshotTesting
import SwiftUI
@testable import BuyMeCoffee

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

@MainActor
final class BuyMeCoffeeViewSnapshotTests: XCTestCase {

    private let provider: ProductProvider = MockProductProvider(products: [])
    private let productIDs: [String] = []

    // MARK: - Helpers

    #if os(iOS)
    private func wrapForIOS(_ buyMeCoffeeView: BuyMeCoffeeView) -> some View {
        ZStack(alignment: .bottom) {
            Color.gray
                .frame(width: 390, height: 844)
            buyMeCoffeeView
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(8)
        }
    }
    #endif

    #if os(macOS)
    private func wrapForMacOS(_ buyMeCoffeeView: BuyMeCoffeeView) -> some View {
        ZStack(alignment: .center) {
            Color.gray
                .frame(width: 800, height: 600)
            buyMeCoffeeView
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(width: 360, height: 500)
        }
    }
    #endif

    // MARK: - Loading State

    func testLoadingState_iOS() {
        #if os(iOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loading

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingController = UIHostingController(rootView: wrapForIOS(buyMeCoffeeView))
        assertSnapshot(of: hostingController, as: .image, named: "loadingState-iOS")
        #endif
    }

    func testLoadingState_macOS() {
        #if os(macOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loading

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingView = NSHostingView(rootView: wrapForMacOS(buyMeCoffeeView))
        hostingView.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
        assertSnapshot(of: hostingView, as: .image, named: "loadingState-macOS")
        #endif
    }

    // MARK: - Empty State

    func testEmptyState_iOS() {
        #if os(iOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .empty

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingController = UIHostingController(rootView: wrapForIOS(buyMeCoffeeView))
        assertSnapshot(of: hostingController, as: .image, named: "emptyState-iOS")
        #endif
    }

    func testEmptyState_macOS() {
        #if os(macOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .empty

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingView = NSHostingView(rootView: wrapForMacOS(buyMeCoffeeView))
        hostingView.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
        assertSnapshot(of: hostingView, as: .image, named: "emptyState-macOS")
        #endif
    }

    // MARK: - Error State

    func testErrorState_iOS() {
        #if os(iOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .error("Something went wrong")

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingController = UIHostingController(rootView: wrapForIOS(buyMeCoffeeView))
        assertSnapshot(of: hostingController, as: .image, named: "errorState-iOS")
        #endif
    }

    func testErrorState_macOS() {
        #if os(macOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .error("Something went wrong")

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingView = NSHostingView(rootView: wrapForMacOS(buyMeCoffeeView))
        hostingView.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
        assertSnapshot(of: hostingView, as: .image, named: "errorState-macOS")
        #endif
    }

    // MARK: - Thank You State

    func testThankYouState_iOS() {
        #if os(iOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .thankYou

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingController = UIHostingController(rootView: wrapForIOS(buyMeCoffeeView))
        assertSnapshot(of: hostingController, as: .image, named: "thankYouState-iOS")
        #endif
    }

    func testThankYouState_macOS() {
        #if os(macOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .thankYou

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingView = NSHostingView(rootView: wrapForMacOS(buyMeCoffeeView))
        hostingView.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
        assertSnapshot(of: hostingView, as: .image, named: "thankYouState-macOS")
        #endif
    }

    // MARK: - Loaded State — 1 Product

    func testLoadedState_1Product_iOS() {
        #if os(iOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded([
            TipProduct(id: "test.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99"),
        ])

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingController = UIHostingController(rootView: wrapForIOS(buyMeCoffeeView))
        assertSnapshot(of: hostingController, as: .image, named: "loadedState-1Product-iOS")
        #endif
    }

    func testLoadedState_1Product_macOS() {
        #if os(macOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded([
            TipProduct(id: "test.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99"),
        ])

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingView = NSHostingView(rootView: wrapForMacOS(buyMeCoffeeView))
        hostingView.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
        assertSnapshot(of: hostingView, as: .image, named: "loadedState-1Product-macOS")
        #endif
    }

    // MARK: - Loaded State — 2 Products

    func testLoadedState_2Products_iOS() {
        #if os(iOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded([
            TipProduct(id: "test.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99"),
            TipProduct(id: "test.coffee.large", displayName: "Large Coffee", description: "A large cup", displayPrice: "$2.99"),
        ])

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingController = UIHostingController(rootView: wrapForIOS(buyMeCoffeeView))
        assertSnapshot(of: hostingController, as: .image, named: "loadedState-2Products-iOS")
        #endif
    }

    func testLoadedState_2Products_macOS() {
        #if os(macOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded([
            TipProduct(id: "test.coffee.small", displayName: "Small Coffee", description: "A small cup", displayPrice: "$0.99"),
            TipProduct(id: "test.coffee.large", displayName: "Large Coffee", description: "A large cup", displayPrice: "$2.99"),
        ])

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingView = NSHostingView(rootView: wrapForMacOS(buyMeCoffeeView))
        hostingView.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
        assertSnapshot(of: hostingView, as: .image, named: "loadedState-2Products-macOS")
        #endif
    }

    // MARK: - Loaded State — 5 Products

    func testLoadedState_5Products_iOS() {
        #if os(iOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded([
            TipProduct(id: "test.coffee.1", displayName: "Coffee 1", description: "A small cup", displayPrice: "$0.99"),
            TipProduct(id: "test.coffee.2", displayName: "Coffee 2", description: "A medium cup", displayPrice: "$1.99"),
            TipProduct(id: "test.coffee.3", displayName: "Coffee 3", description: "A large cup", displayPrice: "$2.99"),
            TipProduct(id: "test.coffee.4", displayName: "Coffee 4", description: "An extra large cup", displayPrice: "$4.99"),
            TipProduct(id: "test.coffee.5", displayName: "Coffee 5", description: "A mega cup", displayPrice: "$9.99"),
        ])

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingController = UIHostingController(rootView: wrapForIOS(buyMeCoffeeView))
        assertSnapshot(of: hostingController, as: .image, named: "loadedState-5Products-iOS")
        #endif
    }

    func testLoadedState_5Products_macOS() {
        #if os(macOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded([
            TipProduct(id: "test.coffee.1", displayName: "Coffee 1", description: "A small cup", displayPrice: "$0.99"),
            TipProduct(id: "test.coffee.2", displayName: "Coffee 2", description: "A medium cup", displayPrice: "$1.99"),
            TipProduct(id: "test.coffee.3", displayName: "Coffee 3", description: "A large cup", displayPrice: "$2.99"),
            TipProduct(id: "test.coffee.4", displayName: "Coffee 4", description: "An extra large cup", displayPrice: "$4.99"),
            TipProduct(id: "test.coffee.5", displayName: "Coffee 5", description: "A mega cup", displayPrice: "$9.99"),
        ])

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingView = NSHostingView(rootView: wrapForMacOS(buyMeCoffeeView))
        hostingView.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
        assertSnapshot(of: hostingView, as: .image, named: "loadedState-5Products-macOS")
        #endif
    }

    // MARK: - Loaded State — 10 Products

    func testLoadedState_10Products_iOS() {
        #if os(iOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded([
            TipProduct(id: "test.coffee.1", displayName: "Coffee 1", description: "A small cup", displayPrice: "$0.99"),
            TipProduct(id: "test.coffee.2", displayName: "Coffee 2", description: "A medium cup", displayPrice: "$1.99"),
            TipProduct(id: "test.coffee.3", displayName: "Coffee 3", description: "A large cup", displayPrice: "$2.99"),
            TipProduct(id: "test.coffee.4", displayName: "Coffee 4", description: "An extra large cup", displayPrice: "$4.99"),
            TipProduct(id: "test.coffee.5", displayName: "Coffee 5", description: "A mega cup", displayPrice: "$9.99"),
            TipProduct(id: "test.coffee.6", displayName: "Coffee 6", description: "A cup 6", displayPrice: "$0.49"),
            TipProduct(id: "test.coffee.7", displayName: "Coffee 7", description: "A cup 7", displayPrice: "$1.49"),
            TipProduct(id: "test.coffee.8", displayName: "Coffee 8", description: "A cup 8", displayPrice: "$2.49"),
            TipProduct(id: "test.coffee.9", displayName: "Coffee 9", description: "A cup 9", displayPrice: "$3.49"),
            TipProduct(id: "test.coffee.10", displayName: "Coffee 10", description: "A cup 10", displayPrice: "$4.49"),
        ])

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingController = UIHostingController(rootView: wrapForIOS(buyMeCoffeeView))
        assertSnapshot(of: hostingController, as: .image, named: "loadedState-10Products-iOS")
        #endif
    }

    func testLoadedState_10Products_macOS() {
        #if os(macOS)
        let viewModel = BuyMeCoffeeView.ViewModel(provider: provider, productIDs: productIDs)
        viewModel.state = .loaded([
            TipProduct(id: "test.coffee.1", displayName: "Coffee 1", description: "A small cup", displayPrice: "$0.99"),
            TipProduct(id: "test.coffee.2", displayName: "Coffee 2", description: "A medium cup", displayPrice: "$1.99"),
            TipProduct(id: "test.coffee.3", displayName: "Coffee 3", description: "A large cup", displayPrice: "$2.99"),
            TipProduct(id: "test.coffee.4", displayName: "Coffee 4", description: "An extra large cup", displayPrice: "$4.99"),
            TipProduct(id: "test.coffee.5", displayName: "Coffee 5", description: "A mega cup", displayPrice: "$9.99"),
            TipProduct(id: "test.coffee.6", displayName: "Coffee 6", description: "A cup 6", displayPrice: "$0.49"),
            TipProduct(id: "test.coffee.7", displayName: "Coffee 7", description: "A cup 7", displayPrice: "$1.49"),
            TipProduct(id: "test.coffee.8", displayName: "Coffee 8", description: "A cup 8", displayPrice: "$2.49"),
            TipProduct(id: "test.coffee.9", displayName: "Coffee 9", description: "A cup 9", displayPrice: "$3.49"),
            TipProduct(id: "test.coffee.10", displayName: "Coffee 10", description: "A cup 10", displayPrice: "$4.49"),
        ])

        let buyMeCoffeeView = BuyMeCoffeeView(viewModel: viewModel, provider: provider, productIDs: productIDs)
        let hostingView = NSHostingView(rootView: wrapForMacOS(buyMeCoffeeView))
        hostingView.frame = CGRect(x: 0, y: 0, width: 800, height: 600)
        assertSnapshot(of: hostingView, as: .image, named: "loadedState-10Products-macOS")
        #endif
    }
}
