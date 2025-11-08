import Foundation
import SwiftUI
import Combine

class FirstExperienceStore: ObservableObject {
    @Published var experiences: [FirstExperience] = []
    @Published var categories: [Category] = Category.defaultCategories
    @Published var goals: [Goal] = []
    @Published var filteredExperiences: [FirstExperience] = []
    @Published var isFiltered = false
    
    @Published var selectedPeriod: FilterPeriod = .all
    @Published var selectedCategory: String = "All"
    @Published var searchText: String = ""
    @Published var customDateFrom: Date = Date()
    @Published var customDateTo: Date = Date()
    
    init() {
        loadData()
        updateFilteredExperiences()
    }
        
    func addExperience(_ experience: FirstExperience) {
        experiences.insert(experience, at: 0)
        updateFilteredExperiences()
        saveData()
    }
    
    func updateExperience(_ experience: FirstExperience) {
        if let index = experiences.firstIndex(where: { $0.id == experience.id }) {
            experiences[index] = experience
            updateFilteredExperiences()
            saveData()
        }
    }
    
    func deleteExperience(_ experience: FirstExperience) {
        experiences.removeAll { $0.id == experience.id }
        updateFilteredExperiences()
        saveData()
    }
    
    func deleteExperience(at indexSet: IndexSet) {
        let experiencesToDelete = indexSet.map { 
            isFiltered ? filteredExperiences[$0] : experiences[$0] 
        }
        
        for experience in experiencesToDelete {
            experiences.removeAll { $0.id == experience.id }
        }
        
        updateFilteredExperiences()
        saveData()
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
    
    func deleteCategory(_ category: Category) -> Bool {
        let isUsed = experiences.contains { $0.category == category.name }
        if isUsed {
            return false
        }
        
        categories.removeAll { $0.id == category.id }
        saveData()
        return true
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveData()
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            saveData()
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        saveData()
    }
    
    func completeGoal(_ goal: Goal) {
        var updatedGoal = goal
        updatedGoal.isCompleted = true
        updatedGoal.completedAt = Date()
        updateGoal(updatedGoal)
    }
    
    func canDeleteCategory(_ category: Category) -> Bool {
        return !experiences.contains { $0.category == category.name }
    }
        
    func applyFilters() {
        isFiltered = selectedPeriod != .all || selectedCategory != "All" || !searchText.isEmpty
        updateFilteredExperiences()
    }
    
    func resetFilters() {
        selectedPeriod = .all
        selectedCategory = "All"
        searchText = ""
        isFiltered = false
        updateFilteredExperiences()
    }
    
    private func updateFilteredExperiences() {
        var filtered = experiences
        
        switch selectedPeriod {
        case .today:
            filtered = filtered.filter { Calendar.current.isDateInToday($0.date) }
        case .week:
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            filtered = filtered.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            filtered = filtered.filter { $0.date >= monthAgo }
        case .year:
            let yearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
            filtered = filtered.filter { $0.date >= yearAgo }
        case .custom:
            filtered = filtered.filter { $0.date >= customDateFrom && $0.date <= customDateTo }
        case .all:
            break
        }
        
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { experience in
                experience.title.localizedCaseInsensitiveContains(searchText) ||
                (experience.note?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        filteredExperiences = filtered
    }
        
    func getTotalCount() -> Int {
        return experiences.count
    }
    
    func getCountForPeriod(days: Int) -> Int {
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return experiences.filter { $0.date >= startDate }.count
    }
    
    func getMostActiveDay(for period: StatisticsPeriod) -> (date: Date, count: Int)? {
        let filteredExperiences = getExperiencesForPeriod(period)
        
        let groupedByDate = Dictionary(grouping: filteredExperiences) { experience in
            Calendar.current.startOfDay(for: experience.date)
        }
        
        return groupedByDate.max { $0.value.count < $1.value.count }
            .map { (date: $0.key, count: $0.value.count) }
    }
    
    func getTopCategory(for period: StatisticsPeriod) -> (category: String, count: Int)? {
        let filteredExperiences = getExperiencesForPeriod(period)
        
        let groupedByCategory = Dictionary(grouping: filteredExperiences) { experience in
            experience.category ?? "Uncategorized"
        }
        
        return groupedByCategory.max { first, second in
            if first.value.count == second.value.count {
                return first.key > second.key
            }
            return first.value.count < second.value.count
        }.map { (category: $0.key, count: $0.value.count) }
    }
    
    private func getExperiencesForPeriod(_ period: StatisticsPeriod) -> [FirstExperience] {
        let days: Int
        switch period {
        case .week: days = 7
        case .month: days = 30
        case .year: days = 365
        }
        
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return experiences.filter { $0.date >= startDate }
    }
        
    private func saveData() {
        let encoder = JSONEncoder()
        
        if let experiencesData = try? encoder.encode(experiences) {
            UserDefaults.standard.set(experiencesData, forKey: "experiences")
        }
        
        if let categoriesData = try? encoder.encode(categories) {
            UserDefaults.standard.set(categoriesData, forKey: "categories")
        }
        
        if let goalsData = try? encoder.encode(goals) {
            UserDefaults.standard.set(goalsData, forKey: "goals")
        }
    }
    
    private func loadData() {
        let decoder = JSONDecoder()
        
        if let experiencesData = UserDefaults.standard.data(forKey: "experiences"),
           let decodedExperiences = try? decoder.decode([FirstExperience].self, from: experiencesData) {
            experiences = decodedExperiences.sorted { $0.createdAt > $1.createdAt }
        } 
        
        if let categoriesData = UserDefaults.standard.data(forKey: "categories"),
           let decodedCategories = try? decoder.decode([Category].self, from: categoriesData) {
            categories = decodedCategories.sorted { $0.name < $1.name }
        }
        
        if let goalsData = UserDefaults.standard.data(forKey: "goals"),
           let decodedGoals = try? decoder.decode([Goal].self, from: goalsData) {
            goals = decodedGoals.sorted { $0.createdAt > $1.createdAt }
        }
    }
}

enum FilterPeriod: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case custom = "Custom Range"
}

enum StatisticsPeriod: String, CaseIterable {
    case week = "7 days"
    case month = "30 days"
    case year = "Year"
}
