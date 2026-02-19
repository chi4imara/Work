import SwiftUI
import Foundation
import Combine

struct WardrobeItem: Identifiable, Codable {
    var id: UUID
    var name: String
    var category: ClothingCategory
    var size: String
    var color: String
    var notes: String
    var imageName: String?
    var isFavorite: Bool = false
    var dateAdded: Date = Date()
    
    init(id: UUID = UUID(), name: String, category: ClothingCategory, size: String, color: String, notes: String, imageName: String? = nil, isFavorite: Bool = false, dateAdded: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.size = size
        self.color = color
        self.notes = notes
        self.imageName = imageName
        self.isFavorite = isFavorite
        self.dateAdded = dateAdded
    }
    
    enum ClothingCategory: String, CaseIterable, Codable {
        case outerwear = "Outerwear"
        case dress = "Dress"
        case shoes = "Shoes"
        case accessories = "Accessories"
        case tops = "Tops"
        case bottoms = "Bottoms"
        
        var icon: String {
            switch self {
            case .outerwear: return "coat"
            case .dress: return "tshirt"
            case .shoes: return "shoe"
            case .accessories: return "bag"
            case .tops: return "tshirt.fill"
            case .bottoms: return "duffle.bag.fill"
            }
        }
    }
}

struct Outfit: Identifiable, Codable {
    var id: UUID
    var name: String
    var items: [WardrobeItem]
    var notes: String
    var dateCreated: Date = Date()
    var lastWorn: Date?
    var isFavorite: Bool = false
    
    init(id: UUID = UUID(), name: String, items: [WardrobeItem], notes: String, dateCreated: Date = Date(), lastWorn: Date? = nil, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.items = items
        self.notes = notes
        self.dateCreated = dateCreated
        self.lastWorn = lastWorn
        self.isFavorite = isFavorite
    }
    
    var itemsByCategory: [WardrobeItem.ClothingCategory: [WardrobeItem]] {
        Dictionary(grouping: items, by: { $0.category })
    }
}

struct DailyChallenge: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var isCompleted: Bool = false
    var date: Date = Date()
    var type: ChallengeType
    
    init(id: UUID = UUID(), title: String, description: String, isCompleted: Bool = false, date: Date = Date(), type: ChallengeType) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.date = date
        self.type = type
    }
    
    enum ChallengeType: String, CaseIterable, Codable {
        case createOutfits = "Create Outfits"
        case tryNewColors = "Try New Colors"
        case mixAndMatch = "Mix and Match"
        case accessorize = "Accessorize"
        case seasonal = "Seasonal Style"
        
        var icon: String {
            switch self {
            case .createOutfits: return "plus.circle"
            case .tryNewColors: return "paintpalette"
            case .mixAndMatch: return "shuffle"
            case .accessorize: return "bag.circle"
            case .seasonal: return "leaf.circle"
            }
        }
    }
}

struct DailyProgress: Identifiable, Codable {
    var id: UUID
    var date: Date = Date()
    var wardrobeItemsAdded: Int = 0
    var outfitsCreated: Int = 0
    var challengesCompleted: Int = 0
    var outfitWorn: Outfit?
    
    init(id: UUID = UUID(), date: Date = Date(), wardrobeItemsAdded: Int = 0, outfitsCreated: Int = 0, challengesCompleted: Int = 0, outfitWorn: Outfit? = nil) {
        self.id = id
        self.date = date
        self.wardrobeItemsAdded = wardrobeItemsAdded
        self.outfitsCreated = outfitsCreated
        self.challengesCompleted = challengesCompleted
        self.outfitWorn = outfitWorn
    }
    
    var totalProgress: Double {
        let maxPoints = 3.0
        var points = 0.0
        
        if wardrobeItemsAdded > 0 { points += 1.0 }
        if outfitsCreated > 0 { points += 1.0 }
        if challengesCompleted > 0 { points += 1.0 }
        
        return points / maxPoints
    }
    
    var progressDescription: String {
        let percentage = Int(totalProgress * 100)
        return "\(percentage)% Complete"
    }
}

private enum StorageKey {
    static let wardrobeItems = "styleBloom.wardrobeItems"
    static let outfits = "styleBloom.outfits"
    static let dailyChallenges = "styleBloom.dailyChallenges"
    static let dailyProgress = "styleBloom.dailyProgress"
    static let hasCompletedOnboarding = "styleBloom.hasCompletedOnboarding"
    static let isFirstLaunch = "styleBloom.isFirstLaunch"
    static let currentUser = "styleBloom.currentUser"
}

class AppState: ObservableObject {
    private static let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()
    
    private static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    @Published var isFirstLaunch: Bool = true
    @Published var hasCompletedOnboarding: Bool = false
    @Published var currentUser: String = "Style Enthusiast"
    @Published var wardrobeItems: [WardrobeItem] = []
    @Published var outfits: [Outfit] = []
    @Published var dailyChallenges: [DailyChallenge] = []
    @Published var dailyProgress: [DailyProgress] = []
    @Published var selectedTab: TabItem = .today
    
    init() {
        loadFromUserDefaults()
        generateTodaysChallenge()
    }
    
    func wardrobeItem(byId id: UUID) -> WardrobeItem? {
        wardrobeItems.first { $0.id == id }
    }
    
    func outfit(byId id: UUID) -> Outfit? {
        outfits.first { $0.id == id }
    }
        
    func saveToUserDefaults() {
        let ud = UserDefaults.standard
        ud.set(hasCompletedOnboarding, forKey: StorageKey.hasCompletedOnboarding)
        ud.set(isFirstLaunch, forKey: StorageKey.isFirstLaunch)
        ud.set(currentUser, forKey: StorageKey.currentUser)
        
        if let data = try? Self.encoder.encode(wardrobeItems) {
            ud.set(data, forKey: StorageKey.wardrobeItems)
        }
        if let data = try? Self.encoder.encode(outfits) {
            ud.set(data, forKey: StorageKey.outfits)
        }
        if let data = try? Self.encoder.encode(dailyChallenges) {
            ud.set(data, forKey: StorageKey.dailyChallenges)
        }
        if let data = try? Self.encoder.encode(dailyProgress) {
            ud.set(data, forKey: StorageKey.dailyProgress)
        }
    }
    
    private func loadFromUserDefaults() {
        let ud = UserDefaults.standard
        
        if ud.object(forKey: StorageKey.wardrobeItems) != nil {
            hasCompletedOnboarding = ud.bool(forKey: StorageKey.hasCompletedOnboarding)
            isFirstLaunch = ud.bool(forKey: StorageKey.isFirstLaunch)
            if let name = ud.string(forKey: StorageKey.currentUser) {
                currentUser = name
            }
            
            if let data = ud.data(forKey: StorageKey.wardrobeItems),
               let decoded = try? Self.decoder.decode([WardrobeItem].self, from: data) {
                wardrobeItems = decoded
            }
            if let data = ud.data(forKey: StorageKey.outfits),
               let decoded = try? Self.decoder.decode([Outfit].self, from: data) {
                outfits = decoded
            }
            if let data = ud.data(forKey: StorageKey.dailyChallenges),
               let decoded = try? Self.decoder.decode([DailyChallenge].self, from: data) {
                dailyChallenges = decoded
            }
            if let data = ud.data(forKey: StorageKey.dailyProgress),
               let decoded = try? Self.decoder.decode([DailyProgress].self, from: data) {
                dailyProgress = decoded
            }
        } else {
        }
    }
    
    private func loadSampleData() {
        wardrobeItems = [
            WardrobeItem(name: "Blue Denim Jacket", category: .outerwear, size: "M", color: "Blue", notes: "Casual wear"),
            WardrobeItem(name: "Black Dress", category: .dress, size: "S", color: "Black", notes: "Evening wear"),
            WardrobeItem(name: "White Sneakers", category: .shoes, size: "7", color: "White", notes: "Comfortable"),
            WardrobeItem(name: "Gold Necklace", category: .accessories, size: "One Size", color: "Gold", notes: "Elegant")
        ]
        
        if wardrobeItems.count >= 2 {
            outfits = [
                Outfit(name: "Casual Day Out", items: Array(wardrobeItems.prefix(2)), notes: "Perfect for weekend"),
                Outfit(name: "Evening Look", items: [wardrobeItems[1], wardrobeItems[3]], notes: "Elegant and chic")
            ]
        }
        
        let today = Calendar.current.startOfDay(for: Date())
        if !dailyProgress.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyProgress.append(DailyProgress(date: today))
        }
        saveToUserDefaults()
    }
    
    func loadSampleDataForTesting() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        
        wardrobeItems = [
            WardrobeItem(name: "Blue Denim Jacket", category: .outerwear, size: "M", color: "Blue", notes: "Casual wear"),
            WardrobeItem(name: "Black Dress", category: .dress, size: "S", color: "Black", notes: "Evening wear"),
            WardrobeItem(name: "White Sneakers", category: .shoes, size: "7", color: "White", notes: "Comfortable"),
            WardrobeItem(name: "Gold Necklace", category: .accessories, size: "One Size", color: "Gold", notes: "Elegant"),
            WardrobeItem(name: "Gray Blazer", category: .outerwear, size: "L", color: "Gray", notes: "Office"),
            WardrobeItem(name: "Floral Skirt", category: .bottoms, size: "M", color: "Multicolor", notes: "Summer"),
            WardrobeItem(name: "Leather Boots", category: .shoes, size: "38", color: "Brown", notes: "Winter"),
            WardrobeItem(name: "Silk Scarf", category: .accessories, size: "One Size", color: "Red", notes: ""),
            WardrobeItem(name: "Striped T-Shirt", category: .tops, size: "S", color: "Navy", notes: "Basic"),
            WardrobeItem(name: "High Heels", category: .shoes, size: "37", color: "Black", notes: "Evening")
        ]
        
        outfits = [
            Outfit(name: "Casual Day Out", items: [wardrobeItems[0], wardrobeItems[2], wardrobeItems[8]], notes: "Perfect for weekend"),
            Outfit(name: "Evening Look", items: [wardrobeItems[1], wardrobeItems[3], wardrobeItems[9]], notes: "Elegant and chic"),
            Outfit(name: "Office Style", items: [wardrobeItems[4], wardrobeItems[8], wardrobeItems[2]], notes: "Business casual"),
            Outfit(name: "Summer Day", items: [wardrobeItems[5], wardrobeItems[8], wardrobeItems[2]], notes: "Light and fresh"),
            Outfit(name: "Winter Walk", items: [wardrobeItems[0], wardrobeItems[6], wardrobeItems[7]], notes: "Warm and cozy")
        ]
        
        dailyChallenges = [
            DailyChallenge(title: "Create 3 New Outfits", description: "Mix and match your wardrobe items to create 3 unique looks", isCompleted: false, date: today, type: .createOutfits),
            DailyChallenge(title: "Try Unusual Color Combinations", description: "Experiment with colors you don't usually wear together", isCompleted: true, date: cal.date(byAdding: .day, value: -1, to: today)!, type: .tryNewColors)
        ]
        
        dailyProgress = [
            DailyProgress(date: today, wardrobeItemsAdded: 1, outfitsCreated: 1, challengesCompleted: 0),
            DailyProgress(date: cal.date(byAdding: .day, value: -1, to: today)!, wardrobeItemsAdded: 0, outfitsCreated: 2, challengesCompleted: 1),
            DailyProgress(date: cal.date(byAdding: .day, value: -2, to: today)!, wardrobeItemsAdded: 2, outfitsCreated: 0, challengesCompleted: 0)
        ]
        
        generateTodaysChallenge()
        saveToUserDefaults()
    }
    
    private func generateTodaysChallenge() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if !dailyChallenges.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            let challenges = [
                DailyChallenge(title: "Create 3 New Outfits", description: "Mix and match your wardrobe items to create 3 unique looks", type: .createOutfits),
                DailyChallenge(title: "Try Unusual Color Combinations", description: "Experiment with colors you don't usually wear together", type: .tryNewColors),
                DailyChallenge(title: "Accessorize Your Look", description: "Add at least 2 accessories to today's outfit", type: .accessorize)
            ]
            
            dailyChallenges.append(challenges.randomElement()!)
        }
        saveToUserDefaults()
    }
    
    func addWardrobeItem(_ item: WardrobeItem) {
        wardrobeItems.append(item)
        updateTodaysProgress { $0.wardrobeItemsAdded += 1 }
        saveToUserDefaults()
    }
    
    func addOutfit(_ outfit: Outfit) {
        outfits.append(outfit)
        updateTodaysProgress { $0.outfitsCreated += 1 }
        saveToUserDefaults()
    }
    
    func completeChallenge(_ challengeId: UUID) {
        if let index = dailyChallenges.firstIndex(where: { $0.id == challengeId }) {
            dailyChallenges[index].isCompleted = true
            updateTodaysProgress { $0.challengesCompleted += 1 }
            saveToUserDefaults()
        }
    }
    
    func markOutfitAsWorn(_ outfit: Outfit) {
        if let index = outfits.firstIndex(where: { $0.id == outfit.id }) {
            outfits[index].lastWorn = Date()
        }
        updateTodaysProgress { $0.outfitWorn = outfit }
        saveToUserDefaults()
    }
    
    func persistOnboardingState() {
        saveToUserDefaults()
    }
    
    private func updateTodaysProgress(_ update: (inout DailyProgress) -> Void) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let index = dailyProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            update(&dailyProgress[index])
        } else {
            var newProgress = DailyProgress(date: today)
            update(&newProgress)
            dailyProgress.append(newProgress)
        }
    }
    
    var todaysProgress: DailyProgress? {
        let today = Calendar.current.startOfDay(for: Date())
        return dailyProgress.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    var todaysChallenge: DailyChallenge? {
        let today = Calendar.current.startOfDay(for: Date())
        return dailyChallenges.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    func greetingForTimeOfDay() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<22:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
}

enum TabItem: String, CaseIterable {
    case today = "Today"
    case wardrobe = "Wardrobe"
    case outfits = "Outfits"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .today: return "house"
        case .wardrobe: return "tshirt"
        case .outfits: return "person"
        case .statistics: return "chart.bar"
        case .settings: return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .today: return "house.fill"
        case .wardrobe: return "tshirt.fill"
        case .outfits: return "person.fill"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}
