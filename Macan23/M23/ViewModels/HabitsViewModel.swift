import Foundation
import SwiftUI
import Combine

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var filter = HabitFilter()
    @Published var selectedCategory: HabitCategory? = nil
    
    private let userDefaults = UserDefaults.standard
    private let habitsKey = "SavedHabits"
    
    init() {
        loadHabits()
    }
    
    var filteredHabits: [Habit] {
        var result = habits
        
        if let selectedCategory = selectedCategory {
            result = result.filter { $0.category == selectedCategory }
        } else if !filter.selectedCategories.isEmpty {
            result = result.filter { filter.selectedCategories.contains($0.category) }
        }
        
        if !filter.searchText.isEmpty {
            result = result.filter { habit in
                habit.name.localizedCaseInsensitiveContains(filter.searchText) ||
                habit.category.displayName.localizedCaseInsensitiveContains(filter.searchText) ||
                habit.description.localizedCaseInsensitiveContains(filter.searchText)
            }
        }
        
        if !filter.timeFrom.isEmpty || !filter.timeTo.isEmpty {
            result = result.filter { habit in
                let habitTime = timeStringToMinutes(habit.time)
                let fromTime = filter.timeFrom.isEmpty ? 0 : timeStringToMinutes(filter.timeFrom)
                let toTime = filter.timeTo.isEmpty ? 1440 : timeStringToMinutes(filter.timeTo)
                
                return habitTime >= fromTime && habitTime <= toTime
            }
        }
        
        return result.sorted { $0.createdAt < $1.createdAt }
    }
    
    var categoryCounts: [HabitCategory: Int] {
        var counts: [HabitCategory: Int] = [:]
        for category in HabitCategory.allCases {
            counts[category] = habits.filter { $0.category == category }.count
        }
        return counts
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        saveHabits()
    }
    
    func getHabit(by id: UUID) -> Habit? {
        return habits.first { $0.id == id }
    }
    
    func applyFilter(_ newFilter: HabitFilter) {
        filter = newFilter
        selectedCategory = nil
    }
    
    func selectCategory(_ category: HabitCategory?) {
        selectedCategory = category
        filter.reset()
    }
    
    func resetFilters() {
        filter.reset()
        selectedCategory = nil
    }
    
    private func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            userDefaults.set(encoded, forKey: habitsKey)
        }
    }
    
    private func loadHabits() {
        if let data = userDefaults.data(forKey: habitsKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = decoded
        }
    }
    
    private func timeStringToMinutes(_ timeString: String) -> Int {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hours = Int(components[0]),
              let minutes = Int(components[1]) else {
            return 0
        }
        return hours * 60 + minutes
    }
}
