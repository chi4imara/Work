import Foundation
import Combine

class WordsViewModel: ObservableObject {
    @Published var words: [WordModel] = []
    @Published var categories: [CategoryModel] = []
    @Published var filteredWords: [WordModel] = []
    @Published var selectedCategory: CategoryModel?
    @Published var sortOption: SortOption = .dateAdded
    @Published var searchText: String = ""
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption: String, CaseIterable {
        case dateAdded = "Date Added"
        case alphabetical = "Alphabetical"
    }
    
    init() {
        setupBindings()
        setupFiltering()
    }
    
    private func setupBindings() {
        dataManager.$words
            .assign(to: \.words, on: self)
            .store(in: &cancellables)
        
        dataManager.$categories
            .assign(to: \.categories, on: self)
            .store(in: &cancellables)
    }
    
    private func setupFiltering() {
        Publishers.CombineLatest3($words, $selectedCategory, $sortOption)
            .map { words, category, sort in
                var filtered = words
                
                if let category = category {
                    filtered = filtered.filter { $0.categoryName == category.name }
                }
                
                switch sort {
                case .dateAdded:
                    filtered.sort { $0.dateAdded > $1.dateAdded }
                case .alphabetical:
                    filtered.sort { $0.word.lowercased() < $1.word.lowercased() }
                }
                
                return filtered
            }
            .assign(to: \.filteredWords, on: self)
            .store(in: &cancellables)
    }
    
    func addWord(_ word: WordModel) {
        dataManager.addWord(word)
    }
    
    func updateWord(_ word: WordModel) {
        dataManager.updateWord(word)
    }
    
    func deleteWord(_ word: WordModel) {
        dataManager.deleteWord(word)
    }
    
    func addCategory(_ category: CategoryModel) {
        dataManager.addCategory(category)
    }
    
    func updateCategory(_ category: CategoryModel) {
        dataManager.updateCategory(category)
    }
    
    func deleteCategory(_ category: CategoryModel) {
        dataManager.deleteCategory(category)
    }
    
    func clearFilters() {
        selectedCategory = nil
        sortOption = .dateAdded
    }
    
    func getStatistics() -> [CategoryStatistic] {
        return dataManager.getStatistics()
    }
    
    func getRecentWords(limit: Int = 5) -> [WordModel] {
        return dataManager.getRecentWords(limit: limit)
    }
}

struct CategoryStatistic {
    let category: CategoryModel
    let count: Int
    let percentage: Double
}
