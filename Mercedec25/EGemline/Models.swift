import Foundation
import SwiftUI
import Combine

struct Jewelry: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var brand: String
    var material: String
    var stones: String
    var price: Double
    var category: JewelryCategory
    var imageURL: String
    var style: JewelryStyle
    var color: String
    var notes: String
    
    init(
        id: UUID = UUID(),
        name: String,
        brand: String,
        material: String,
        stones: String,
        price: Double,
        category: JewelryCategory,
        imageURL: String = "",
        style: JewelryStyle,
        color: String,
        notes: String = ""
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.material = material
        self.stones = stones
        self.price = price
        self.category = category
        self.imageURL = imageURL
        self.style = style
        self.color = color
        self.notes = notes
    }
    
    static let sampleData: [Jewelry] = {
        let ids = [
            UUID(uuidString: "A1B2C3D4-E5F6-4789-A012-000000000001")!,
            UUID(uuidString: "A1B2C3D4-E5F6-4789-A012-000000000002")!,
            UUID(uuidString: "A1B2C3D4-E5F6-4789-A012-000000000003")!,
            UUID(uuidString: "A1B2C3D4-E5F6-4789-A012-000000000004")!,
            UUID(uuidString: "A1B2C3D4-E5F6-4789-A012-000000000005")!,
            UUID(uuidString: "A1B2C3D4-E5F6-4789-A012-000000000006")!,
            UUID(uuidString: "A1B2C3D4-E5F6-4789-A012-000000000007")!,
            UUID(uuidString: "A1B2C3D4-E5F6-4789-A012-000000000008")!
        ]
        return [
            Jewelry(id: ids[0], name: "Diamond Solitaire Ring", brand: "Tiffany & Co", material: "White Gold", stones: "Diamond", price: 2500, category: .rings, imageURL: "", style: .classic, color: "Silver", notes: ""),
            Jewelry(id: ids[1], name: "Pearl Drop Earrings", brand: "Mikimoto", material: "Yellow Gold", stones: "Pearl", price: 1200, category: .earrings, imageURL: "", style: .elegant, color: "Gold", notes: ""),
            Jewelry(id: ids[2], name: "Tennis Bracelet", brand: "Cartier", material: "Platinum", stones: "Diamond", price: 3500, category: .bracelets, imageURL: "", style: .classic, color: "Silver", notes: ""),
            Jewelry(id: ids[3], name: "Statement Necklace", brand: "Bulgari", material: "Rose Gold", stones: "Ruby", price: 4200, category: .necklaces, imageURL: "", style: .bold, color: "Rose Gold", notes: ""),
            Jewelry(id: ids[4], name: "Minimalist Band", brand: "Local Artisan", material: "Sterling Silver", stones: "None", price: 150, category: .rings, imageURL: "", style: .minimalist, color: "Silver", notes: ""),
            Jewelry(id: ids[5], name: "Chandelier Earrings", brand: "Van Cleef", material: "White Gold", stones: "Emerald", price: 2800, category: .earrings, imageURL: "", style: .evening, color: "Silver", notes: ""),
            Jewelry(id: ids[6], name: "Gold Hoop Earrings", brand: "David Yurman", material: "Yellow Gold", stones: "None", price: 650, category: .earrings, imageURL: "", style: .minimalist, color: "Gold", notes: ""),
            Jewelry(id: ids[7], name: "Sapphire Pendant", brand: "Harry Winston", material: "Platinum", stones: "Sapphire", price: 5200, category: .necklaces, imageURL: "", style: .elegant, color: "Silver", notes: "")
        ]
    }()
}

enum JewelryCategory: String, CaseIterable, Codable {
    case rings = "Rings"
    case earrings = "Earrings"
    case bracelets = "Bracelets"
    case necklaces = "Necklaces"
    
    var icon: String {
        switch self {
        case .rings: return "circle"
        case .earrings: return "ear"
        case .bracelets: return "link"
        case .necklaces: return "ring"
        }
    }
}

enum JewelryStyle: String, CaseIterable, Codable {
    case classic = "Classic"
    case minimalist = "Minimalist"
    case evening = "Evening"
    case bold = "Bold"
    case elegant = "Elegant"
    case vintage = "Vintage"
}

struct User: Codable {
    var name: String
    var email: String
    var favoriteStyles: [JewelryStyle]
    var favoriteMaterials: [String]
    var favoriteStones: [String]
    var favoriteBrands: [String]
    var budget: Double
    var avatarImageName: String
    var avatarPhotoFileName: String?
    
    static let defaultUser = User(
        name: "Jane Doe",
        email: "jane@example.com",
        favoriteStyles: [.classic, .elegant],
        favoriteMaterials: ["Gold", "Silver"],
        favoriteStones: ["Diamond", "Pearl"],
        favoriteBrands: ["Tiffany & Co", "Cartier"],
        budget: 2000.0,
        avatarImageName: "person.circle.fill",
        avatarPhotoFileName: nil
    )
}

struct TryOnSession: Identifiable, Codable {
    var id: UUID
    var date: Date
    var jewelryId: UUID
    var style: JewelryStyle
    var brand: String
    var category: JewelryCategory
    var notes: String
    
    init(
        id: UUID = UUID(),
        date: Date,
        jewelryId: UUID,
        style: JewelryStyle,
        brand: String,
        category: JewelryCategory,
        notes: String
    ) {
        self.id = id
        self.date = date
        self.jewelryId = jewelryId
        self.style = style
        self.brand = brand
        self.category = category
        self.notes = notes
    }
}

struct Achievement: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var icon: String
    var isUnlocked: Bool
    var progress: Double
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        icon: String,
        isUnlocked: Bool,
        progress: Double
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.icon = icon
        self.isUnlocked = isUnlocked
        self.progress = progress
    }
    
    static func defaultAchievements() -> [Achievement] {
        [
            Achievement(title: "First Steps", description: "Complete 5 virtual try-ons", icon: "star.fill", isUnlocked: false, progress: 0),
            Achievement(title: "Collection Builder", description: "Save 10 jewelry pieces", icon: "heart.fill", isUnlocked: false, progress: 0),
            Achievement(title: "Style Explorer", description: "Try 3 different styles", icon: "sparkles", isUnlocked: false, progress: 0),
            Achievement(title: "Brand Enthusiast", description: "Explore 5 different brands", icon: "crown.fill", isUnlocked: false, progress: 0)
        ]
    }
}

private enum StorageKeys {
    static let allJewelry = "allJewelry"
    static let savedJewelryIds = "savedJewelryIds"
    static let tryOnSessions = "tryOnSessions"
    static let achievements = "achievements"
    static let currentUser = "currentUser"
    static let hasCompletedOnboarding = "hasCompletedOnboarding"
    static let pushNotifications = "pushNotifications"
    static let emailNotifications = "emailNotifications"
    static let styleTipsNotifications = "styleTipsNotifications"
}

class AppState: ObservableObject {
    @Published var isLoading = true
    @Published var currentUser: User
    @Published var allJewelry: [Jewelry]
    @Published var savedJewelryIds: [UUID]
    @Published var tryOnSessions: [TryOnSession]
    @Published var achievements: [Achievement]
    @Published var selectedTab = 0
    @Published var hasCompletedOnboarding: Bool
    @Published var pushNotificationsEnabled: Bool
    @Published var emailNotificationsEnabled: Bool
    @Published var styleTipsEnabled: Bool
    
    var savedJewelry: [Jewelry] {
        allJewelry.filter { savedJewelryIds.contains($0.id) }
    }
    
    private let defaults = UserDefaults.standard
    
    init() {
        self.currentUser = User.defaultUser
        self.allJewelry = []
        self.savedJewelryIds = []
        self.tryOnSessions = []
        self.achievements = Achievement.defaultAchievements()
        self.hasCompletedOnboarding = false
        self.pushNotificationsEnabled = true
        self.emailNotificationsEnabled = false
        self.styleTipsEnabled = true
        
        loadFromUserDefaults()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        defaults.set(true, forKey: StorageKeys.hasCompletedOnboarding)
    }
    
    func loadSampleData() {
        let sample = Jewelry.sampleData
        
        for item in sample {
            if !allJewelry.contains(where: { $0.id == item.id }) {
                allJewelry.append(item)
            }
        }
        
        for id in sample.prefix(3).map(\.id) {
            if !savedJewelryIds.contains(id) {
                savedJewelryIds.append(id)
            }
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        if tryOnSessions.isEmpty, sample.count >= 3 {
            let sessions: [TryOnSession] = [
                TryOnSession(date: calendar.date(byAdding: .day, value: -1, to: now) ?? now, jewelryId: sample[0].id, style: sample[0].style, brand: sample[0].brand, category: sample[0].category, notes: "Perfect for daily wear"),
                TryOnSession(date: calendar.date(byAdding: .day, value: -2, to: now) ?? now, jewelryId: sample[1].id, style: sample[1].style, brand: sample[1].brand, category: sample[1].category, notes: "Great for special occasions"),
                TryOnSession(date: calendar.date(byAdding: .day, value: -3, to: now) ?? now, jewelryId: sample[2].id, style: sample[2].style, brand: sample[2].brand, category: sample[2].category, notes: "Simple and elegant")
            ]
            tryOnSessions.insert(contentsOf: sessions, at: 0)
        }
        
        updateAchievementsProgress()
        saveToUserDefaults()
    }
    
    func finishLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isLoading = false
            }
        }
    }
    
    func getJewelry(by id: UUID) -> Jewelry? {
        allJewelry.first { $0.id == id }
    }
    
    func addJewelry(_ jewelry: Jewelry) {
        if !allJewelry.contains(where: { $0.id == jewelry.id }) {
            allJewelry.append(jewelry)
            saveToUserDefaults()
        }
    }
    
    func updateJewelry(_ jewelry: Jewelry) {
        if let index = allJewelry.firstIndex(where: { $0.id == jewelry.id }) {
            allJewelry[index] = jewelry
            saveToUserDefaults()
        }
    }
    
    func deleteJewelry(id: UUID) {
        allJewelry.removeAll { $0.id == id }
        savedJewelryIds.removeAll { $0 == id }
        saveToUserDefaults()
    }
    
    func addToCollection(_ jewelry: Jewelry) {
        addToCollection(id: jewelry.id)
    }
    
    func addToCollection(id: UUID) {
        if !savedJewelryIds.contains(id) {
            savedJewelryIds.append(id)
            updateAchievementsProgress()
            saveToUserDefaults()
        }
    }
    
    func removeFromCollection(_ jewelry: Jewelry) {
        removeFromCollection(id: jewelry.id)
    }
    
    func removeFromCollection(id: UUID) {
        savedJewelryIds.removeAll { $0 == id }
        updateAchievementsProgress()
        saveToUserDefaults()
    }
    
    func isInCollection(_ jewelry: Jewelry) -> Bool {
        isInCollection(id: jewelry.id)
    }
    
    func isInCollection(id: UUID) -> Bool {
        savedJewelryIds.contains(id)
    }
    
    func addTryOnSession(_ session: TryOnSession) {
        tryOnSessions.insert(session, at: 0)
        updateAchievementsProgress()
        saveToUserDefaults()
    }
    
    private func updateAchievementsProgress() {
        let tryOnCount = tryOnSessions.count
        let stylesCount = Set(tryOnSessions.map { $0.style }).count
        let brandsCount = Set(tryOnSessions.map { $0.brand }).count
        
        for i in achievements.indices {
            switch achievements[i].title {
            case "First Steps":
                achievements[i].progress = min(1.0, Double(tryOnCount) / 5.0)
                achievements[i].isUnlocked = tryOnCount >= 5
            case "Collection Builder":
                achievements[i].progress = min(1.0, Double(savedJewelry.count) / 10.0)
                achievements[i].isUnlocked = savedJewelry.count >= 10
            case "Style Explorer":
                achievements[i].progress = min(1.0, Double(stylesCount) / 3.0)
                achievements[i].isUnlocked = stylesCount >= 3
            case "Brand Enthusiast":
                achievements[i].progress = min(1.0, Double(brandsCount) / 5.0)
                achievements[i].isUnlocked = brandsCount >= 5
            default:
                break
            }
        }
    }
    
    func saveUser() {
        saveToUserDefaults()
    }
    
    private func loadFromUserDefaults() {
        if let data = defaults.data(forKey: StorageKeys.allJewelry),
           let decoded = try? JSONDecoder().decode([Jewelry].self, from: data) {
            allJewelry = decoded
        }
        
        if let data = defaults.data(forKey: StorageKeys.savedJewelryIds),
           let decoded = try? JSONDecoder().decode([UUID].self, from: data) {
            savedJewelryIds = decoded
        }
        
        if let data = defaults.data(forKey: StorageKeys.tryOnSessions),
           let decoded = try? JSONDecoder().decode([TryOnSession].self, from: data) {
            tryOnSessions = decoded
        }
        
        if let data = defaults.data(forKey: StorageKeys.achievements),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        } else {
            achievements = Achievement.defaultAchievements()
        }
        
        if let data = defaults.data(forKey: StorageKeys.currentUser),
           let decoded = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = decoded
        }
        
        hasCompletedOnboarding = defaults.bool(forKey: StorageKeys.hasCompletedOnboarding)
        pushNotificationsEnabled = defaults.object(forKey: StorageKeys.pushNotifications) as? Bool ?? true
        emailNotificationsEnabled = defaults.object(forKey: StorageKeys.emailNotifications) as? Bool ?? false
        styleTipsEnabled = defaults.object(forKey: StorageKeys.styleTipsNotifications) as? Bool ?? true
    }
    
    func saveNotificationSettings() {
        defaults.set(pushNotificationsEnabled, forKey: StorageKeys.pushNotifications)
        defaults.set(emailNotificationsEnabled, forKey: StorageKeys.emailNotifications)
        defaults.set(styleTipsEnabled, forKey: StorageKeys.styleTipsNotifications)
    }
    
    private func saveToUserDefaults() {
        if let data = try? JSONEncoder().encode(allJewelry) {
            defaults.set(data, forKey: StorageKeys.allJewelry)
        }
        if let data = try? JSONEncoder().encode(savedJewelryIds) {
            defaults.set(data, forKey: StorageKeys.savedJewelryIds)
        }
        if let data = try? JSONEncoder().encode(tryOnSessions) {
            defaults.set(data, forKey: StorageKeys.tryOnSessions)
        }
        if let data = try? JSONEncoder().encode(achievements) {
            defaults.set(data, forKey: StorageKeys.achievements)
        }
        if let data = try? JSONEncoder().encode(currentUser) {
            defaults.set(data, forKey: StorageKeys.currentUser)
        }
        defaults.set(pushNotificationsEnabled, forKey: StorageKeys.pushNotifications)
        defaults.set(emailNotificationsEnabled, forKey: StorageKeys.emailNotifications)
        defaults.set(styleTipsEnabled, forKey: StorageKeys.styleTipsNotifications)
    }
}
