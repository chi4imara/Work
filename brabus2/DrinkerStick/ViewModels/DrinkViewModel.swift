import Foundation
import SwiftUI
import Combine

class DrinkViewModel: ObservableObject {
    @Published var drinks: [Drink] = []
    @Published var filteredDrinks: [Drink] = []
    @Published var searchText: String = ""
    @Published var selectedType: DrinkType? = nil
    @Published var selectedCountry: String = ""
    @Published var strengthRange: ClosedRange<Double> = 0...100
    
    private let userDefaults = UserDefaults.standard
    private let drinksKey = "SavedDrinks"
    
    init() {
        loadDrinks()
    }
        
    func addDrink(_ drink: Drink) {
        drinks.append(drink)
        saveDrinks()
        applyFilters()
    }
    
    func updateDrink(_ drink: Drink) {
        if let index = drinks.firstIndex(where: { $0.id == drink.id }) {
            drinks[index] = drink
            saveDrinks()
            applyFilters()
        }
    }
    
    func deleteDrink(_ drink: Drink) {
        drinks.removeAll { $0.id == drink.id }
        saveDrinks()
        applyFilters()
    }
        
    private func saveDrinks() {
        if let encoded = try? JSONEncoder().encode(drinks) {
            userDefaults.set(encoded, forKey: drinksKey)
        }
    }
    
    private func loadDrinks() {
        if let data = userDefaults.data(forKey: drinksKey),
           let decoded = try? JSONDecoder().decode([Drink].self, from: data) {
            drinks = decoded
        }
        applyFilters()
    }
        
    func applyFilters() {
        var filtered = drinks
        
        if !searchText.isEmpty {
            filtered = filtered.filter { drink in
                drink.name.localizedCaseInsensitiveContains(searchText) ||
                drink.country.localizedCaseInsensitiveContains(searchText) ||
                drink.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let selectedType = selectedType {
            filtered = filtered.filter { $0.type == selectedType }
        }
        
        if !selectedCountry.isEmpty {
            filtered = filtered.filter { $0.country.localizedCaseInsensitiveContains(selectedCountry) }
        }
        
        filtered = filtered.filter { strengthRange.contains($0.strength) }
        
        filteredDrinks = filtered
    }
    
    func clearFilters() {
        searchText = ""
        selectedType = nil
        selectedCountry = ""
        strengthRange = 0...100
        applyFilters()
    }
        
    var totalDrinks: Int {
        drinks.count
    }
    
    var averageStrength: Double {
        guard !drinks.isEmpty else { return 0 }
        let total = drinks.reduce(0) { $0 + $1.strength }
        return total / Double(drinks.count)
    }
    
    var drinksByType: [DrinkType: Int] {
        var typeCount: [DrinkType: Int] = [:]
        for drink in drinks {
            typeCount[drink.type, default: 0] += 1
        }
        return typeCount
    }
    
    var drinksByCountry: [String: Int] {
        var countryCount: [String: Int] = [:]
        for drink in drinks {
            countryCount[drink.country, default: 0] += 1
        }
        return countryCount
    }
    
    var uniqueCountries: [String] {
        Array(Set(drinks.map { $0.country })).sorted()
    }
}
