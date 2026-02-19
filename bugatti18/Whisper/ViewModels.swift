import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var isLoading = true
    @Published var selectedTab = 0
    
    init() {
        checkFirstLaunch()
        loadApp()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }
    
    private func loadApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading = false
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        isFirstLaunch = false
    }
}

class TodayViewModel: ObservableObject {
    @Published var dailyEntry: DailyEntry
    @Published var habits: [Habit] = []
    @Published var newGratitudeText = ""
    @Published var dailyQuestionAnswer = ""
    @Published var showingMoodSelection = false
    @Published var showingCelebration = false
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        self.dailyEntry = DailyEntry()
        loadTodayData()
        loadHabits()
        setupDailyQuestion()
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }
    
    var todayProgress: Double {
        let totalTasks = habits.count + 3
        let completedTasks = dailyEntry.completedHabits.count +
                           (dailyEntry.selectedMoods.isEmpty ? 0 : 1) +
                           (dailyEntry.gratitudeEntries.isEmpty ? 0 : 1) +
                           (dailyEntry.dailyQuestion?.answer.isEmpty == false ? 1 : 0)
        
        return totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
    }
    
    func selectMood(_ mood: Mood) {
        HapticManager.selection()
        
        if dailyEntry.selectedMoods.contains(where: { $0.id == mood.id }) {
            dailyEntry.selectedMoods.removeAll { $0.id == mood.id }
        } else if dailyEntry.selectedMoods.count < 3 {
            dailyEntry.selectedMoods.append(mood)
        }
        
        saveTodayData()
        
        if !dailyEntry.selectedMoods.isEmpty {
            showingMoodSelection = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showingMoodSelection = false
            }
        }
    }
    
    func addGratitudeEntry() {
        guard !newGratitudeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        HapticManager.notification(.success)
        
        let entry = GratitudeEntry(text: newGratitudeText.trimmingCharacters(in: .whitespacesAndNewlines))
        dailyEntry.gratitudeEntries.append(entry)
        newGratitudeText = ""
        
        saveTodayData()
        showCelebration()
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }
    
    func toggleHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].toggleCompletion()
            
            if habits[index].isCompletedToday {
                HapticManager.notification(.success)
                if !dailyEntry.completedHabits.contains(habit.id) {
                    dailyEntry.completedHabits.append(habit.id)
                }
            } else {
                HapticManager.impact(.light)
                dailyEntry.completedHabits.removeAll { $0 == habit.id }
            }
            
            saveHabits()
            saveTodayData()
            showCelebration()
        }
    }
    
    func saveDailyQuestionAnswer() {
        dailyEntry.dailyQuestion?.answer = dailyQuestionAnswer
        saveTodayData()
    }
    
    private func setupDailyQuestion() {
        if dailyEntry.dailyQuestion == nil {
            let randomQuestion = DailyQuestion.questions.randomElement() ?? "What made you happy today?"
            dailyEntry.dailyQuestion = DailyQuestion(question: randomQuestion)
            dailyQuestionAnswer = dailyEntry.dailyQuestion?.answer ?? ""
        } else {
            dailyQuestionAnswer = dailyEntry.dailyQuestion?.answer ?? ""
        }
    }
    
    private func showCelebration() {
        showingCelebration = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showingCelebration = false
        }
    }
    
    private func loadTodayData() {
        let today = Calendar.current.startOfDay(for: Date())
        let key = "dailyEntry_\(today.timeIntervalSince1970)"
        
        if let data = userDefaults.data(forKey: key),
           let entry = try? JSONDecoder().decode(DailyEntry.self, from: data) {
            dailyEntry = entry
        }
    }
    
    private func saveTodayData() {
        let today = Calendar.current.startOfDay(for: Date())
        let key = "dailyEntry_\(today.timeIntervalSince1970)"
        
        if let data = try? JSONEncoder().encode(dailyEntry) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    private func loadHabits() {
        if let data = userDefaults.data(forKey: "habits"),
           let loadedHabits = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = loadedHabits
        } else {
            habits = [
                Habit(name: "Morning walk", category: .body, icon: "figure.walk", frequency: .daily),
                Habit(name: "Meditation", category: .soul, icon: "leaf.fill", frequency: .daily),
                Habit(name: "Breathing practice", category: .soul, icon: "wind", frequency: .daily)
            ]
            saveHabits()
        }
    }
    
    private func saveHabits() {
        if let data = try? JSONEncoder().encode(habits) {
            userDefaults.set(data, forKey: "habits")
        }
    }
    
    func reloadHabits() {
        loadHabits()
    }
}

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var showingAddHabit = false
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadHabits()
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        saveHabits()
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
        }
    }
    
    func toggleHabit(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].toggleCompletion()
        saveHabits()
        updateTodayDailyEntry(habitId: habit.id, isCompleted: habits[index].isCompletedToday)
    }
    
    private func updateTodayDailyEntry(habitId: UUID, isCompleted: Bool) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let key = "dailyEntry_\(today.timeIntervalSince1970)"
        
        var entry: DailyEntry
        if let data = userDefaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode(DailyEntry.self, from: data) {
            entry = decoded
        } else {
            entry = DailyEntry(date: today)
        }
        
        if isCompleted {
            if !entry.completedHabits.contains(habitId) {
                entry.completedHabits.append(habitId)
            }
        } else {
            entry.completedHabits.removeAll { $0 == habitId }
        }
        
        if let data = try? JSONEncoder().encode(entry) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func reloadHabits() {
        loadHabits()
    }
    
    private func loadHabits() {
        if let data = userDefaults.data(forKey: "habits"),
           let loadedHabits = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = loadedHabits
        }
    }
    
    private func saveHabits() {
        if let data = try? JSONEncoder().encode(habits) {
            userDefaults.set(data, forKey: "habits")
        }
    }
}

class HistoryViewModel: ObservableObject {
    @Published var dailyEntries: [DailyEntry] = []
    @Published var selectedDate = Date()
    @Published var selectedEntry: DailyEntry?
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadHistory()
    }
    
    func loadHistory() {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -30, to: endDate) ?? endDate
        
        var entries: [DailyEntry] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            let key = "dailyEntry_\(calendar.startOfDay(for: currentDate).timeIntervalSince1970)"
            
            if let data = userDefaults.data(forKey: key),
               let entry = try? JSONDecoder().decode(DailyEntry.self, from: data) {
                entries.append(entry)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        dailyEntries = entries.sorted { $0.date > $1.date }
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
        selectedEntry = dailyEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}
