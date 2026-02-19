import Foundation
import SwiftUI
import Combine

class BagStore: ObservableObject {
    @Published var bags: [Bag] = []
    @Published var searchText: String = ""
    @Published var selectedSize: BagSize?
    @Published var selectedStyle: BagStyle?
    @Published var showOnboarding: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let bagsKey = "SavedBags"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadBags()
        loadOnboardingStatus()
    }
    
    var filteredBags: [Bag] {
        var result = bags
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        if let selectedSize = selectedSize {
            result = result.filter { $0.size == selectedSize }
        }
        
        if let selectedStyle = selectedStyle {
            result = result.filter { $0.style == selectedStyle }
        }
        
        return result.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    var favoriteBags: [Bag] {
        return bags.filter { $0.isFavorite }.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    var sizeCategories: [Category] {
        return BagSize.allCases.map { size in
            let count = bags.filter { $0.size == size }.count
            return Category(name: size.displayName, count: count, type: .size(size))
        }.filter { $0.count > 0 }
    }
    
    var styleCategories: [Category] {
        return BagStyle.allCases.map { style in
            let count = bags.filter { $0.style == style }.count
            return Category(name: style.displayName, count: count, type: .style(style))
        }.filter { $0.count > 0 }
    }
    
    func addBag(_ bag: Bag) {
        bags.append(bag)
        saveBags()
    }
    
    func updateBag(_ bag: Bag) {
        if let index = bags.firstIndex(where: { $0.id == bag.id }) {
            bags[index] = bag
            saveBags()
        }
    }
    
    func deleteBag(_ bag: Bag) {
        bags.removeAll { $0.id == bag.id }
        saveBags()
    }
    
    func toggleFavorite(for bag: Bag) {
        if let index = bags.firstIndex(where: { $0.id == bag.id }) {
            bags[index].isFavorite.toggle()
            saveBags()
        }
    }
    
    func clearFilters() {
        selectedSize = nil
        selectedStyle = nil
        searchText = ""
    }
    
    func filterBySize(_ size: BagSize) {
        selectedSize = size
        selectedStyle = nil
    }
    
    func filterByStyle(_ style: BagStyle) {
        selectedStyle = style
        selectedSize = nil
    }
    
    func completeOnboarding() {
        showOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    private func saveBags() {
        if let encoded = try? JSONEncoder().encode(bags) {
            userDefaults.set(encoded, forKey: bagsKey)
        }
    }
    
    private func loadBags() {
        if let data = userDefaults.data(forKey: bagsKey),
           let decoded = try? JSONDecoder().decode([Bag].self, from: data) {
            bags = decoded
        }
    }
    
    private func loadOnboardingStatus() {
        showOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
}
