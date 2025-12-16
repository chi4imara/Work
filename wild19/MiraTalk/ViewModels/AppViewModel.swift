import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var selectedCategories: Set<QuestionCategory> = Set(QuestionCategory.allCases)
    @Published var favorites: [FavoriteQuestion] = []
    @Published var history: [HistoryEntry] = []
    @Published var currentQuestion: Question?
    @Published var showOnboarding = true
    @Published var isLoading = true
    
    private let questionsData = QuestionsData.shared
    
    init() {
        loadUserDefaults()
        generateRandomQuestion()
    }
    
    func generateRandomQuestion() {
        let availableQuestions = questionsData.allQuestions.filter { question in
            selectedCategories.contains(question.category)
        }
        
        guard !availableQuestions.isEmpty else {
            currentQuestion = nil
            return
        }
        
        if let randomQuestion = availableQuestions.randomElement() {
            currentQuestion = randomQuestion
            addToHistory(question: randomQuestion)
        }
    }
    
    func toggleCategory(_ category: QuestionCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        saveUserDefaults()
    }
    
    func resetCategories() {
        selectedCategories = Set(QuestionCategory.allCases)
        saveUserDefaults()
    }
    
    func applyCategories() {
        generateRandomQuestion()
        saveUserDefaults()
    }
    
    func addToFavorites(question: Question) {
        if !favorites.contains(where: { $0.question.text == question.text }) {
            let favorite = FavoriteQuestion(question: question)
            favorites.insert(favorite, at: 0)
            saveFavorites()
        }
    }
    
    func removeFromFavorites(favorite: FavoriteQuestion) {
        favorites.removeAll { $0.id == favorite.id }
        saveFavorites()
    }
    
    func isFavorite(question: Question) -> Bool {
        return favorites.contains { $0.question.text == question.text }
    }
    
    func addToHistory(question: Question) {
        let entry = HistoryEntry(question: question)
        history.insert(entry, at: 0)
        
        if history.count > 100 {
            history = Array(history.prefix(100))
        }
        
        saveHistory()
    }
    
    func groupedHistory() -> [(String, [HistoryEntry])] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        let grouped = Dictionary(grouping: history) { entry in
            formatter.string(from: entry.dateShown)
        }
        
        return grouped.sorted { first, second in
            guard let firstDate = formatter.date(from: first.key),
                  let secondDate = formatter.date(from: second.key) else {
                return false
            }
            return firstDate > secondDate
        }
    }
    
    func getCollections() -> [QuestionCollection] {
        return questionsData.collections
    }
    
    func completeOnboarding() {
        showOnboarding = false
        UserDefaults.standard.set(false, forKey: "showOnboarding")
    }
    
    func finishLoading() {
        isLoading = false
    }
    
    private func loadUserDefaults() {
        showOnboarding = UserDefaults.standard.object(forKey: "showOnboarding") == nil ? true : UserDefaults.standard.bool(forKey: "showOnboarding")
        
        if let categoriesData = UserDefaults.standard.data(forKey: "selectedCategories"),
           let categories = try? JSONDecoder().decode(Set<QuestionCategory>.self, from: categoriesData) {
            selectedCategories = categories
        }
        
        loadFavorites()
        loadHistory()
    }
    
    private func saveUserDefaults() {
        if let categoriesData = try? JSONEncoder().encode(selectedCategories) {
            UserDefaults.standard.set(categoriesData, forKey: "selectedCategories")
        }
    }
    
    private func saveFavorites() {
        if let favoritesData = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(favoritesData, forKey: "favorites")
        }
    }
    
    private func loadFavorites() {
        if let favoritesData = UserDefaults.standard.data(forKey: "favorites"),
           let loadedFavorites = try? JSONDecoder().decode([FavoriteQuestion].self, from: favoritesData) {
            favorites = loadedFavorites
        }
    }
    
    private func saveHistory() {
        if let historyData = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(historyData, forKey: "history")
        }
    }
    
    private func loadHistory() {
        if let historyData = UserDefaults.standard.data(forKey: "history"),
           let loadedHistory = try? JSONDecoder().decode([HistoryEntry].self, from: historyData) {
            history = loadedHistory
        }
    }
}
