import Foundation
import SwiftUI
import Combine

class CombinationStore: ObservableObject {
    @Published var combinations: [Combination] = []
    @Published var favoriteCombinationIds: Set<UUID> = []
    
    private let userDefaults = UserDefaults.standard
    private let combinationsKey = "SavedCombinations"
    private let favoritesKey = "FavoriteCombinationIds"
    
    init() {
        loadCombinations()
        loadFavorites()
    }
    
    
    func addCombination(_ combination: Combination) {
        combinations.append(combination)
        saveCombinations()
    }
    
    func updateCombination(_ combination: Combination) {
        if let index = combinations.firstIndex(where: { $0.id == combination.id }) {
            combinations[index] = combination
            saveCombinations()
        }
    }
    
    func deleteCombination(_ combination: Combination) {
        combinations.removeAll { $0.id == combination.id }
        saveCombinations()
    }
    
    func addJewelryToCombination(_ jewelry: Jewelry, to combination: Combination) {
        if let index = combinations.firstIndex(where: { $0.id == combination.id }) {
            combinations[index].jewelries.append(jewelry)
            saveCombinations()
        }
    }
    
    func removeJewelryFromCombination(_ jewelry: Jewelry, from combination: Combination) {
        if let combinationIndex = combinations.firstIndex(where: { $0.id == combination.id }) {
            combinations[combinationIndex].jewelries.removeAll { $0.id == jewelry.id }
            saveCombinations()
        }
    }
        
    func searchCombinations(by category: CombinationCategory) -> [Combination] {
        return combinations.filter { combination in
            let description = combination.description.lowercased()
            return category.keywords.contains { keyword in
                description.contains(keyword.lowercased())
            }
        }
    }
    
    func getCombination(by id: UUID) -> Combination? {
        return combinations.first { $0.id == id }
    }
    
    func toggleFavorite(combinationId: UUID) {
        if favoriteCombinationIds.contains(combinationId) {
            favoriteCombinationIds.remove(combinationId)
        } else {
            favoriteCombinationIds.insert(combinationId)
        }
        saveFavorites()
    }
    
    func isFavorite(combinationId: UUID) -> Bool {
        return favoriteCombinationIds.contains(combinationId)
    }
    
    func getFavoriteCombinations() -> [Combination] {
        return combinations.filter { favoriteCombinationIds.contains($0.id) }
    }
    
    func getTrends() -> TrendData {
        let totalCombinations = combinations.count
        let totalJewelry = combinations.reduce(0) { $0 + $1.jewelries.count }
        let averageJewelryPerCombination = totalCombinations > 0 ? Double(totalJewelry) / Double(totalCombinations) : 0.0
        
        var jewelryTypeCounts: [JewelryType: Int] = [:]
        for combination in combinations {
            for jewelry in combination.jewelries {
                jewelryTypeCounts[jewelry.type, default: 0] += 1
            }
        }
        
        let mostPopularType = jewelryTypeCounts.max(by: { $0.value < $1.value })?.key
        
        var categoryCounts: [CombinationCategory: Int] = [:]
        for category in CombinationCategory.allCases {
            categoryCounts[category] = searchCombinations(by: category).count
        }
        
        let mostPopularCategory = categoryCounts.max(by: { $0.value < $1.value })?.key
        
        return TrendData(
            totalCombinations: totalCombinations,
            totalJewelry: totalJewelry,
            averageJewelryPerCombination: averageJewelryPerCombination,
            mostPopularType: mostPopularType,
            mostPopularCategory: mostPopularCategory,
            jewelryTypeCounts: jewelryTypeCounts,
            categoryCounts: categoryCounts
        )
    }
        
    private func saveCombinations() {
        if let encoded = try? JSONEncoder().encode(combinations) {
            userDefaults.set(encoded, forKey: combinationsKey)
        }
    }
    
    private func loadCombinations() {
        if let data = userDefaults.data(forKey: combinationsKey),
           let decoded = try? JSONDecoder().decode([Combination].self, from: data) {
            combinations = decoded
        }
    }
    
    private func saveFavorites() {
        let idsArray = Array(favoriteCombinationIds).map { $0.uuidString }
        userDefaults.set(idsArray, forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        if let idsArray = userDefaults.array(forKey: favoritesKey) as? [String] {
            favoriteCombinationIds = Set(idsArray.compactMap { UUID(uuidString: $0) })
        }
    }
}

struct TrendData {
    let totalCombinations: Int
    let totalJewelry: Int
    let averageJewelryPerCombination: Double
    let mostPopularType: JewelryType?
    let mostPopularCategory: CombinationCategory?
    let jewelryTypeCounts: [JewelryType: Int]
    let categoryCounts: [CombinationCategory: Int]
}
