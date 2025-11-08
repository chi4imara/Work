import Foundation
import SwiftUI
import Combine

class SeriesViewModel: ObservableObject {
    @Published var series: [Series] = []
    @Published var customCategories: [CustomCategory] = []
    @Published var selectedFilter: SeriesFilter = .all
    
    enum SeriesFilter: String, CaseIterable {
        case all = "All"
        case watching = "Watching Now"
        case waiting = "Waiting"
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    init() {
        loadSeries()
        loadCustomCategories()
    }
    
    var watchingSeries: [Series] {
        return series.filter { $0.status == .watching }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var waitingSeries: [Series] {
        return series.filter { $0.status == .waiting }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var filteredSeries: [Series] {
        switch selectedFilter {
        case .all:
            return series.sorted { $0.dateAdded > $1.dateAdded }
        case .watching:
            return watchingSeries
        case .waiting:
            return waitingSeries
        }
    }
    
    func seriesByCategory(_ category: SeriesCategory) -> [Series] {
        return series.filter { $0.category == category }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func categoriesWithCount() -> [(category: SeriesCategory, count: Int)] {
        return SeriesCategory.allCases.map { category in
            let count = series.filter { $0.category == category }.count
            return (category: category, count: count)
        }.filter { $0.count > 0 }
    }
    
    func addSeries(_ newSeries: Series) {
        series.append(newSeries)
        saveSeries()
    }
    
    func updateSeries(_ updatedSeries: Series) {
        if let index = series.firstIndex(where: { $0.id == updatedSeries.id }) {
            series[index] = updatedSeries
            saveSeries()
        }
    }
    
    func deleteSeries(_ seriesToDelete: Series) {
        series.removeAll { $0.id == seriesToDelete.id }
        saveSeries()
    }
    
    private func saveSeries() {
        if let encoded = try? JSONEncoder().encode(series) {
            UserDefaults.standard.set(encoded, forKey: "SavedSeries")
        }
    }
    
    private func loadSeries() {
        if let data = UserDefaults.standard.data(forKey: "SavedSeries"),
           let decoded = try? JSONDecoder().decode([Series].self, from: data) {
            series = decoded
        }
    }
    
    var totalSeriesCount: Int {
        return series.count
    }
    
    var watchingCount: Int {
        return watchingSeries.count
    }
    
    var waitingCount: Int {
        return waitingSeries.count
    }
    
    var watchingPercentage: Double {
        guard totalSeriesCount > 0 else { return 0 }
        return Double(watchingCount) / Double(totalSeriesCount)
    }
    
    var waitingPercentage: Double {
        guard totalSeriesCount > 0 else { return 0 }
        return Double(waitingCount) / Double(totalSeriesCount)
    }
    
    func addCustomCategory(_ category: CustomCategory) {
        customCategories.append(category)
        saveCustomCategories()
    }
    
    func updateCustomCategory(_ updatedCategory: CustomCategory) {
        if let index = customCategories.firstIndex(where: { $0.id == updatedCategory.id }) {
            customCategories[index] = updatedCategory
            saveCustomCategories()
        }
    }
    
    func deleteCustomCategory(_ categoryToDelete: CustomCategory) {
        customCategories.removeAll { $0.id == categoryToDelete.id }
        for index in series.indices {
            if series[index].customCategoryId == categoryToDelete.id {
                series[index].category = .other
                series[index].customCategoryId = nil
            }
        }
        saveCustomCategories()
        saveSeries()
    }
    
    func getCustomCategory(by id: UUID) -> CustomCategory? {
        return customCategories.first { $0.id == id }
    }
    
    func getAllCategories() -> [(category: SeriesCategory, customCategory: CustomCategory?, count: Int)] {
        var result: [(category: SeriesCategory, customCategory: CustomCategory?, count: Int)] = []
        
        for builtInCategory in SeriesCategory.allCases.filter({ $0 != .custom }) {
            let count = series.filter { $0.category == builtInCategory && $0.customCategoryId == nil }.count
            result.append((category: builtInCategory, customCategory: nil, count: count))
        }
        
        for customCategory in customCategories {
            let count = series.filter { $0.customCategoryId == customCategory.id }.count
            result.append((category: .custom, customCategory: customCategory, count: count))
        }
        
        return result.filter { $0.count > 0 }
    }
    
    private func saveCustomCategories() {
        if let encoded = try? JSONEncoder().encode(customCategories) {
            UserDefaults.standard.set(encoded, forKey: "SavedCustomCategories")
        }
    }
    
    private func loadCustomCategories() {
        if let data = UserDefaults.standard.data(forKey: "SavedCustomCategories"),
           let decoded = try? JSONDecoder().decode([CustomCategory].self, from: data) {
            customCategories = decoded
        }
    }
}
