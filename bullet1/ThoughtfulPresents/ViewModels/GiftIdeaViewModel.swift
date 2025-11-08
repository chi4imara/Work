import Foundation
import Combine

enum SortOption: String, CaseIterable {
    case name = "name"
    case dateAdded = "dateAdded"
    case price = "price"
    case status = "status"
    
    var displayName: String {
        switch self {
        case .name:
            return "By Name"
        case .dateAdded:
            return "By Date Added"
        case .price:
            return "By Price"
        case .status:
            return "By Status"
        }
    }
}

struct GiftFilter {
    var selectedStatuses: Set<GiftStatus> = Set(GiftStatus.allCases)
    var selectedOccasion: GiftOccasion?
    var priceRange: ClosedRange<Double>?
    
    var isActive: Bool {
        return selectedStatuses.count != GiftStatus.allCases.count ||
               selectedOccasion != nil ||
               priceRange != nil
    }
    
    mutating func reset() {
        selectedStatuses = Set(GiftStatus.allCases)
        selectedOccasion = nil
        priceRange = nil
    }
}

class GiftIdeaViewModel: ObservableObject {
    @Published var giftIdeas: [GiftIdea] = []
    @Published var filteredGiftIdeas: [GiftIdea] = []
    @Published var currentFilter = GiftFilter()
    @Published var currentSort: SortOption = .dateAdded
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let giftIdeasKey = "SavedGiftIdeas"
    
    init() {
        loadGiftIdeas()
        applyFilterAndSort()
    }
    
    func loadGiftIdeas() {
        if let data = userDefaults.data(forKey: giftIdeasKey),
           let decodedIdeas = try? JSONDecoder().decode([GiftIdea].self, from: data) {
            self.giftIdeas = decodedIdeas
        } 
    }
    
    private func saveGiftIdeas() {
        if let encoded = try? JSONEncoder().encode(giftIdeas) {
            userDefaults.set(encoded, forKey: giftIdeasKey)
        }
    }
    
    func addGiftIdea(_ giftIdea: GiftIdea) {
        giftIdeas.append(giftIdea)
        saveGiftIdeas()
        applyFilterAndSort()
    }
    
    func updateGiftIdea(_ giftIdea: GiftIdea) {
        if let index = giftIdeas.firstIndex(where: { $0.id == giftIdea.id }) {
            var updatedGift = giftIdea
            updatedGift.updateModifiedDate()
            giftIdeas[index] = updatedGift
            saveGiftIdeas()
            applyFilterAndSort()
        }
    }
    
    func deleteGiftIdea(_ giftIdea: GiftIdea) {
        giftIdeas.removeAll { $0.id == giftIdea.id }
        saveGiftIdeas()
        applyFilterAndSort()
    }
    
    func deleteGiftIdea(at indexSet: IndexSet) {
        for index in indexSet {
            if index < filteredGiftIdeas.count {
                let giftToDelete = filteredGiftIdeas[index]
                deleteGiftIdea(giftToDelete)
            }
        }
    }
    
    func applyFilter(_ filter: GiftFilter) {
        currentFilter = filter
        applyFilterAndSort()
    }
    
    func applySorting(_ sort: SortOption) {
        currentSort = sort
        applyFilterAndSort()
    }
    
    func resetFilter() {
        currentFilter.reset()
        applyFilterAndSort()
    }
    
    private func applyFilterAndSort() {
        var filtered = giftIdeas
    
        filtered = filtered.filter { currentFilter.selectedStatuses.contains($0.status) }
        
        if let selectedOccasion = currentFilter.selectedOccasion {
            filtered = filtered.filter { $0.occasion == selectedOccasion }
        }
        
        if let priceRange = currentFilter.priceRange {
            filtered = filtered.filter { gift in
                guard let price = gift.estimatedPrice else { return false }
                return priceRange.contains(price)
            }
        }
        
        switch currentSort {
        case .name:
            filtered.sort { $0.recipientName < $1.recipientName }
        case .dateAdded:
            filtered.sort { $0.dateAdded > $1.dateAdded }
        case .price:
            filtered.sort { (lhs, rhs) in
                let lhsPrice = lhs.estimatedPrice ?? 0
                let rhsPrice = rhs.estimatedPrice ?? 0
                return lhsPrice > rhsPrice
            }
        case .status:
            filtered.sort { $0.status.rawValue < $1.status.rawValue }
        }
        
        filteredGiftIdeas = filtered
    }
    
    func getStatistics() -> (total: Int, bought: Int, gifted: Int, ideas: Int, totalAmount: Double) {
        let total = giftIdeas.count
        let bought = giftIdeas.filter { $0.status == .bought }.count
        let gifted = giftIdeas.filter { $0.status == .gifted }.count
        let ideas = giftIdeas.filter { $0.status == .idea }.count
        let totalAmount = giftIdeas.compactMap { $0.estimatedPrice }.reduce(0, +)
        
        return (total, bought, gifted, ideas, totalAmount)
    }
    
    func getFilteredStatistics() -> (total: Int, bought: Int, gifted: Int, ideas: Int, totalAmount: Double) {
        let total = filteredGiftIdeas.count
        let bought = filteredGiftIdeas.filter { $0.status == .bought }.count
        let gifted = filteredGiftIdeas.filter { $0.status == .gifted }.count
        let ideas = filteredGiftIdeas.filter { $0.status == .idea }.count
        let totalAmount = filteredGiftIdeas.compactMap { $0.estimatedPrice }.reduce(0, +)
        
        return (total, bought, gifted, ideas, totalAmount)
    }
    
    func getPeople() -> [Person] {
        return Person.createPeople(from: giftIdeas)
    }
    
    func getTopPeopleByAmount() -> [Person] {
        let people = getPeople()
        return Person.topPeopleByAmount(from: people)
    }
    
    func getGiftIdeas(for personName: String) -> [GiftIdea] {
        return giftIdeas.filter { $0.recipientName == personName }
    }
    
    func applyPersonFilter(_ personName: String) {
        var newFilter = GiftFilter()
        newFilter.selectedStatuses = Set(GiftStatus.allCases)
        currentFilter = newFilter
        
        let personGifts = getGiftIdeas(for: personName)
        filteredGiftIdeas = personGifts
    }
}
