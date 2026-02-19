import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var appState: AppState = .splash
    @Published var hasSeenOnboarding: Bool = false
    
    init() {
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if self.hasSeenOnboarding {
                self.appState = .main
            } else {
                self.appState = .onboarding
            }
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        hasSeenOnboarding = true
        appState = .main
    }
}

class GadgetViewModel: ObservableObject {
    @Published var gadgets: [Gadget] = []
    @Published var currentGadget = Gadget()
    @Published var navigationPath = NavigationPath()
    
    private let userDefaultsKey = "SavedGadgets"
    
    init() {
        loadGadgets()
    }
    
    func addGadget(_ gadget: Gadget) {
        gadgets.append(gadget)
        saveGadgets()
    }
    
    func updateGadget(_ gadget: Gadget) {
        if let index = gadgets.firstIndex(where: { $0.id == gadget.id }) {
            gadgets[index] = gadget
            saveGadgets()
        }
    }
    
    func deleteGadget(_ gadget: Gadget) {
        gadgets.removeAll { $0.id == gadget.id }
        saveGadgets()
    }
    
    func resetCurrentGadget() {
        currentGadget = Gadget()
    }
    
    func getCategories() -> [Category] {
        let groupedGadgets = Dictionary(grouping: gadgets) { $0.category }
        return groupedGadgets.map { Category(name: $0.key, gadgets: $0.value) }
            .sorted { $0.name < $1.name }
    }
    
    func getGadgets(for category: String) -> [Gadget] {
        return gadgets.filter { $0.category == category }
    }
    
    func navigateTo(_ destination: NavigationDestination) {
        switch destination {
        case .gadgetSaved(let gadget):
            navigationPath.append(destination)
        case .gadgetDetails(let gadget):
            navigationPath.append(destination)
        case .editGadget(let gadget):
            currentGadget = gadget
            navigationPath.append(destination)
        case .categoryGadgets(_, _):
            navigationPath.append(destination)
        }
    }
    
    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
    
    private func saveGadgets() {
        if let encoded = try? JSONEncoder().encode(gadgets) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadGadgets() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Gadget].self, from: data) {
            gadgets = decoded
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var showingRateAlert = false
    
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://www.freeprivacypolicy.com/live/cbf2d341-4c74-441d-a9f0-58e5355010ed") {
            UIApplication.shared.open(url)
        }
    }
    
    func openContactEmail() {
        if let url = URL(string: "https://forms.gle/nQAH2RWnquiseZHH7") {
            UIApplication.shared.open(url)
        }
    }
}

class TabViewModel: ObservableObject {
    @Published var selectedTab: TabItem = .add
    
    func selectTab(_ tab: TabItem) {
        selectedTab = tab
    }
}
