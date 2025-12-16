import Foundation
import SwiftUI
import Combine

class DreamViewModel: ObservableObject {
    @Published var dreams: [DreamModel] = []
    @Published var filteredDreams: [DreamModel] = []
    @Published var selectedTags: Set<String> = []
    @Published var sortOption: DreamSortOption = .dateDescending
    @Published var showingFilterSheet = false
    @Published var searchText = ""
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        dataManager.$dreams
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dreams in
                self?.dreams = dreams
                self?.applyFiltersAndSort()
            }
            .store(in: &cancellables)
        
        dreams = dataManager.dreams
        applyFiltersAndSort()
    }
    
    func applyFiltersAndSort() {
        let filtered = dataManager.filterDreams(by: selectedTags, searchText: searchText)
        filteredDreams = dataManager.sortDreams(filtered, by: sortOption)
    }
    
    func deleteDream(_ dream: DreamModel) {
        dataManager.deleteDream(withId: dream.id)
    }
    
    func clearFilters() {
        selectedTags.removeAll()
        searchText = ""
        applyFiltersAndSort()
    }
    
    func getAllTags() -> [String] {
        return dataManager.getTagNames()
    }
}
