import Foundation
import SwiftUI
import Combine

class ModificationViewModel: ObservableObject {
    @Published var modifications: [Modification] = []
    @Published var searchText: String = ""
    @Published var selectedSortOption: SortOption = .priority
    @Published var selectedCategory: ModificationCategory? = nil
    
    var filteredModifications: [Modification] {
        var filtered = modifications
        
        if !searchText.isEmpty {
            filtered = filtered.filter { modification in
                modification.name.localizedCaseInsensitiveContains(searchText) ||
                modification.description.localizedCaseInsensitiveContains(searchText) ||
                modification.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        switch selectedSortOption {
        case .priority:
            filtered.sort { first, second in
                let firstPriority = statusPriority(first.status)
                let secondPriority = statusPriority(second.status)
                return firstPriority < secondPriority
            }
        case .cost:
            filtered.sort { $0.budget > $1.budget }
        case .category:
            filtered.sort { $0.category.rawValue < $1.category.rawValue }
        case .status:
            filtered.sort { $0.status.rawValue < $1.status.rawValue }
        }
        
        return filtered
    }
    
    var categorySummaries: [CategorySummary] {
        let categories = ModificationCategory.allCases
        return categories.map { category in
            let categoryMods = modifications.filter { $0.category == category }
            let totalBudget = categoryMods.reduce(0) { $0 + $1.budget }
            return CategorySummary(
                category: category,
                count: categoryMods.count,
                totalBudget: totalBudget
            )
        }.filter { $0.count > 0 }
    }
    
    var totalBudget: Double {
        modifications.reduce(0) { $0 + $1.budget }
    }
    
    var budgetByCategory: [ModificationCategory: Double] {
        var budgets: [ModificationCategory: Double] = [:]
        for category in ModificationCategory.allCases {
            let categoryBudget = modifications
                .filter { $0.category == category }
                .reduce(0) { $0 + $1.budget }
            if categoryBudget > 0 {
                budgets[category] = categoryBudget
            }
        }
        return budgets
    }
    
    func addModification(_ modification: Modification) {
        modifications.append(modification)
        saveModifications()
    }
    
    func updateModification(_ modification: Modification) {
        if let index = modifications.firstIndex(where: { $0.id == modification.id }) {
            modifications[index] = modification
            saveModifications()
        }
    }
    
    func deleteModification(_ modification: Modification) {
        modifications.removeAll { $0.id == modification.id }
        saveModifications()
    }
    
    func getModification(by id: UUID) -> Modification? {
        return modifications.first { $0.id == id }
    }
    
    func clearCategoryFilter() {
        selectedCategory = nil
    }
    
    private func statusPriority(_ status: ModificationStatus) -> Int {
        switch status {
        case .inProgress:
            return 0
        case .plan:
            return 1
        case .completed:
            return 2
        }
    }
    
    private func saveModifications() {
        if let encoded = try? JSONEncoder().encode(modifications) {
            UserDefaults.standard.set(encoded, forKey: "SavedModifications")
        }
    }
    
    func loadModifications() {
        if let data = UserDefaults.standard.data(forKey: "SavedModifications"),
           let decoded = try? JSONDecoder().decode([Modification].self, from: data) {
            modifications = decoded
        }
    }
}
