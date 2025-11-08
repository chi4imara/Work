import Foundation
import SwiftUI
import Combine

class VictoryStore: ObservableObject {
    @Published var victories: [Victory] = []
    @Published var categories: [Category] = []
    
    @Published var filteredVictories: [Victory] = []
    @Published var isFiltered = false
    @Published var filterPeriod: FilterPeriod = .all
    @Published var filterCategory: String? = nil
    @Published var searchText = ""
    @Published var customDateRange: (start: Date?, end: Date?) = (nil, nil)
    
    private let userDefaults = UserDefaults.standard
    private let victoriesKey = "SavedVictories"
    private let categoriesKey = "SavedCategories"
    
    init() {
        loadData()
        updateFilteredVictories()
    }
    
    func addVictory(_ victory: Victory) {
        victories.insert(victory, at: 0)
        saveData()
        updateFilteredVictories()
    }
    
    func updateVictory(_ updatedVictory: Victory) {
        if let index = victories.firstIndex(where: { $0.id == updatedVictory.id }) {
            victories[index] = updatedVictory
            saveData()
            updateFilteredVictories()
        }
    }
    
    func deleteVictory(_ victory: Victory) {
        victories.removeAll { $0.id == victory.id }
        saveData()
        updateFilteredVictories()
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        categories.sort { $0.name < $1.name }
        saveData()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
            categories.sort { $0.name < $1.name }
            saveData()
        }
    }
    
    func deleteCategory(_ category: Category) {
        categories.removeAll { $0.id == category.id }
        for index in victories.indices {
            if victories[index].category == category.name {
                victories[index].category = nil
            }
        }
        saveData()
        updateFilteredVictories()
    }
    
    func applyFilters() {
        isFiltered = filterPeriod != .all || filterCategory != nil || !searchText.isEmpty
        updateFilteredVictories()
    }
    
    func resetFilters() {
        filterPeriod = .all
        filterCategory = nil
        searchText = ""
        customDateRange = (nil, nil)
        isFiltered = false
        updateFilteredVictories()
    }
    
    private func updateFilteredVictories() {
        var filtered = victories
        
        switch filterPeriod {
        case .today:
            filtered = filtered.filter { Calendar.current.isDateInToday($0.date) }
        case .week:
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            filtered = filtered.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
            filtered = filtered.filter { $0.date >= monthAgo }
        case .custom:
            if let start = customDateRange.start {
                filtered = filtered.filter { $0.date >= start }
            }
            if let end = customDateRange.end {
                let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: end) ?? end
                filtered = filtered.filter { $0.date <= endOfDay }
            }
        case .all:
            break
        }
        
        if let category = filterCategory, category != "All" {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { victory in
                victory.title.localizedCaseInsensitiveContains(searchText) ||
                (victory.note?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        filteredVictories = filtered
    }
    
    func getTotalVictories() -> Int {
        victories.count
    }
    
    func getVictoriesCount(for period: StatisticsPeriod) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .day, value: -30, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
        
        return victories.filter { $0.date >= startDate }.count
    }
    
    func getBestDay(for period: StatisticsPeriod) -> (date: Date, count: Int)? {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .day, value: -30, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
        
        let filteredVictories = victories.filter { $0.date >= startDate }
        
        let groupedByDay = Dictionary(grouping: filteredVictories) { victory in
            calendar.startOfDay(for: victory.date)
        }
        
        guard let bestDay = groupedByDay.max(by: { $0.value.count < $1.value.count }) else {
            return nil
        }
        
        return (date: bestDay.key, count: bestDay.value.count)
    }
    
    func getCurrentStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var streak = 0
        var currentDate = today
        
        while true {
            let hasVictoryOnDate = victories.contains { victory in
                calendar.isDate(victory.date, inSameDayAs: currentDate)
            }
            
            if hasVictoryOnDate {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func saveData() {
        if let victoriesData = try? JSONEncoder().encode(victories) {
            userDefaults.set(victoriesData, forKey: victoriesKey)
        }
        
        if let categoriesData = try? JSONEncoder().encode(categories) {
            userDefaults.set(categoriesData, forKey: categoriesKey)
        }
    }
    
    private func loadData() {
        if let victoriesData = userDefaults.data(forKey: victoriesKey),
           let decodedVictories = try? JSONDecoder().decode([Victory].self, from: victoriesData) {
            victories = decodedVictories
        } else {
            victories = Victory.sampleData
        }
        
        if let categoriesData = userDefaults.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: categoriesData) {
            categories = decodedCategories
        } else {
            categories = Category.sampleData
        }
    }
}

enum FilterPeriod: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case custom = "Custom"
}

enum StatisticsPeriod: String, CaseIterable {
    case week = "7 days"
    case month = "30 days"
    case year = "Year"
}
