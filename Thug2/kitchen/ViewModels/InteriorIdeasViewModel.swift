import Foundation
import SwiftUI

class InteriorIdeasViewModel: ObservableObject {
    @Published var ideas: [InteriorIdea] = []
    @Published var filterSettings = FilterSettings()
    @Published var isFirstLaunch = true
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedInteriorIdeas"
    private let filterSettingsKey = "FilterSettings"
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        loadIdeas()
        loadFilterSettings()
        loadFirstLaunchStatus()
    }
    
    private func saveIdeas() {
        if let encoded = try? JSONEncoder().encode(ideas) {
            userDefaults.set(encoded, forKey: ideasKey)
        }
    }
    
    private func loadIdeas() {
        if let data = userDefaults.data(forKey: ideasKey),
           let decoded = try? JSONDecoder().decode([InteriorIdea].self, from: data) {
            ideas = decoded
        }
    }
    
    private func saveFilterSettings() {
        if let encoded = try? JSONEncoder().encode(filterSettings) {
            userDefaults.set(encoded, forKey: filterSettingsKey)
        }
    }
    
    private func loadFilterSettings() {
        if let data = userDefaults.data(forKey: filterSettingsKey),
           let decoded = try? JSONDecoder().decode(FilterSettings.self, from: data) {
            filterSettings = decoded
        }
    }
    
    private func loadFirstLaunchStatus() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    func completeOnboarding() {
        isFirstLaunch = false
        userDefaults.set(true, forKey: firstLaunchKey)
    }
    
    func addIdea(_ idea: InteriorIdea) {
        ideas.append(idea)
        saveIdeas()
    }
    
    func updateIdea(_ idea: InteriorIdea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            var updatedIdea = idea
            updatedIdea.updateModifiedDate()
            ideas[index] = updatedIdea
            saveIdeas()
        }
    }
    
    func deleteIdea(_ idea: InteriorIdea) {
        ideas.removeAll { $0.id == idea.id }
        saveIdeas()
    }
    
    func toggleFavorite(for idea: InteriorIdea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index].isFavorite.toggle()
            ideas[index].updateModifiedDate()
            saveIdeas()
        }
    }
    
    var filteredAndSortedIdeas: [InteriorIdea] {
        var result = ideas
        
        result = result.filter { filterSettings.selectedCategories.contains($0.category) }
        
        if !filterSettings.searchText.isEmpty {
            result = result.filter { idea in
                idea.title.localizedCaseInsensitiveContains(filterSettings.searchText) ||
                idea.note.localizedCaseInsensitiveContains(filterSettings.searchText)
            }
        }
        
        switch filterSettings.sortOption {
        case .dateAdded:
            result = result.sorted { $0.dateAdded > $1.dateAdded }
        case .titleAZ:
            result = result.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .category:
            result = result.sorted { $0.category.rawValue.localizedCaseInsensitiveCompare($1.category.rawValue) == .orderedAscending }
        }
        
        return result
    }
    
    var favoriteIdeas: [InteriorIdea] {
        return ideas.filter { $0.isFavorite }.sorted { $0.dateModified > $1.dateModified }
    }
    
    func updateFilterSettings(_ newSettings: FilterSettings) {
        filterSettings = newSettings
        saveFilterSettings()
    }
    
    func resetFilters() {
        filterSettings = FilterSettings()
        saveFilterSettings()
    }
    
    var totalIdeasCount: Int {
        return ideas.count
    }
    
    var favoriteIdeasCount: Int {
        return ideas.filter { $0.isFavorite }.count
    }
    
    var ideasByCategory: [InteriorIdea.Category: Int] {
        var categoryCount: [InteriorIdea.Category: Int] = [:]
        
        for category in InteriorIdea.Category.allCases {
            categoryCount[category] = ideas.filter { $0.category == category }.count
        }
        
        return categoryCount
    }
    
    var ideasByDate: [String: Int] {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        var dateCount: [String: Int] = [:]
        
        for idea in ideas {
            let dateString = formatter.string(from: idea.dateAdded)
            dateCount[dateString, default: 0] += 1
        }
        
        return dateCount
    }
}
