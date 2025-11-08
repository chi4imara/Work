import Foundation

enum SortOption: String, CaseIterable {
    case dateNewest = "Date (Newest First)"
    case serviceLife = "Service Life (Short to Long)"
    case nameAZ = "Name (A-Z)"
}

class FilterSettings: ObservableObject {
    @Published var selectedCategories: Set<PurchaseCategory> = Set(PurchaseCategory.allCases)
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .dateNewest
    
    func reset() {
        selectedCategories = Set(PurchaseCategory.allCases)
        searchText = ""
        sortOption = .dateNewest
    }
    
    func applyFilters(to purchases: [Purchase]) -> [Purchase] {
        var filtered = purchases
        
        filtered = filtered.filter { selectedCategories.contains($0.category) }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        switch sortOption {
        case .dateNewest:
            filtered = filtered.sorted { $0.purchaseDate > $1.purchaseDate }
        case .serviceLife:
            filtered = filtered.sorted { $0.serviceLifeYears < $1.serviceLifeYears }
        case .nameAZ:
            filtered = filtered.sorted { $0.name < $1.name }
        }
        
        return filtered
    }
}
