import Foundation
import SwiftUI
import Combine

class NailIdeasViewModel: ObservableObject {
    @Published var ideas: [NailIdea] = []
    @Published var collections: [NailCollection] = []
    @Published var filteredIdeas: [NailIdea] = []
    @Published var searchText = ""
    @Published var selectedStatus: Set<IdeaStatus> = Set(IdeaStatus.allCases)
    @Published var selectedDesignType: DesignType?
    @Published var selectedSeasonEvent: SeasonEvent?
    @Published var selectedColorFilter = ""
    @Published var sortOption: SortOption = .dateAdded
    
    enum SortOption: String, CaseIterable {
        case dateAdded = "Date Added"
        case name = "Name"
        case season = "Season"
        case status = "Status"
    }
    
    init() {
        loadData()
        updateFilteredIdeas()
    }
        
    func addIdea(_ idea: NailIdea) {
        ideas.append(idea)
        saveData()
        updateFilteredIdeas()
    }
    
    func updateIdea(_ idea: NailIdea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index] = idea
            saveData()
            updateFilteredIdeas()
        }
    }
    
    func deleteIdea(_ idea: NailIdea) {
        ideas.removeAll { $0.id == idea.id }
        for i in collections.indices {
            collections[i].ideaIds.removeAll { $0 == idea.id }
        }
        saveData()
        updateFilteredIdeas()
    }
    
    func changeIdeaStatus(_ idea: NailIdea, to status: IdeaStatus) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index].status = status
            saveData()
            updateFilteredIdeas()
        }
    }
        
    func addCollection(_ collection: NailCollection) {
        collections.append(collection)
        saveData()
    }
    
    func updateCollection(_ collection: NailCollection) {
        if let index = collections.firstIndex(where: { $0.id == collection.id }) {
            collections[index] = collection
            saveData()
        }
    }
    
    func deleteCollection(_ collection: NailCollection) {
        collections.removeAll { $0.id == collection.id }
        saveData()
    }
    
    func addIdeaToCollection(ideaId: UUID, collectionId: UUID) {
        if let index = collections.firstIndex(where: { $0.id == collectionId }) {
            if !collections[index].ideaIds.contains(ideaId) {
                collections[index].ideaIds.append(ideaId)
                saveData()
            }
        }
    }
    
    func removeIdeaFromCollection(ideaId: UUID, collectionId: UUID) {
        if let index = collections.firstIndex(where: { $0.id == collectionId }) {
            collections[index].ideaIds.removeAll { $0 == ideaId }
            saveData()
        }
    }
    
    func getIdeasInCollection(_ collection: NailCollection) -> [NailIdea] {
        return ideas.filter { idea in
            collection.ideaIds.contains(idea.id)
        }
    }
        
    func updateFilteredIdeas() {
        var filtered = ideas
        
        if !searchText.isEmpty {
            filtered = filtered.filter { idea in
                idea.name.localizedCaseInsensitiveContains(searchText) ||
                idea.mainColor.localizedCaseInsensitiveContains(searchText) ||
                idea.additionalColors.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !selectedColorFilter.isEmpty {
            filtered = filtered.filter { idea in
                idea.mainColor.localizedCaseInsensitiveContains(selectedColorFilter) ||
                idea.additionalColors.localizedCaseInsensitiveContains(selectedColorFilter)
            }
        }
        
        filtered = filtered.filter { idea in
            selectedStatus.contains(idea.status)
        }
        
        if let designType = selectedDesignType {
            filtered = filtered.filter { $0.designType == designType }
        }
        
        if let seasonEvent = selectedSeasonEvent {
            filtered = filtered.filter { $0.seasonEvent == seasonEvent }
        }
        
        switch sortOption {
        case .dateAdded:
            filtered.sort { $0.dateAdded > $1.dateAdded }
        case .name:
            filtered.sort { $0.name < $1.name }
        case .season:
            filtered.sort { $0.seasonEvent.rawValue < $1.seasonEvent.rawValue }
        case .status:
            filtered.sort { $0.status.rawValue < $1.status.rawValue }
        }
        
        filteredIdeas = filtered
    }
    
    func resetFilters() {
        searchText = ""
        selectedStatus = Set(IdeaStatus.allCases)
        selectedDesignType = nil
        selectedSeasonEvent = nil
        selectedColorFilter = ""
        updateFilteredIdeas()
    }
        
    private func saveData() {
        if let ideasData = try? JSONEncoder().encode(ideas) {
            UserDefaults.standard.set(ideasData, forKey: "SavedIdeas")
        }
        
        if let collectionsData = try? JSONEncoder().encode(collections) {
            UserDefaults.standard.set(collectionsData, forKey: "SavedCollections")
        }
    }
    
    private func loadData() {
        if let ideasData = UserDefaults.standard.data(forKey: "SavedIdeas"),
           let decodedIdeas = try? JSONDecoder().decode([NailIdea].self, from: ideasData) {
            ideas = decodedIdeas
        }
        
        if let collectionsData = UserDefaults.standard.data(forKey: "SavedCollections"),
           let decodedCollections = try? JSONDecoder().decode([NailCollection].self, from: collectionsData) {
            collections = decodedCollections
        }
    }
}
