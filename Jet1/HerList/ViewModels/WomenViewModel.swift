import Foundation
import SwiftUI
import Combine

class WomenViewModel: ObservableObject {
    @Published var women: [Woman] = []
    @Published var searchText = ""
    @Published var selectedFilter: FilterType = .all
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case withQuotes = "With Quotes"
        case withNotes = "With Notes"
        case favorites = "Favorites"
    }
    
    var filteredWomen: [Woman] {
        let filtered = women.filter { woman in
            let matchesSearch = searchText.isEmpty || 
                woman.name.localizedCaseInsensitiveContains(searchText) ||
                woman.profession.localizedCaseInsensitiveContains(searchText) ||
                woman.quote.localizedCaseInsensitiveContains(searchText) ||
                woman.personalNote.localizedCaseInsensitiveContains(searchText)
            
            let matchesFilter: Bool
            switch selectedFilter {
            case .all:
                matchesFilter = true
            case .withQuotes:
                matchesFilter = woman.hasQuote
            case .withNotes:
                matchesFilter = woman.hasNote
            case .favorites:
                matchesFilter = woman.isFavorite
            }
            
            return matchesSearch && matchesFilter
        }
        
        return filtered.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    var quotesOnly: [Woman] {
        women.filter { $0.hasQuote }
    }
    
    var favoriteQuotes: [Woman] {
        women.filter { $0.hasQuote && $0.isFavorite }
    }
    
    init() {
        loadWomen()
    }
    
    func addWoman(_ woman: Woman) {
        women.append(woman)
        saveWomen()
    }
    
    func updateWoman(_ woman: Woman) {
        if let index = women.firstIndex(where: { $0.id == woman.id }) {
            women[index] = woman
            saveWomen()
        }
    }
    
    func deleteWoman(_ woman: Woman) {
        women.removeAll { $0.id == woman.id }
        saveWomen()
    }
    
    func toggleFavorite(for woman: Woman) {
        if let index = women.firstIndex(where: { $0.id == woman.id }) {
            women[index].isFavorite.toggle()
            saveWomen()
        }
    }
    
    func getWoman(byId id: UUID) -> Woman? {
        return women.first { $0.id == id }
    }
    
    private func saveWomen() {
        if let encoded = try? JSONEncoder().encode(women) {
            UserDefaults.standard.set(encoded, forKey: "SavedWomen")
        }
    }
    
    private func loadWomen() {
        if let data = UserDefaults.standard.data(forKey: "SavedWomen"),
           let decoded = try? JSONDecoder().decode([Woman].self, from: data) {
            women = decoded
        }
    }
}
