import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showSplash = true
    @Published var selectedTab = 0
    
    init() {
        checkFirstLaunch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showSplash = false
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        isFirstLaunch = false
    }
}

class TodayViewModel: ObservableObject {
    @Published var todayEntry: DailyEntry
    @Published var habits: [Habit] = []
    @Published var selectedEnergyLevels: [EnergyLevel] = []
    @Published var currentRitual: MiniRitual?
    @Published var todayChallenge: DailyChallenge
    @Published var isRitualActive = false
    @Published var ritualTimeRemaining = 0
    @Published var showRitualComplete = false
    @Published var showChallengeComplete = false
    
    private var ritualTimer: Timer?
    private let storage = StorageManager.shared
    
    init() {
        self.todayEntry = storage.loadTodayEntry() ?? DailyEntry(date: Date())
        self.todayChallenge = DailyChallenge.challenges.randomElement() ?? DailyChallenge.challenges[0]
        self.selectedEnergyLevels = todayEntry.energyLevels
        self.habits = storage.loadHabits()
    }
    
    func refreshFromStorage() {
        if let saved = storage.loadTodayEntry() {
            todayEntry = saved
            selectedEnergyLevels = saved.energyLevels
        }
        habits = storage.loadHabits()
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }
    
    var progressPercentage: Double {
        var completed = 0.0
        let total = 4.0
        
        if !selectedEnergyLevels.isEmpty { completed += 1 }
        if todayEntry.completedRitual { completed += 1 }
        if todayEntry.completedChallenge { completed += 1 }
        if !todayEntry.completedHabits.isEmpty { completed += 1 }
        
        return completed / total
    }
    
    func selectEnergyLevels(_ levels: [EnergyLevel]) {
        selectedEnergyLevels = levels
        todayEntry.energyLevels = levels
        saveTodayData()
    }
    
    func startMorningRitual() {
        currentRitual = MiniRitual.morningRituals.randomElement()
        startRitual()
    }
    
    func startEveningRitual() {
        currentRitual = MiniRitual.eveningRituals.randomElement()
        startRitual()
    }
    
    private func startRitual() {
        guard let ritual = currentRitual else { return }
        isRitualActive = true
        ritualTimeRemaining = ritual.duration * 60 
        
        ritualTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.ritualTimeRemaining > 0 {
                self.ritualTimeRemaining -= 1
            } else {
                self.completeRitual()
            }
        }
    }
    
    func completeRitual() {
        ritualTimer?.invalidate()
        ritualTimer = nil
        isRitualActive = false
        todayEntry.completedRitual = true
        showRitualComplete = true
        saveTodayData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showRitualComplete = false
        }
    }
    
    func completeChallenge() {
        todayEntry.completedChallenge = true
        showChallengeComplete = true
        saveTodayData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showChallengeComplete = false
        }
    }
    
    func toggleHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            if habits[index].isCompleted {
                habits[index].completedDates.removeAll { Calendar.current.isDateInToday($0) }
                todayEntry.completedHabits.removeAll { $0 == habit.id }
            } else {
                habits[index].completedDates.append(Date())
                todayEntry.completedHabits.append(habit.id)
            }
            saveHabits()
            saveTodayData()
        }
    }
    
    private func saveTodayData() {
        storage.saveTodayEntry(todayEntry)
    }
    
    private func saveHabits() {
        storage.saveHabits(habits)
    }
}

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var showingAddHabit = false
    
    private let storage = StorageManager.shared
    
    init() {
        habits = storage.loadHabits()
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        storage.saveHabits(habits)
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        storage.saveHabits(habits)
    }
    
    func deleteHabit(id: UUID) {
        habits.removeAll { $0.id == id }
        storage.saveHabits(habits)
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            storage.saveHabits(habits)
        }
    }
    
    func habit(byId id: UUID) -> Habit? {
        habits.first { $0.id == id }
    }
    
    func refreshFromStorage() {
        habits = storage.loadHabits()
    }
}

class HistoryViewModel: ObservableObject {
    @Published var entries: [DailyEntry] = []
    @Published var selectedDate = Date()
    @Published var selectedEntry: DailyEntry?
    
    private let storage = StorageManager.shared
    
    init() {
        refreshFromStorage()
    }
    
    func getEntry(for date: Date) -> DailyEntry? {
        storage.getEntry(for: date)
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        selectedEntry = getEntry(for: date)
    }
    
    func refreshFromStorage() {
        var list = storage.loadDailyEntries()
        if let today = storage.loadTodayEntry(), !list.contains(where: { Calendar.current.isDateInToday($0.date) }) {
            list.append(today)
        }
        entries = list
    }
}

class AddHabitViewModel: ObservableObject {
    @Published var name = ""
    @Published var selectedCategory = HabitCategory.morningRituals
    @Published var selectedFrequency = HabitFrequency.daily
    @Published var selectedIcon = "heart.fill"
    @Published var whyImportant = ""
    
    let availableIcons = [
        "heart.fill", "star.fill", "sun.max.fill", "moon.fill",
        "leaf.fill", "flame.fill", "drop.fill", "bolt.fill",
        "book.fill", "pencil", "target", "checkmark.circle.fill"
    ]
    
    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func createHabit() -> Habit {
        return Habit(
            name: name.trimmingCharacters(in: .whitespaces),
            category: selectedCategory,
            frequency: selectedFrequency,
            icon: selectedIcon,
            whyImportant: whyImportant.trimmingCharacters(in: .whitespaces)
        )
    }
    
    func reset() {
        name = ""
        selectedCategory = .morningRituals
        selectedFrequency = .daily
        selectedIcon = "heart.fill"
        whyImportant = ""
    }
}
