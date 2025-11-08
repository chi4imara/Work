import Foundation
import SwiftUI

class IdeaStore: ObservableObject {
    @Published var ideas: [Idea] = []
    @Published var tags: [Tag] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: Category? = nil
    @Published var selectedTags: Set<Tag> = []
    @Published var sortOption: SortOption = .dateCreated
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedIdeas"
    private let tagsKey = "SavedTags"
    
    init() {
        loadIdeas()
        loadTags()
    }
    
    var filteredIdeas: [Idea] {
        var filtered = ideas
        
        if !searchText.isEmpty {
            filtered = filtered.filter { idea in
                idea.title.localizedCaseInsensitiveContains(searchText) ||
                idea.description.localizedCaseInsensitiveContains(searchText) ||
                idea.tags.contains { tag in
                    tag.name.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if !selectedTags.isEmpty {
            filtered = filtered.filter { idea in
                !Set(idea.tags).isDisjoint(with: selectedTags)
            }
        }
        
        switch sortOption {
        case .dateCreated:
            filtered.sort { $0.dateCreated > $1.dateCreated }
        case .alphabetical:
            filtered.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .category:
            filtered.sort { $0.category.rawValue.localizedCaseInsensitiveCompare($1.category.rawValue) == .orderedAscending }
        }
        
        return filtered
    }
    
    var favoriteIdeas: [Idea] {
        return ideas.filter { $0.isFavorite }.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func addIdea(_ idea: Idea) {
        ideas.append(idea)
        saveIdeas()
        
        for tag in idea.tags {
            if !tags.contains(where: { $0.name == tag.name }) {
                addTag(tag)
            }
        }
    }
    
    func updateIdea(_ idea: Idea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            var updatedIdea = idea
            updatedIdea.updateModifiedDate()
            ideas[index] = updatedIdea
            saveIdeas()
            
            for tag in idea.tags {
                if !tags.contains(where: { $0.name == tag.name }) {
                    addTag(tag)
                }
            }
        }
    }
    
    func deleteIdea(_ idea: Idea) {
        ideas.removeAll { $0.id == idea.id }
        saveIdeas()
    }
    
    func toggleFavorite(_ idea: Idea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index].isFavorite.toggle()
            ideas[index].updateModifiedDate()
            saveIdeas()
        }
    }
    
    func addTag(_ tag: Tag) {
        if !tags.contains(where: { $0.name == tag.name }) {
            tags.append(tag)
            saveTags()
        }
    }
    
    func deleteTag(_ tag: Tag) {
        for i in 0..<ideas.count {
            ideas[i].tags.removeAll { $0.name == tag.name }
        }
        
        tags.removeAll { $0.id == tag.id }
        
        saveIdeas()
        saveTags()
    }
    
    func getTagUsageCount(_ tag: Tag) -> Int {
        return ideas.filter { idea in
            idea.tags.contains { $0.name == tag.name }
        }.count
    }
    
    private func saveIdeas() {
        if let encoded = try? JSONEncoder().encode(ideas) {
            userDefaults.set(encoded, forKey: ideasKey)
        }
    }
    
    private func loadIdeas() {
        if let data = userDefaults.data(forKey: ideasKey),
           let decoded = try? JSONDecoder().decode([Idea].self, from: data) {
            ideas = decoded
        }
    }
    
    private func saveTags() {
        if let encoded = try? JSONEncoder().encode(tags) {
            userDefaults.set(encoded, forKey: tagsKey)
        }
    }
    
    private func loadTags() {
        if let data = userDefaults.data(forKey: tagsKey),
           let decoded = try? JSONDecoder().decode([Tag].self, from: data) {
            tags = decoded
        }
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        selectedTags.removeAll()
    }
    
    func filterByTag(_ tag: Tag) {
        clearFilters()
        selectedTags.insert(tag)
    }
}
