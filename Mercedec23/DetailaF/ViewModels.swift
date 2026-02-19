import Foundation
import SwiftUI
import StoreKit
import Combine

class AccessoryViewModel: ObservableObject {
    private let accessoriesKey = "SavedAccessories"
    
    @Published var accessories: [Accessory] = []
    @Published var filteredAccessories: [Accessory] = []
    @Published var selectedStyle: AccessoryStyle?
    @Published var selectedCategory: AccessoryCategory?
    @Published var selectedBrand: String?
    @Published var priceRange: ClosedRange<Double> = 0...5000
    @Published var selectedColor: String?
    @Published var isLoading = false
    
    init() {
        loadAccessories()
        filteredAccessories = accessories
    }
    
    func accessory(byId id: UUID) -> Accessory? {
        accessories.first { $0.id == id }
    }
    
    func addAccessory(_ accessory: Accessory) {
        accessories.append(accessory)
        applyFilters()
        saveAccessories()
    }
    
    func removeAccessory(id: UUID) {
        ImageStorage.remove(for: id)
        accessories.removeAll { $0.id == id }
        applyFilters()
        saveAccessories()
    }
    
    private func loadAccessories() {
        guard let data = UserDefaults.standard.data(forKey: accessoriesKey),
              let decoded = try? JSONDecoder().decode([Accessory].self, from: data) else {
            accessories = []
            return
        }
        accessories = decoded
    }
    
    private func saveAccessories() {
        guard let data = try? JSONEncoder().encode(accessories) else { return }
        UserDefaults.standard.set(data, forKey: accessoriesKey)
    }
    
    func applyFilters() {
        filteredAccessories = accessories.filter { accessory in
            var matches = true
            
            if let style = selectedStyle {
                matches = matches && accessory.style == style
            }
            
            if let category = selectedCategory {
                matches = matches && accessory.category == category
            }
            
            if let brand = selectedBrand {
                matches = matches && accessory.brand == brand
            }
            
            if let color = selectedColor {
                matches = matches && accessory.colors.contains(color)
            }
            
            matches = matches && priceRange.contains(accessory.price)
            
            return matches
        }
    }
    
    func clearFilters() {
        selectedStyle = nil
        selectedCategory = nil
        selectedBrand = nil
        selectedColor = nil
        priceRange = 0...5000
        filteredAccessories = accessories
    }
    
    func refreshRecommendations() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.accessories.shuffle()
            self.applyFilters()
            self.saveAccessories()
            self.isLoading = false
        }
    }
    
    func toggleFavorite(for accessory: Accessory) {
        if let index = accessories.firstIndex(where: { $0.id == accessory.id }) {
            accessories[index].isFavorite.toggle()
            applyFilters()
            saveAccessories()
        }
    }
    
    func loadSampleData(_ newAccessories: [Accessory]) {
        accessories = newAccessories
        applyFilters()
        saveAccessories()
    }
}

class CollectionViewModel: ObservableObject {
    private let collectionsKey = "SavedCollections"
    
    @Published var collections: [Collection] = []
    @Published var favoriteAccessories: [Accessory] = []
    
    init() {
        loadCollections()
    }
    
    private func loadCollections() {
        guard let data = UserDefaults.standard.data(forKey: collectionsKey),
              let decoded = try? JSONDecoder().decode([Collection].self, from: data) else {
            collections = []
            return
        }
        collections = decoded
    }
    
    private func saveCollections() {
        guard let data = try? JSONEncoder().encode(collections) else { return }
        UserDefaults.standard.set(data, forKey: collectionsKey)
    }
    
    func addToCollection(_ accessory: Accessory, collectionName: String = "Favorites") {
        if let index = collections.firstIndex(where: { $0.name == collectionName }) {
            if !collections[index].accessories.contains(where: { $0.id == accessory.id }) {
                collections[index].accessories.append(accessory)
            }
        } else {
            let newCollection = Collection(
                name: collectionName,
                accessories: [accessory],
                createdDate: Date()
            )
            collections.append(newCollection)
        }
        saveCollections()
    }
    
    func removeFromCollection(_ accessory: Accessory, from collection: Collection) {
        if let collectionIndex = collections.firstIndex(where: { $0.id == collection.id }) {
            collections[collectionIndex].accessories.removeAll { $0.id == accessory.id }
        }
        saveCollections()
    }
    
    func createNewCollection(name: String, accessories: [Accessory] = []) {
        let newCollection = Collection(
            name: name,
            accessories: accessories,
            createdDate: Date()
        )
        collections.append(newCollection)
        saveCollections()
    }
    
    func deleteCollection(_ collection: Collection) {
        collections.removeAll { $0.id == collection.id }
        saveCollections()
    }
    
    func loadSampleData(_ newCollections: [Collection]) {
        collections = newCollections
        saveCollections()
    }
}

class ProgressViewModel: ObservableObject {
    private let sessionsKey = "SavedTryOnSessions"
    
    @Published var tryOnSessions: [TryOnSession] = []
    @Published var achievements: [Achievement] = Achievement.defaultAchievements
    @Published var stylePreferences: [AccessoryStyle: Int] = [:]
    @Published var colorPreferences: [String: Int] = [:]
    
    init() {
        loadSessions()
        calculatePreferences()
        updateAchievements()
    }
    
    func addTryOnSession(_ accessory: Accessory, rating: Int, notes: String? = nil) {
        let session = TryOnSession(
            accessoryId: accessory.id,
            styleRawValue: accessory.style.rawValue,
            colors: accessory.colors,
            date: Date(),
            rating: rating,
            notes: notes
        )
        tryOnSessions.append(session)
        calculatePreferences()
        updateAchievements()
        saveSessions()
    }
    
    private func loadSessions() {
        guard let data = UserDefaults.standard.data(forKey: sessionsKey),
              let decoded = try? JSONDecoder().decode([TryOnSession].self, from: data) else {
            tryOnSessions = []
            return
        }
        tryOnSessions = decoded
    }
    
    private func saveSessions() {
        guard let data = try? JSONEncoder().encode(tryOnSessions) else { return }
        UserDefaults.standard.set(data, forKey: sessionsKey)
    }
    
    private func calculatePreferences() {
        stylePreferences.removeAll()
        colorPreferences.removeAll()
        
        for session in tryOnSessions {
            stylePreferences[session.style, default: 0] += 1
            for color in session.colors {
                colorPreferences[color, default: 0] += 1
            }
        }
    }
    
    func loadSampleData(_ newSessions: [TryOnSession]) {
        tryOnSessions = newSessions
        calculatePreferences()
        updateAchievements()
        saveSessions()
    }
    
    private func updateAchievements() {
        for i in 0..<achievements.count {
            switch achievements[i].title {
            case "First Try-On":
                achievements[i] = Achievement(
                    id: achievements[i].id,
                    title: achievements[i].title,
                    description: achievements[i].description,
                    icon: achievements[i].icon,
                    isUnlocked: !tryOnSessions.isEmpty,
                    progress: tryOnSessions.isEmpty ? 0.0 : 1.0
                )
            case "Style Explorer":
                let uniqueStyles = Set(tryOnSessions.map { $0.style }).count
                achievements[i] = Achievement(
                    id: achievements[i].id,
                    title: achievements[i].title,
                    description: achievements[i].description,
                    icon: achievements[i].icon,
                    isUnlocked: uniqueStyles >= 5,
                    progress: min(Double(uniqueStyles) / 5.0, 1.0)
                )
            case "Collection Master":
                break
            default:
                break
            }
        }
    }
}

class ProfileViewModel: ObservableObject {
    private let profileKey = "UserProfile"
    
    @Published var profile: UserProfile = UserProfile.defaultProfile
    @Published var isEditing = false
    
    init() {
        loadProfile()
    }
    
    func updateProfile(_ newProfile: UserProfile) {
        profile = newProfile
        saveProfile()
    }
    
    func saveProfile() {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: profileKey)
        }
    }
    
    func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let savedProfile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            profile = savedProfile
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var showingRateApp = false
    
    func rateApp() {
        showingRateApp = true
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/fc729712-3c36-410a-82bc-800cbdb32b71") {
            UIApplication.shared.open(url)
        }
    }
    
    func contactSupport() {
        if let url = URL(string: "https://www.termsfeed.com/live/fc729712-3c36-410a-82bc-800cbdb32b71") {
            UIApplication.shared.open(url)
        }
    }
    
    func shareApp() {
        ShareHelper.shareApp()
    }
}
