import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User
    @Published var tryOnSessions: [TryOnSession] = []
    @Published var achievements: [Achievement] = []
    @Published var statistics = UserStatistics()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.user = UserDefaultsStorage.shared.loadUser() ?? User()
        self.tryOnSessions = UserDefaultsStorage.shared.loadTryOnSessions()
        self.achievements = UserDefaultsStorage.shared.loadAchievements() ?? Achievement.defaultAchievements
        setupStatisticsUpdates()
        updateStatistics(tryOnSessions)
    }
    
    private func setupStatisticsUpdates() {
        $tryOnSessions
            .sink { [weak self] sessions in
                self?.updateStatistics(sessions)
                self?.checkAchievements()
            }
            .store(in: &cancellables)
    }
    
    private func updateStatistics(_ sessions: [TryOnSession]) {
        var newStats = UserStatistics()
        newStats.updateFromSessions(sessions)
        statistics = newStats
    }
    
    private func checkAchievements() {
        var updated = achievements
        
        if let i = updated.firstIndex(where: { $0.title == "First Try-On" }), !tryOnSessions.isEmpty && !updated[i].isUnlocked {
            updated[i].isUnlocked = true
            updated[i].unlockedDate = Date()
        }
        
        if let i = updated.firstIndex(where: { $0.title == "5 Virtual Try-Ons" }), tryOnSessions.count >= 5 && !updated[i].isUnlocked {
            updated[i].isUnlocked = true
            updated[i].unlockedDate = Date()
        }
        
        let uniqueStyles = Set(tryOnSessions.map { $0.style })
        if let i = updated.firstIndex(where: { $0.title == "Style Explorer" }), uniqueStyles.count >= 3 && !updated[i].isUnlocked {
            updated[i].isUnlocked = true
            updated[i].unlockedDate = Date()
        }
        
        let uniqueBrands = Set(tryOnSessions.map { $0.brand })
        if let i = updated.firstIndex(where: { $0.title == "Brand Enthusiast" }), uniqueBrands.count >= 5 && !updated[i].isUnlocked {
            updated[i].isUnlocked = true
            updated[i].unlockedDate = Date()
        }
        
        achievements = updated
        UserDefaultsStorage.shared.saveAchievements(achievements)
    }
    
    func setCollectionCount(_ count: Int) {
        var newStats = statistics
        newStats.totalBagsInCollection = count
        statistics = newStats
        var updated = achievements
        if let i = updated.firstIndex(where: { $0.title == "Collection Builder" }), count >= 10 && !updated[i].isUnlocked {
            updated[i].isUnlocked = true
            updated[i].unlockedDate = Date()
            achievements = updated
            UserDefaultsStorage.shared.saveAchievements(achievements)
        }
    }
    
    func addTryOnSession(_ session: TryOnSession) {
        var updated = tryOnSessions
        updated.append(session)
        tryOnSessions = updated
        UserDefaultsStorage.shared.saveTryOnSessions(tryOnSessions)
    }
    
    func refreshProgressData() {
        tryOnSessions = UserDefaultsStorage.shared.loadTryOnSessions()
        updateStatistics(tryOnSessions)
        achievements = UserDefaultsStorage.shared.loadAchievements() ?? Achievement.defaultAchievements
    }
    
    func refreshFromStorage() {
        user = UserDefaultsStorage.shared.loadUser() ?? User()
        tryOnSessions = UserDefaultsStorage.shared.loadTryOnSessions()
        achievements = UserDefaultsStorage.shared.loadAchievements() ?? Achievement.defaultAchievements
        updateStatistics(tryOnSessions)
    }
    
    func updateUser(_ updatedUser: User) {
        user = updatedUser
        UserDefaultsStorage.shared.saveUser(user)
    }
    
    func updateNotificationSettings(_ settings: NotificationSettings) {
        user.notificationSettings = settings
        UserDefaultsStorage.shared.saveUser(user)
    }
    
    func getProgressData() -> [(String, Double)] {
        let styleData = Dictionary(grouping: tryOnSessions, by: { $0.style.rawValue })
            .mapValues { Double($0.count) }
        
        let maxCount = styleData.values.max() ?? 1
        return styleData.map { (key, value) in
            (key, value / maxCount)
        }.sorted { $0.0 < $1.0 }
    }
    
    func getBrandData() -> [(String, Int)] {
        let brandData = Dictionary(grouping: tryOnSessions, by: { $0.brand })
            .mapValues { $0.count }
        
        return brandData.map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }
            .prefix(5)
            .map { ($0.0, $0.1) }
    }
    
    func getCategoryData() -> [(String, Int)] {
        let categoryData = Dictionary(grouping: tryOnSessions, by: { $0.category.rawValue })
            .mapValues { $0.count }
        
        return categoryData.map { ($0.key, $0.value) }
            .sorted { $0.1 > $1.1 }
    }
}
