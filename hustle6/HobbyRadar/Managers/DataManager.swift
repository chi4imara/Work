import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var ideas: [Idea] = []
    @Published var favorites: Set<UUID> = []
    @Published var history: [HistoryEntry] = []
    @Published var categories: [Category] = []
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedIdeas"
    private let favoritesKey = "FavoriteIdeas"
    private let historyKey = "IdeaHistory"
    private let categoriesKey = "CustomCategories"
    private let hasLaunchedKey = "HasLaunchedBefore"
    
    private init() {
        loadData()
        setupInitialDataIfNeeded()
    }
    
    private func setupInitialDataIfNeeded() {
        if !userDefaults.bool(forKey: hasLaunchedKey) {
            categories = Category.systemCategories
            ideas = Idea.systemIdeas
            userDefaults.set(true, forKey: hasLaunchedKey)
            saveData()
        }
    }
    
    private func saveData() {
        if let ideasData = try? JSONEncoder().encode(ideas) {
            userDefaults.set(ideasData, forKey: ideasKey)
        }
        
        let favoritesArray = Array(favorites)
        if let favoritesData = try? JSONEncoder().encode(favoritesArray) {
            userDefaults.set(favoritesData, forKey: favoritesKey)
        }
        
        if let historyData = try? JSONEncoder().encode(history) {
            userDefaults.set(historyData, forKey: historyKey)
        }
        
        let customCategories = categories.filter { !$0.isSystem }
        if let categoriesData = try? JSONEncoder().encode(customCategories) {
            userDefaults.set(categoriesData, forKey: categoriesKey)
        }
    }
    
    private func loadData() {
        categories = Category.systemCategories
        if let categoriesData = userDefaults.data(forKey: categoriesKey),
           let customCategories = try? JSONDecoder().decode([Category].self, from: categoriesData) {
            categories.append(contentsOf: customCategories)
        }
        
        if let ideasData = userDefaults.data(forKey: ideasKey),
           let savedIdeas = try? JSONDecoder().decode([Idea].self, from: ideasData) {
            ideas = savedIdeas
        } else {
            ideas = Idea.systemIdeas
        }
        
        if let favoritesData = userDefaults.data(forKey: favoritesKey),
           let favoritesArray = try? JSONDecoder().decode([UUID].self, from: favoritesData) {
            favorites = Set(favoritesArray)
        }
        
        if let historyData = userDefaults.data(forKey: historyKey),
           let savedHistory = try? JSONDecoder().decode([HistoryEntry].self, from: historyData) {
            history = savedHistory
        }
    }
    
    func addIdea(_ idea: Idea) {
        ideas.append(idea)
        saveData()
        
        NotificationCenter.default.post(
            name: NSNotification.Name("IdeaAdded"),
            object: nil,
            userInfo: ["ideaId": idea.id]
        )
    }
    
    func updateIdea(_ updatedIdea: Idea) {
        if let index = ideas.firstIndex(where: { $0.id == updatedIdea.id }) {
            ideas[index] = updatedIdea
            saveData()
            
            NotificationCenter.default.post(
                name: NSNotification.Name("IdeaUpdated"),
                object: nil,
                userInfo: ["ideaId": updatedIdea.id]
            )
        }
    }
    
    func deleteIdea(withId id: UUID) {
        ideas.removeAll { $0.id == id }
        favorites.remove(id)
        history.removeAll { $0.ideaId == id }
        saveData()
        
        NotificationCenter.default.post(
            name: NSNotification.Name("IdeaDeleted"),
            object: nil,
            userInfo: ["ideaId": id]
        )
    }
    
    func getIdea(withId id: UUID) -> Idea? {
        return ideas.first { $0.id == id }
    }
    
    func toggleFavorite(ideaId: UUID) {
        let wasFavorite = favorites.contains(ideaId)
        
        if wasFavorite {
            favorites.remove(ideaId)
        } else {
            favorites.insert(ideaId)
        }
        saveData()
        
        NotificationCenter.default.post(
            name: NSNotification.Name("FavoriteToggled"),
            object: nil,
            userInfo: ["ideaId": ideaId, "isFavorite": !wasFavorite]
        )
    }
    
    func isFavorite(ideaId: UUID) -> Bool {
        return favorites.contains(ideaId)
    }
    
    func getFavoriteIdeas() -> [Idea] {
        return ideas.filter { favorites.contains($0.id) }
    }
    
    func clearAllFavorites() {
        let removedFavorites = Array(favorites)
        favorites.removeAll()
        saveData()
        
        for ideaId in removedFavorites {
            NotificationCenter.default.post(
                name: NSNotification.Name("FavoriteToggled"),
                object: nil,
                userInfo: ["ideaId": ideaId, "isFavorite": false]
            )
        }
        
        NotificationCenter.default.post(
            name: NSNotification.Name("FavoritesCleared"),
            object: nil
        )
    }
    
    func addToHistory(ideaId: UUID) {
        history.removeAll { $0.ideaId == ideaId }
        
        let newEntry = HistoryEntry(ideaId: ideaId)
        history.insert(newEntry, at: 0)
        
        if history.count > 50 {
            history = Array(history.prefix(50))
        }
        
        saveData()
    }
    
    func removeFromHistory(ideaId: UUID) {
        history.removeAll { $0.ideaId == ideaId }
        saveData()
        
        NotificationCenter.default.post(
            name: NSNotification.Name("HistoryUpdated"),
            object: nil,
            userInfo: ["ideaId": ideaId]
        )
    }
    
    func getHistoryIdeas() -> [Idea] {
        return history.compactMap { entry in
            getIdea(withId: entry.ideaId)
        }
    }
    
    func getRecentHistory(limit: Int = 10) -> [Idea] {
        let recentEntries = Array(history.prefix(limit))
        return recentEntries.compactMap { entry in
            getIdea(withId: entry.ideaId)
        }
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveData()
    }
    
    func categoryExists(name: String) -> Bool {
        return categories.contains { $0.name.lowercased() == name.lowercased() }
    }
    
    func generateRandomIdea(excluding currentIdeaId: UUID? = nil) -> Idea? {
        var availableIdeas = ideas
        
        if let currentId = currentIdeaId {
            availableIdeas = availableIdeas.filter { $0.id != currentId }
        }
        
        guard !availableIdeas.isEmpty else { return nil }
        
        let randomIdea = availableIdeas.randomElement()
        
        if let idea = randomIdea {
            addToHistory(ideaId: idea.id)
            
            NotificationCenter.default.post(
                name: NSNotification.Name("IdeaGenerated"),
                object: nil,
                userInfo: ["ideaId": idea.id]
            )
        }
        
        return randomIdea
    }
    
    func getFilteredIdeas(
        categories: [Category]? = nil,
        sourceFilter: SourceFilter = .all,
        sortBy: SortOption = .dateAdded,
        ascending: Bool = false
    ) -> [Idea] {
        var filteredIdeas = ideas
        
        if let categoryFilter = categories, !categoryFilter.isEmpty {
            let categoryNames = Set(categoryFilter.map { $0.name })
            filteredIdeas = filteredIdeas.filter { categoryNames.contains($0.category.name) }
        }
        
        switch sourceFilter {
        case .system:
            filteredIdeas = filteredIdeas.filter { $0.isSystem }
        case .user:
            filteredIdeas = filteredIdeas.filter { !$0.isSystem }
        case .all:
            break
        }
        
        switch sortBy {
        case .alphabetical:
            filteredIdeas.sort { ascending ? $0.title < $1.title : $0.title > $1.title }
        case .dateAdded:
            filteredIdeas.sort { ascending ? $0.dateAdded < $1.dateAdded : $0.dateAdded > $1.dateAdded }
        }
        
        return filteredIdeas
    }
}

enum SourceFilter: String, CaseIterable {
    case all = "All"
    case system = "System"
    case user = "User Added"
}

enum SortOption: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case dateAdded = "Date Added"
}
