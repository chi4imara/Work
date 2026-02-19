import Foundation
import SwiftUI
import Combine

class AchievementManager: ObservableObject {
    @Published var unlockedAchievements: Set<Achievement> = []
    @Published var currentStreak: Int = 0
    @Published var lastActivityDate: Date?
    
    private let userDefaults = UserDefaults.standard
    private let achievementsKey = "UnlockedAchievements"
    private let streakKey = "CurrentStreak"
    private let lastActivityKey = "LastActivityDate"
    
    init() {
        loadData()
        updateStreak()
    }
    
    func checkAchievements(productStore: ProductStore) {
        let products = productStore.products
        let suitableCount = productStore.suitableProducts.count
        let favoriteCount = productStore.favoriteProducts.count
        let categories = Set(products.map { $0.category })
        
        if products.count >= 1 && !unlockedAchievements.contains(.firstProduct) {
            unlockAchievement(.firstProduct)
        }
        
        if products.count >= 10 && !unlockedAchievements.contains(.tenProducts) {
            unlockAchievement(.tenProducts)
        }
        if products.count >= 50 && !unlockedAchievements.contains(.fiftyProducts) {
            unlockAchievement(.fiftyProducts)
        }
        if products.count >= 100 && !unlockedAchievements.contains(.hundredProducts) {
            unlockAchievement(.hundredProducts)
        }
        
        if categories.count >= 8 && !unlockedAchievements.contains(.explorer) {
            unlockAchievement(.explorer)
        }
        
        if favoriteCount >= 20 && !unlockedAchievements.contains(.organizer) {
            unlockAchievement(.organizer)
        }
        
        if favoriteCount >= 15 && !unlockedAchievements.contains(.collector) {
            unlockAchievement(.collector)
        }
        
        if products.count > 0 {
            let suitablePercentage = Double(suitableCount) / Double(products.count) * 100
            if suitablePercentage >= 80 && !unlockedAchievements.contains(.perfectionist) {
                unlockAchievement(.perfectionist)
            }
        }
        
        if currentStreak >= 7 && !unlockedAchievements.contains(.weekStreak) {
            unlockAchievement(.weekStreak)
        }
        if currentStreak >= 30 && !unlockedAchievements.contains(.monthStreak) {
            unlockAchievement(.monthStreak)
        }
    }
    
    func recordActivity() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = lastActivityDate != nil ? Calendar.current.startOfDay(for: lastActivityDate!) : nil
        
        if lastDate == nil || lastDate! < today {
            if let lastDate = lastDate, Calendar.current.dateComponents([.day], from: lastDate, to: today).day == 1 {
                currentStreak += 1
            } else if lastDate == nil || Calendar.current.dateComponents([.day], from: lastDate!, to: today).day! > 1 {
                currentStreak = 1
            }
            
            lastActivityDate = Date()
            saveData()
        }
    }
    
    private func updateStreak() {
        guard let lastDate = lastActivityDate else { return }
        let today = Calendar.current.startOfDay(for: Date())
        let lastActivity = Calendar.current.startOfDay(for: lastDate)
        
        let daysDifference = Calendar.current.dateComponents([.day], from: lastActivity, to: today).day ?? 0
        
        if daysDifference == 0 {
            return
        } else if daysDifference == 1 {
            return
        } else {
            currentStreak = 0
            saveData()
        }
    }
    
    private func unlockAchievement(_ achievement: Achievement) {
        unlockedAchievements.insert(achievement)
        saveData()
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func saveData() {
        let achievementStrings = unlockedAchievements.map { $0.rawValue }
        userDefaults.set(achievementStrings, forKey: achievementsKey)
        userDefaults.set(currentStreak, forKey: streakKey)
        if let lastDate = lastActivityDate {
            userDefaults.set(lastDate, forKey: lastActivityKey)
        }
    }
    
    private func loadData() {
        if let achievementStrings = userDefaults.array(forKey: achievementsKey) as? [String] {
            unlockedAchievements = Set(achievementStrings.compactMap { Achievement(rawValue: $0) })
        }
        currentStreak = userDefaults.integer(forKey: streakKey)
        lastActivityDate = userDefaults.object(forKey: lastActivityKey) as? Date
    }
}
