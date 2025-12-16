import Foundation
import SwiftUI
import Combine

class IdeaViewModel: ObservableObject {
    @Published var ideas: [Idea] = []
    @Published var searchText = ""
    @Published var selectedFilter: FilterType = .all
    @Published var showingAddIdea = false
    @Published var selectedIdea: Idea?
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedIdeas"
    
    init() {
        loadIdeas()
    }
    
    var filteredIdeas: [Idea] {
        var filtered = ideas
        
        switch selectedFilter {
        case .all:
            break
        case .planned:
            filtered = filtered.filter { $0.status == .planned }
        case .completed:
            filtered = filtered.filter { $0.status == .completed }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { idea in
                idea.title.localizedCaseInsensitiveContains(searchText) ||
                idea.description.localizedCaseInsensitiveContains(searchText) ||
                idea.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.createdAt > $1.createdAt }
    }
    
    var completedIdeasWithMemories: [Idea] {
        return ideas.filter { $0.status == .completed && $0.memory != nil && !$0.memory!.isEmpty }
            .sorted { $0.updatedAt > $1.updatedAt }
    }
    
    var ideasWithDates: [Idea] {
        return ideas.filter { $0.date != nil }
            .sorted { $0.date! < $1.date! }
    }
    
    var upcomingIdeas: [Idea] {
        let today = Date()
        return ideasWithDates.filter { idea in
            guard let date = idea.date else { return false }
            return date >= today
        }.prefix(5).map { $0 }
    }
    
    func addIdea(_ idea: Idea) {
        ideas.append(idea)
        saveIdeas()
    }
    
    func updateIdea(_ idea: Idea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            var updatedIdea = idea
            updatedIdea.updatedAt = Date()
            ideas[index] = updatedIdea
            saveIdeas()
        }
    }
    
    func deleteIdea(_ idea: Idea) {
        ideas.removeAll { $0.id == idea.id }
        saveIdeas()
    }
    
    func toggleIdeaStatus(_ idea: Idea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index].status = ideas[index].status == .planned ? .completed : .planned
            ideas[index].updatedAt = Date()
            saveIdeas()
        }
    }
    
    func addMemoryToIdea(_ idea: Idea, memory: String) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index].memory = memory
            ideas[index].updatedAt = Date()
            saveIdeas()
        }
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
    
    func ideasForDate(_ date: Date) -> [Idea] {
        let calendar = Calendar.current
        return ideas.filter { idea in
            guard let ideaDate = idea.date else { return false }
            return calendar.isDate(ideaDate, inSameDayAs: date)
        }
    }
    
    func hasIdeasForDate(_ date: Date) -> Bool {
        return !ideasForDate(date).isEmpty
    }
}
