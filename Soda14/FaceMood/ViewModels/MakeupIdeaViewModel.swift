import Foundation
import SwiftUI
import Combine

class MakeupIdeaViewModel: ObservableObject {
    @Published var ideas: [MakeupIdea] = []
    @Published var selectedFilter: FilterType = .all
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedMakeupIdeas"
    
    init() {
        loadIdeas()
    }
    
    var filteredIdeas: [MakeupIdea] {
        if selectedFilter == .all {
            return ideas.sorted { $0.dateCreated > $1.dateCreated }
        } else {
            return ideas.filter { $0.tag == selectedFilter.makeupTag }
                        .sorted { $0.dateCreated > $1.dateCreated }
        }
    }
    
    var categorizedIdeas: [MakeupTag: [MakeupIdea]] {
        Dictionary(grouping: ideas) { $0.tag }
    }
    
    var notesWithComments: [MakeupIdea] {
        return ideas.filter { !$0.comment.isEmpty }
    }
    
    var filteredNotes: [MakeupIdea] {
        let notesWithComments = self.notesWithComments
        if selectedFilter == .all {
            return notesWithComments.sorted { $0.dateCreated > $1.dateCreated }
        } else {
            return notesWithComments.filter { $0.tag == selectedFilter.makeupTag }
                                   .sorted { $0.dateCreated > $1.dateCreated }
        }
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
    
    func clearAllNotes() {
        for index in ideas.indices {
            ideas[index].comment = ""
        }
        saveIdeas()
    }
    
    func setFilter(_ filter: FilterType) {
        selectedFilter = filter
    }
    
    func getIdeasCount(for tag: MakeupTag) -> Int {
        return ideas.filter { $0.tag == tag }.count
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
}
