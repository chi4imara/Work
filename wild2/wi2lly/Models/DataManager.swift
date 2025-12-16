import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults.standard
    private let wordsKey = "SavedWords"
    private let categoriesKey = "SavedCategories"
    
    @Published var words: [WordModel] = []
    @Published var categories: [CategoryModel] = []
    
    private init() {
        loadData()
        setupDefaultCategories()
    }
    
    private func loadData() {
        loadWords()
        loadCategories()
    }
    
    private func loadWords() {
        if let data = userDefaults.data(forKey: wordsKey),
           let decodedWords = try? JSONDecoder().decode([WordModel].self, from: data) {
            words = decodedWords
        }
    }
    
    private func loadCategories() {
        if let data = userDefaults.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([CategoryModel].self, from: data) {
            categories = decodedCategories
        }
    }
    
    private func saveWords() {
        if let encoded = try? JSONEncoder().encode(words) {
            userDefaults.set(encoded, forKey: wordsKey)
        }
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            userDefaults.set(encoded, forKey: categoriesKey)
        }
    }
    
    private func setupDefaultCategories() {
        if categories.isEmpty {
            categories = CategoryModel.defaultCategories
            saveCategories()
        }
    }
    
    func addWord(_ word: WordModel) {
        words.append(word)
        updateCategoryStats()
        saveWords()
        saveCategories()
    }
    
    func updateWord(_ updatedWord: WordModel) {
        if let index = words.firstIndex(where: { $0.id == updatedWord.id }) {
            words[index] = updatedWord
            updateCategoryStats()
            saveWords()
            saveCategories()
        }
    }
    
    func deleteWord(_ word: WordModel) {
        words.removeAll { $0.id == word.id }
        updateCategoryStats()
        saveWords()
        saveCategories()
    }
    
    func addCategory(_ category: CategoryModel) {
        categories.append(category)
        saveCategories()
    }
    
    func updateCategory(_ updatedCategory: CategoryModel) {
        if let index = categories.firstIndex(where: { $0.id == updatedCategory.id }) {
            let oldName = categories[index].name
            categories[index] = updatedCategory
            
            for i in 0..<words.count {
                if words[i].categoryName == oldName {
                    words[i].categoryName = updatedCategory.name
                }
            }
            
            updateCategoryStats()
            saveCategories()
            saveWords()
        }
    }
    
    func deleteCategory(_ category: CategoryModel) {
        let wordsInCategory = words.filter { $0.categoryName == category.name }
        if wordsInCategory.isEmpty {
            categories.removeAll { $0.id == category.id }
            saveCategories()
        }
    }
    
    private func updateCategoryStats() {
        for i in 0..<categories.count {
            let categoryWords = words.filter { $0.categoryName == categories[i].name }
            categories[i].wordsCount = categoryWords.count
            
            let sortedWords = categoryWords.sorted { $0.dateAdded > $1.dateAdded }
            categories[i].lastWordAdded = sortedWords.first?.word
        }
    }
    
    func getWordsForCategory(_ categoryName: String) -> [WordModel] {
        return words.filter { $0.categoryName == categoryName }
    }
    
    func getStatistics() -> [CategoryStatistic] {
        var statistics: [CategoryStatistic] = []
        
        for category in categories {
            let categoryWords = words.filter { $0.categoryName == category.name }
            if !categoryWords.isEmpty {
                statistics.append(CategoryStatistic(
                    category: category,
                    count: categoryWords.count,
                    percentage: Double(categoryWords.count) / Double(words.count)
                ))
            }
        }
        
        return statistics.sorted { $0.count > $1.count }
    }
    
    func getRecentWords(limit: Int = 5) -> [WordModel] {
        let sortedWords = words.sorted { $0.dateAdded > $1.dateAdded }
        return Array(sortedWords.prefix(limit))
    }
    
    func getFilteredAndSortedWords(categoryFilter: CategoryModel?, sortOption: WordsViewModel.SortOption) -> [WordModel] {
        var filtered = words
        
        if let category = categoryFilter {
            filtered = filtered.filter { $0.categoryName == category.name }
        }
        
        switch sortOption {
        case .dateAdded:
            filtered.sort { $0.dateAdded > $1.dateAdded }
        case .alphabetical:
            filtered.sort { $0.word.lowercased() < $1.word.lowercased() }
        }
        
        return filtered
    }
}
