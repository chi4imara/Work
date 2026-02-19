import Foundation
import SwiftUI
import Combine
import StoreKit

class GarageViewModel: ObservableObject {
    @Published var items: [GarageItem] = []
    @Published var selectedFilter: FilterType = .all
    @Published var searchText: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let itemsKey = "GarageItems"
    
    init() {
        loadItems()
    }
    
    var filteredItems: [GarageItem] {
        var filtered = items
        
        if let category = selectedFilter.category {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.location.localizedCaseInsensitiveContains(searchText) ||
                item.comment.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.dateModified > $1.dateModified }
    }
    
    var locations: [Location] {
        let locationNames = Set(items.map { $0.location })
        return locationNames.map { locationName in
            let count = items.filter { $0.location == locationName }.count
            return Location(name: locationName, itemCount: count)
        }.sorted { $0.name < $1.name }
    }
    
    func addItem(_ item: GarageItem) {
        items.append(item)
        saveItems()
    }
    
    func updateItem(_ item: GarageItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = item
            updatedItem.updateModifiedDate()
            items[index] = updatedItem
            saveItems()
        }
    }
    
    func deleteItem(_ item: GarageItem) {
        items.removeAll { $0.id == item.id }
        saveItems()
    }
    
    func getItemsForLocation(_ locationName: String) -> [GarageItem] {
        return items.filter { $0.location == locationName }
            .sorted { $0.dateModified > $1.dateModified }
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            userDefaults.set(encoded, forKey: itemsKey)
        }
    }
    
    private func loadItems() {
        if let data = userDefaults.data(forKey: itemsKey),
           let decoded = try? JSONDecoder().decode([GarageItem].self, from: data) {
            items = decoded
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var showingPrivacyPolicy = false
    @Published var showingContactEmail = false
    @Published var showingRateApp = false
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func openContactEmail() {
        if let url = URL(string: "mailto:contact@example.com") {
            UIApplication.shared.open(url)
        }
    }
    
    func requestAppReview() {
        #if canImport(StoreKit)
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                if #available(iOS 14.0, *) {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
        }
        #endif
    }
}

class AppStateManager: ObservableObject {
    @Published var isFirstLaunch: Bool = true
    @Published var showingSplashScreen: Bool = true
    @Published var selectedTab: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        checkFirstLaunch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showingSplashScreen = false
            }
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: firstLaunchKey)
        isFirstLaunch = false
    }
}
