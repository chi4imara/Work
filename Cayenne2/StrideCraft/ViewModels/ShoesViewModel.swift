import Foundation
import SwiftUI
import Combine

class ShoesViewModel: ObservableObject {
    @Published var shoes: [Shoe] = []
    @Published var filteredShoes: [Shoe] = []
    @Published var selectedFilter: ShoeFilter = .all
    
    enum ShoeFilter: String, CaseIterable {
        case all = "All"
        case byCondition = "By Condition"
        case bySeason = "By Season"
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    init() {
        loadShoes()
        filterShoes()
    }
    
    func addShoe(_ shoe: Shoe) {
        shoes.append(shoe)
        saveShoes()
        filterShoes()
    }
    
    func updateShoe(_ shoe: Shoe) {
        if let index = shoes.firstIndex(where: { $0.id == shoe.id }) {
            shoes[index] = shoe
            saveShoes()
            filterShoes()
        }
    }
    
    func deleteShoe(_ shoe: Shoe) {
        shoes.removeAll { $0.id == shoe.id }
        saveShoes()
        filterShoes()
    }
    
    func filterShoes() {
        switch selectedFilter {
        case .all:
            filteredShoes = shoes.sorted { $0.purchaseDate > $1.purchaseDate }
        case .byCondition:
            filteredShoes = shoes.sorted { $0.condition.rawValue < $1.condition.rawValue }
        case .bySeason:
            filteredShoes = shoes.sorted { $0.season.rawValue < $1.season.rawValue }
        }
    }
    
    func setFilter(_ filter: ShoeFilter) {
        selectedFilter = filter
        filterShoes()
    }
    
    func getShoesByCategory(_ category: ShoeCategory) -> [Shoe] {
        return shoes.filter { $0.category == category }
    }
    
    func getShoesByCondition(_ condition: ShoeCondition) -> [Shoe] {
        return shoes.filter { $0.condition == condition }
    }
    
    func getCategoryCount(_ category: ShoeCategory) -> Int {
        return getShoesByCategory(category).count
    }
    
    func getConditionCount(_ condition: ShoeCondition) -> Int {
        return getShoesByCondition(condition).count
    }
    
    private func saveShoes() {
        if let encoded = try? JSONEncoder().encode(shoes) {
            UserDefaults.standard.set(encoded, forKey: Constants.UserDefaults.savedShoes)
        }
    }
    
    private func loadShoes() {
        if let data = UserDefaults.standard.data(forKey: Constants.UserDefaults.savedShoes),
           let decoded = try? JSONDecoder().decode([Shoe].self, from: data) {
            shoes = decoded
        }
    }
}
