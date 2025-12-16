import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var challenges: [Challenge] = []
    @Published var categories: [Category] = []
    @Published var history: [HistoryEntry] = []
    @Published var selectedCategory: Category?
    @Published var hasCompletedOnboarding: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let challengesKey = "SavedChallenges"
    private let categoriesKey = "SavedCategories"
    private let historyKey = "SavedHistory"
    private let onboardingKey = "HasCompletedOnboarding"
    private let hasCreatedDefaultsKey = "HasCreatedDefaultCategories"
    
    private init() {
        loadData()
        createDefaultCategories()
    }
    
    private func loadData() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
        
        if let challengesData = userDefaults.data(forKey: challengesKey),
           let decodedChallenges = try? JSONDecoder().decode([Challenge].self, from: challengesData) {
            challenges = decodedChallenges
        }
        
        if let categoriesData = userDefaults.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: categoriesData) {
            categories = decodedCategories
        }
        
        if let historyData = userDefaults.data(forKey: historyKey),
           let decodedHistory = try? JSONDecoder().decode([HistoryEntry].self, from: historyData) {
            history = decodedHistory
        }
    }
    
    private func saveData() {
        if let challengesData = try? JSONEncoder().encode(challenges) {
            userDefaults.set(challengesData, forKey: challengesKey)
        }
        
        if let categoriesData = try? JSONEncoder().encode(categories) {
            userDefaults.set(categoriesData, forKey: categoriesKey)
        }
        
        if let historyData = try? JSONEncoder().encode(history) {
            userDefaults.set(historyData, forKey: historyKey)
        }
        
        userDefaults.set(hasCompletedOnboarding, forKey: onboardingKey)
    }
    
    private func createDefaultCategories() {
        let hasCreatedDefaults = userDefaults.bool(forKey: hasCreatedDefaultsKey)
        
        if categories.isEmpty && !hasCreatedDefaults {
            let defaultCategories = [
                Category(name: "Funny"),
                Category(name: "Creative"),
                Category(name: "Active"),
                Category(name: "Social")
            ]
            categories = defaultCategories
            
            let defaultChallenges = [
                Challenge(text: "Tell a joke that makes everyone laugh", categoryId: defaultCategories[0].id),
                Challenge(text: "Sing a line from your favorite song", categoryId: defaultCategories[0].id),
                Challenge(text: "Take a funny photo of an object in the room", categoryId: defaultCategories[1].id),
                Challenge(text: "Draw something with your eyes closed", categoryId: defaultCategories[1].id),
                Challenge(text: "Do 10 jumping jacks", categoryId: defaultCategories[2].id),
                Challenge(text: "Dance for 30 seconds", categoryId: defaultCategories[2].id),
                Challenge(text: "Give someone a compliment", categoryId: defaultCategories[3].id),
                Challenge(text: "Share an embarrassing story", categoryId: defaultCategories[3].id)
            ]
            challenges = defaultChallenges
            userDefaults.set(true, forKey: hasCreatedDefaultsKey)
            saveData()
        }
    }
    
    func addChallenge(_ challenge: Challenge) {
        challenges.append(challenge)
        saveData()
    }
    
    func deleteChallenge(_ challenge: Challenge) {
        challenges.removeAll { $0.id == challenge.id }
        history.removeAll { $0.challengeId == challenge.id }
        saveData()
    }
    
    func toggleFavorite(_ challenge: Challenge) {
        if let index = challenges.firstIndex(where: { $0.id == challenge.id }) {
            challenges[index].isFavorite.toggle()
            saveData()
        }
    }
    
    func getRandomChallenge() -> Challenge? {
        let availableChallenges: [Challenge]
        
        if let selectedCategory = selectedCategory {
            availableChallenges = challenges.filter { $0.categoryId == selectedCategory.id }
        } else {
            availableChallenges = challenges
        }
        
        return availableChallenges.randomElement()
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveData()
    }
    
    func deleteCategory(_ category: Category) {
        let challengeIdsToDelete = challenges
            .filter { $0.categoryId == category.id }
            .map { $0.id }
        
        challenges.removeAll { challengeIdsToDelete.contains($0.id) }
        history.removeAll { challengeIdsToDelete.contains($0.challengeId) }
        
        categories.removeAll { $0.id == category.id }
        
        if selectedCategory?.id == category.id {
            selectedCategory = nil
        }
        
        saveData()
    }
    
    func getChallengeCount(for category: Category) -> Int {
        return challenges.filter { $0.categoryId == category.id }.count
    }
    
    func getCategoryName(for categoryId: UUID) -> String {
        return categories.first { $0.id == categoryId }?.name ?? "Unknown"
    }
    
    func addToHistory(_ challenge: Challenge) {
        let categoryName = getCategoryName(for: challenge.categoryId)
        let entry = HistoryEntry(challenge: challenge, categoryName: categoryName)
        history.insert(entry, at: 0)
        saveData()
    }
    
    func deleteFromHistory(_ entry: HistoryEntry) {
        history.removeAll { $0.id == entry.id }
        saveData()
    }
    
    func addHistoryToFavorites(_ entry: HistoryEntry) {
        if let challenge = challenges.first(where: { $0.id == entry.challengeId }) {
            toggleFavorite(challenge)
        }
    }
    
    var favoriteChallenges: [Challenge] {
        return challenges.filter { $0.isFavorite }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveData()
    }
    
    func selectCategory(_ category: Category?) {
        selectedCategory = category
    }
}
