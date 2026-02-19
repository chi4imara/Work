import Foundation
import Combine

class BagViewModel: ObservableObject {
    @Published var bags: [Bag] = []
    @Published var filteredBags: [Bag] = []
    @Published var favoriteBags: [Bag] = []
    @Published var currentFilter = BagFilter()
    @Published var isLoading = false
    @Published var searchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadBags()
        setupSearch()
    }
    
    private func loadBags() {
        bags = UserDefaultsStorage.shared.loadBags()
        favoriteBags = bags.filter { $0.isFavorite }
        filterBags()
        isLoading = false
    }
    
    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.filterBags()
            }
            .store(in: &cancellables)
        
        $currentFilter
            .sink { [weak self] _ in
                self?.filterBags()
            }
            .store(in: &cancellables)
    }
    
    func filterBags() {
        var result = bags
        
        if !searchText.isEmpty {
            result = result.filter { bag in
                bag.name.localizedCaseInsensitiveContains(searchText) ||
                bag.brand.localizedCaseInsensitiveContains(searchText) ||
                bag.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !currentFilter.categories.isEmpty {
            result = result.filter { currentFilter.categories.contains($0.category) }
        }
        
        if !currentFilter.sizes.isEmpty {
            result = result.filter { currentFilter.sizes.contains($0.size) }
        }
        
        if !currentFilter.styles.isEmpty {
            result = result.filter { currentFilter.styles.contains($0.style) }
        }
        
        if !currentFilter.brands.isEmpty {
            result = result.filter { currentFilter.brands.contains($0.brand) }
        }
        
        if !currentFilter.colors.isEmpty {
            result = result.filter { currentFilter.colors.contains($0.color) }
        }
        
        result = result.filter { currentFilter.priceRange.contains($0.price) }
        
        filteredBags = result
    }
    
    func addBag(_ bag: Bag) {
        bags.append(bag)
        favoriteBags = bags.filter { $0.isFavorite }
        filterBags()
        UserDefaultsStorage.shared.saveBags(bags)
    }
    
    func removeBag(_ bag: Bag) {
        bags.removeAll { $0.id == bag.id }
        favoriteBags = bags.filter { $0.isFavorite }
        filterBags()
        UserDefaultsStorage.shared.saveBags(bags)
    }
    
    func toggleFavorite(_ bag: Bag) {
        if let index = bags.firstIndex(where: { $0.id == bag.id }) {
            bags[index].isFavorite.toggle()
            favoriteBags = bags.filter { $0.isFavorite }
        }
        filterBags()
        UserDefaultsStorage.shared.saveBags(bags)
    }
    
    func resetFilters() {
        currentFilter.reset()
        searchText = ""
        filterBags()
    }
    
    func refreshBags() {
        loadBags()
    }
    
    func getBag(by id: UUID) -> Bag? {
        return bags.first { $0.id == id }
    }
    
    var availableBrands: [String] {
        Array(Set(bags.map { $0.brand })).sorted()
    }
    
    var availableColors: [String] {
        Array(Set(bags.map { $0.color })).sorted()
    }
    
    var priceRange: ClosedRange<Double> {
        guard !bags.isEmpty else { return 0...1000 }
        let minPrice = bags.map { $0.price }.min() ?? 0
        let maxPrice = bags.map { $0.price }.max() ?? 1000
        return minPrice...maxPrice
    }
}
