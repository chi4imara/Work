import Foundation
import SwiftUI
import StoreKit
import Combine

class ShoppingViewModel: ObservableObject {
    @Published var items: [ShoppingItem] = [] {
        didSet {
            updateCategories()
        }
    }
    @Published var categories: [Category] = []
    @Published var appState: AppState = .splash
    @Published var selectedTab: TabSelection = .add
    @Published var showingOnboarding = false
    
    var hasItems: Bool {
        !items.isEmpty
    }
    
    init() {
        loadItems()
        checkOnboardingStatus()
        updateCategories()
    }
    
    private func updateCategories() {
        let groupedItems = Dictionary(grouping: items) { $0.category }
        categories = groupedItems.map { Category(name: $0.key, items: $0.value) }
            .sorted { $0.name < $1.name }
    }
    
    func addItem(_ item: ShoppingItem) {
        items.append(item)
        saveItems()
    }
    
    func updateItem(_ item: ShoppingItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveItems()
        }
    }
    
    func deleteItem(_ item: ShoppingItem) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }
    
    func getItemsForCategory(_ categoryName: String) -> [ShoppingItem] {
        return items.filter { $0.category == categoryName }
    }
    
    func completeOnboarding() {
        showingOnboarding = true
        UserDefaults.standard.set(true, forKey: "showOnboarding")
    }
    
    func completeSplash() {
        if showingOnboarding {
            appState = .onboarding
        } else {
            appState = .main
        }
    }
    
    private func checkOnboardingStatus() {
        showingOnboarding = UserDefaults.standard.bool(forKey: "showOnboarding")
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://www.privacypolicies.com/live/dec42c8a-4881-4254-9906-ac1fb643b8b4") {
            UIApplication.shared.open(url)
        }
    }
    
    func openContactEmail() {
        if let url = URL(string: "https://www.privacypolicies.com/live/dec42c8a-4881-4254-9906-ac1fb643b8b4") {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "shoppingItems")
        }
    }
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: "shoppingItems"),
           let decoded = try? JSONDecoder().decode([ShoppingItem].self, from: data) {
            items = decoded
        }
    }
}
