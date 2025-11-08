import Foundation

struct FilterSettings: Codable {
    var selectedCategories: Set<InteriorIdea.Category>
    var searchText: String
    var sortOption: SortOption
    
    enum SortOption: String, CaseIterable, Codable {
        case dateAdded = "Date Added (Newest First)"
        case titleAZ = "Title (A-Z)"
        case category = "Category"
    }
    
    init() {
        self.selectedCategories = Set(InteriorIdea.Category.allCases)
        self.searchText = ""
        self.sortOption = .dateAdded
    }
    
    func reset() -> FilterSettings {
        return FilterSettings()
    }
}
