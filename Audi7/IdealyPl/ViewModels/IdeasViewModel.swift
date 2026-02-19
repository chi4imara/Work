import Foundation
import SwiftUI
import Combine

class IdeasViewModel: ObservableObject {
    @Published var ideas: [Idea] = []
    @Published var searchText: String = ""
    @Published var isFirstLaunch: Bool = true
    @Published var showOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedIdeas"
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        loadIdeas()
        checkFirstLaunch()
    }
    
    var filteredIdeas: [Idea] {
        if searchText.isEmpty {
            return ideas.sorted { $0.createdAt > $1.createdAt }
        } else {
            return ideas.filter { idea in
                idea.text.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    var hasIdeas: Bool {
        !ideas.isEmpty
    }
    
    var hasSearchResults: Bool {
        !filteredIdeas.isEmpty
    }
    
    var favoriteIdeas: [Idea] {
        ideas.filter { $0.isFavorite }.sorted { $0.createdAt > $1.createdAt }
    }
    
    var hasFavoriteIdeas: Bool {
        !favoriteIdeas.isEmpty
    }
    
    func addIdea(text: String) {
        let newIdea = Idea(text: text)
        ideas.append(newIdea)
        saveIdeas()
    }
    
    func updateIdea(_ idea: Idea, with newText: String) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index].updateText(newText)
            saveIdeas()
        }
    }
    
    func deleteIdea(_ idea: Idea) {
        ideas.removeAll { $0.id == idea.id }
        saveIdeas()
    }
    
    func deleteIdea(byId id: UUID) {
        ideas.removeAll { $0.id == id }
        saveIdeas()
    }
    
    func getIdea(byId id: UUID) -> Idea? {
        return ideas.first { $0.id == id }
    }
    
    func toggleFavorite(ideaId: UUID) {
        if let index = ideas.firstIndex(where: { $0.id == ideaId }) {
            ideas[index].toggleFavorite()
            saveIdeas()
        }
    }
    
    func clearAllIdeas() {
        ideas.removeAll()
        saveIdeas()
    }
    
    func completeOnboarding() {
        showOnboarding = true
        isFirstLaunch = false
        userDefaults.set(true, forKey: "hasSeenOnboarding")
    }
    
    private func loadIdeas() {
        if let data = userDefaults.data(forKey: ideasKey),
           let decodedIdeas = try? JSONDecoder().decode([Idea].self, from: data) {
            ideas = decodedIdeas
        }
    }
    
    private func saveIdeas() {
        if let encodedData = try? JSONEncoder().encode(ideas) {
            userDefaults.set(encodedData, forKey: ideasKey)
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = userDefaults.bool(forKey: firstLaunchKey) == false ? false : true
        if isFirstLaunch {
            showOnboarding = true
        }
    }
}
