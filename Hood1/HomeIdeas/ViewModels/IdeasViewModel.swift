import Foundation
import SwiftUI
import Combine

class IdeasViewModel: ObservableObject {
    @Published var ideas: [Idea] = []
    @Published var categories: [Category] = Category.defaultCategories
    @Published var historyEvents: [HistoryEvent] = []
    @Published var searchText = ""
    @Published var selectedCategories: Set<String> = []
    @Published var sortOption: SortOption = .dateNewest
    
    enum SortOption: String, CaseIterable {
        case dateNewest = "Date (Newest)"
        case dateOldest = "Date (Oldest)"
        case alphabeticalAZ = "Alphabetical (A-Z)"
        case alphabeticalZA = "Alphabetical (Z-A)"
    }
    
    var filteredIdeas: [Idea] {
        var filtered = ideas
        
        if !searchText.isEmpty {
            filtered = filtered.filter { idea in
                idea.title.localizedCaseInsensitiveContains(searchText) ||
                idea.note.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !selectedCategories.isEmpty {
            filtered = filtered.filter { selectedCategories.contains($0.category) }
        }
        
        switch sortOption {
        case .dateNewest:
            filtered.sort { $0.dateAdded > $1.dateAdded }
        case .dateOldest:
            filtered.sort { $0.dateAdded < $1.dateAdded }
        case .alphabeticalAZ:
            filtered.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .alphabeticalZA:
            filtered.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending }
        }
        
        return filtered
    }
    
    var statistics: (totalIdeas: Int, totalCategories: Int, recentIdea: String) {
        let totalIdeas = ideas.count
        let totalCategories = Set(ideas.map { $0.category }).count
        let recentIdea = ideas.sorted { $0.dateAdded > $1.dateAdded }.first?.title ?? "None"
        
        return (totalIdeas, totalCategories, recentIdea)
    }
    
    init() {
        loadData()
    }
    
    func addIdea(_ idea: Idea) {
        ideas.append(idea)
        addHistoryEvent(idea: idea, eventType: .added)
        saveData()
    }
    
    func updateIdea(_ idea: Idea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index] = idea
            addHistoryEvent(idea: idea, eventType: .modified)
            saveData()
        }
    }
    
    func deleteIdea(_ idea: Idea) {
        ideas.removeAll { $0.id == idea.id }
        addHistoryEvent(idea: idea, eventType: .deleted)
        saveData()
    }
    
    func getRandomIdea() -> Idea? {
        let availableIdeas = filteredIdeas
        return availableIdeas.randomElement()
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveData()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            let oldName = categories[index].name
            categories[index] = category
            
            for i in ideas.indices {
                if ideas[i].category == oldName {
                    ideas[i].category = category.name
                }
            }
            saveData()
        }
    }
    
    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        
        for i in ideas.indices {
            if ideas[i].category == category.name {
                ideas[i].category = "Deleted Category"
            }
        }
        saveData()
    }
    
    private func addHistoryEvent(idea: Idea, eventType: HistoryEventType) {
        let event = HistoryEvent(idea: idea, eventType: eventType)
        historyEvents.insert(event, at: 0)
        saveData()
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategories.removeAll()
        sortOption = .dateNewest
    }
    
    private func saveData() {
        if let ideasData = try? JSONEncoder().encode(ideas) {
            UserDefaults.standard.set(ideasData, forKey: "SavedIdeas")
        }
        
        if let categoriesData = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(categoriesData, forKey: "SavedCategories")
        }
        
        if let historyData = try? JSONEncoder().encode(historyEvents) {
            UserDefaults.standard.set(historyData, forKey: "SavedHistory")
        }
    }
    
    private func loadData() {
        if let ideasData = UserDefaults.standard.data(forKey: "SavedIdeas"),
           let decodedIdeas = try? JSONDecoder().decode([Idea].self, from: ideasData) {
            ideas = decodedIdeas
        }
        
        if let categoriesData = UserDefaults.standard.data(forKey: "SavedCategories"),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: categoriesData) {
            categories = decodedCategories
        }
        
        if let historyData = UserDefaults.standard.data(forKey: "SavedHistory"),
           let decodedHistory = try? JSONDecoder().decode([HistoryEvent].self, from: historyData) {
            historyEvents = decodedHistory
        }
    }
}
