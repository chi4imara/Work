import Foundation
import SwiftUI
import Combine

class HobbyIdeaViewModel: ObservableObject {
    @Published var ideas: [HobbyIdea] = []
    @Published var currentIdea: HobbyIdea?
    @Published var favoriteIdeas: [HobbyIdea] = []
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedHobbyIdeas"
    
    init() {
        loadIdeas()
        updateCurrentIdea()
    }
    
    private func saveIdeas() {
        if let encoded = try? JSONEncoder().encode(ideas) {
            userDefaults.set(encoded, forKey: ideasKey)
        }
    }
    
    private func loadIdeas() {
        if let data = userDefaults.data(forKey: ideasKey),
           let decoded = try? JSONDecoder().decode([HobbyIdea].self, from: data) {
            ideas = decoded
            updateFavorites()
        }
    }
    
    func addIdea(_ idea: HobbyIdea) {
        ideas.append(idea)
        saveIdeas()
        updateCurrentIdea()
    }
    
    func updateIdea(_ updatedIdea: HobbyIdea) {
        if let index = ideas.firstIndex(where: { $0.id == updatedIdea.id }) {
            ideas[index] = updatedIdea
            saveIdeas()
            updateFavorites()
            if currentIdea?.id == updatedIdea.id {
                currentIdea = updatedIdea
            }
        }
    }
    
    func deleteIdea(_ idea: HobbyIdea) {
        ideas.removeAll { $0.id == idea.id }
        saveIdeas()
        updateFavorites()
        updateCurrentIdea()
    }
    
    func updateCurrentIdea() {
        if ideas.isEmpty {
            currentIdea = nil
        } else {
            currentIdea = ideas.randomElement()
        }
    }
    
    func getNewRandomIdea() {
        if ideas.count > 1 {
            let filteredIdeas = ideas.filter { $0.id != currentIdea?.id }
            currentIdea = filteredIdeas.randomElement()
        } else if ideas.count == 1 {
            currentIdea = ideas.first
        } else {
            currentIdea = nil
        }
    }
    
    func toggleFavorite(_ idea: HobbyIdea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index].isFavorite.toggle()
            saveIdeas()
            updateFavorites()
            if currentIdea?.id == idea.id {
                currentIdea = ideas[index]
            }
        }
    }
    
    private func updateFavorites() {
        favoriteIdeas = ideas.filter { $0.isFavorite }
    }
    
    func removeFavorite(_ idea: HobbyIdea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index].isFavorite = false
            saveIdeas()
            updateFavorites()
        }
    }
    
    func getIdeas(for category: HobbyCategory) -> [HobbyIdea] {
        return ideas.filter { $0.hobby == category }
    }
    
    func getCategoryCount(for category: HobbyCategory) -> Int {
        return getIdeas(for: category).count
    }
    
    var sortedIdeas: [HobbyIdea] {
        return ideas.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    var sortedFavorites: [HobbyIdea] {
        return favoriteIdeas.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func getIdea(by id: UUID) -> HobbyIdea? {
        return ideas.first { $0.id == id }
    }
}
