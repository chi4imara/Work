import Foundation
import SwiftUI
import Combine

class MakeupStore: ObservableObject {
    @Published var ideas: [MakeupIdea] = []
    @Published var searchText: String = ""
    @Published var selectedTag: String? = nil
    @Published var hasCompletedOnboarding: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedMakeupIdeas"
    private let onboardingKey = "HasCompletedOnboarding"
    
    init() {
        loadIdeas()
        loadOnboardingStatus()
        _ = FontManager.shared
    }
        
    var filteredIdeas: [MakeupIdea] {
        var filtered = ideas
        
        if !searchText.isEmpty {
            filtered = filtered.filter { idea in
                idea.title.localizedCaseInsensitiveContains(searchText) ||
                idea.tags.contains { tag in
                    tag.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        if let selectedTag = selectedTag {
            filtered = filtered.filter { idea in
                idea.tags.contains(selectedTag)
            }
        }
        
        return filtered.sorted { $0.createdAt > $1.createdAt }
    }
    
    var favoriteIdeas: [MakeupIdea] {
        ideas.filter { $0.isFavorite }.sorted { $0.createdAt > $1.createdAt }
    }
    
    var allTags: [Tag] {
        var tagCounts: [String: Int] = [:]
        
        for idea in ideas {
            for tag in idea.tags {
                tagCounts[tag, default: 0] += 1
            }
        }
        
        return tagCounts.map { Tag(name: $0.key, count: $0.value) }
            .sorted { $0.name < $1.name }
    }
    
    func addIdea(_ idea: MakeupIdea) {
        ideas.append(idea)
        saveIdeas()
    }
    
    func updateIdea(_ updatedIdea: MakeupIdea) {
        if let index = ideas.firstIndex(where: { $0.id == updatedIdea.id }) {
            ideas[index] = updatedIdea
            saveIdeas()
        }
    }
    
    func deleteIdea(_ idea: MakeupIdea) {
        ideas.removeAll { $0.id == idea.id }
        saveIdeas()
    }
    
    func toggleFavorite(_ idea: MakeupIdea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index].isFavorite.toggle()
            saveIdeas()
        }
    }
        
    func clearSearch() {
        searchText = ""
        selectedTag = nil
    }
    
    func filterByTag(_ tag: String) {
        selectedTag = tag
        searchText = ""
    }
        
    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: onboardingKey)
    }
        
    private func saveIdeas() {
        if let encoded = try? JSONEncoder().encode(ideas) {
            userDefaults.set(encoded, forKey: ideasKey)
        }
    }
    
    private func loadIdeas() {
        if let data = userDefaults.data(forKey: ideasKey),
           let decoded = try? JSONDecoder().decode([MakeupIdea].self, from: data) {
            ideas = decoded
        }
    }
    
    private func loadOnboardingStatus() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
    }
}
