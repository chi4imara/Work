import Foundation
import SwiftUI
import StoreKit
import Combine

class JewelryStore: ObservableObject {
    @Published var jewelries: [Jewelry] = []
    @Published var searchText: String = ""
    @Published var favoriteIds: Set<UUID> = []
    
    private let userDefaults = UserDefaults.standard
    private let jewelriesKey = "SavedJewelries"
    private let favoritesKey = "FavoriteJewelries"
    
    init() {
        loadJewelries()
        loadFavorites()
    }
    
    var filteredJewelries: [Jewelry] {
        if searchText.isEmpty {
            return jewelries
        } else {
            return jewelries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var favoriteJewelries: [Jewelry] {
        jewelries.filter { favoriteIds.contains($0.id) }
    }
    
    func isFavorite(_ jewelry: Jewelry) -> Bool {
        favoriteIds.contains(jewelry.id)
    }
    
    func toggleFavorite(_ jewelry: Jewelry) {
        if favoriteIds.contains(jewelry.id) {
            favoriteIds.remove(jewelry.id)
        } else {
            favoriteIds.insert(jewelry.id)
        }
        saveFavorites()
    }
    
    func addJewelry(_ jewelry: Jewelry) {
        jewelries.append(jewelry)
        saveJewelries()
    }
    
    func updateJewelry(_ jewelry: Jewelry) {
        if let index = jewelries.firstIndex(where: { $0.id == jewelry.id }) {
            jewelries[index] = jewelry
            saveJewelries()
        }
    }
    
    func deleteJewelry(_ jewelry: Jewelry) {
        if let imageName = jewelry.imageName {
            ImageManager.shared.deleteImage(named: imageName)
        }
        favoriteIds.remove(jewelry.id)
        jewelries.removeAll { $0.id == jewelry.id }
        saveJewelries()
        saveFavorites()
    }
    
    func getJewelry(by id: UUID) -> Jewelry? {
        return jewelries.first { $0.id == id }
    }
    
    private func saveJewelries() {
        if let encoded = try? JSONEncoder().encode(jewelries) {
            userDefaults.set(encoded, forKey: jewelriesKey)
        }
    }
    
    private func loadJewelries() {
        if let data = userDefaults.data(forKey: jewelriesKey),
           let decoded = try? JSONDecoder().decode([Jewelry].self, from: data) {
            jewelries = decoded
        }
    }
    
    private func saveFavorites() {
        let favoriteArray = Array(favoriteIds)
        if let encoded = try? JSONEncoder().encode(favoriteArray) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([UUID].self, from: data) {
            favoriteIds = Set(decoded)
        }
    }
}

class SetsStore: ObservableObject {
    @Published var sets: [JewelrySet] = []
    
    private let userDefaults = UserDefaults.standard
    private let setsKey = "SavedSets"
    
    init() {
        loadSets()
    }
    
    func addSet(_ set: JewelrySet) {
        sets.append(set)
        saveSets()
    }
    
    func updateSet(_ set: JewelrySet) {
        if let index = sets.firstIndex(where: { $0.id == set.id }) {
            sets[index] = set
            saveSets()
        }
    }
    
    func deleteSet(_ set: JewelrySet) {
        sets.removeAll { $0.id == set.id }
        saveSets()
    }
    
    func getJewelriesInSet(_ set: JewelrySet, from jewelryStore: JewelryStore) -> [Jewelry] {
        return set.jewelryIds.compactMap { jewelryStore.getJewelry(by: $0) }
    }
    
    private func saveSets() {
        if let encoded = try? JSONEncoder().encode(sets) {
            userDefaults.set(encoded, forKey: setsKey)
        }
    }
    
    private func loadSets() {
        if let data = userDefaults.data(forKey: setsKey),
           let decoded = try? JSONDecoder().decode([JewelrySet].self, from: data) {
            sets = decoded
        }
    }
}

class SettingsStore: ObservableObject {
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://doc-hosting.flycricket.io/orbits-adornment-privacy-policy/37dcffa6-9269-4590-898c-7b21422b32b8/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    func openContactEmail() {
        if let url = URL(string: "https://forms.gle/WQpzEmDgYZTkaeiw6") {
            UIApplication.shared.open(url)
        }
    }
}
