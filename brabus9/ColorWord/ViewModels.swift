import Foundation
import SwiftUI
import StoreKit
import Combine

class CatalogViewModel: ObservableObject {
    @Published var items: [CatalogItem] = []
    @Published var isFirstLaunch: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "catalog_items"
    private let firstLaunchKey = "is_first_launch"
    
    init() {
        loadItems()
        checkFirstLaunch()
    }
    
    func addItem(_ text: String) {
        let newItem = CatalogItem(text: text)
        items.append(newItem)
        saveItems()
    }
    
    func updateItem(_ item: CatalogItem, with newText: String) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].updateText(newText)
            saveItems()
        }
    }
    
    func deleteItem(_ item: CatalogItem) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }
    
    func getRandomItem() -> CatalogItem? {
        return items.randomElement()
    }
    
    private func loadItems() {
        if let data = userDefaults.data(forKey: itemsKey),
           let decodedItems = try? JSONDecoder().decode([CatalogItem].self, from: data) {
            items = decodedItems
        }
    }
    
    private func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            userDefaults.set(encodedData, forKey: itemsKey)
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    func completeOnboarding() {
        isFirstLaunch = false
        userDefaults.set(true, forKey: firstLaunchKey)
    }
}

class AppViewModel: ObservableObject {
    @Published var selectedTab: TabItem = .catalog
    @Published var showSplash: Bool = true
    
    func hideSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showSplash = false
            }
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var settingsItems: [SettingsItem] = [
        SettingsItem(title: "Privacy Policy", action: .privacyPolicy),
        SettingsItem(title: "Contact Email", action: .contactEmail),
        SettingsItem(title: "Rate App", action: .rateApp)
    ]
    
    func handleSettingsAction(_ action: SettingsAction) {
        switch action {
        case .privacyPolicy:
            openURL("https://doc-hosting.flycricket.io/whatyoulike-sensory-keep-privacy-policy/5450d0cc-5b27-4e61-b5f4-f80cbe050b21/privacy")
        case .contactEmail:
            openURL("https://forms.gle/uk8Ad6HS3zozd94Q8")
        case .rateApp:
            requestReview()
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
