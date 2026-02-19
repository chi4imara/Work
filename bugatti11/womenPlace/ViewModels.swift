import Foundation
import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var isShowingSplash: Bool = true
    
    init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
    
    func hideSplash() {
        isShowingSplash = false
    }
}

class DailyEntryViewModel: ObservableObject {
    @Published var currentEntry: DailyEntry
    @Published var dailyEntries: [DailyEntry] = []
    @Published var habits: [TaskG] = []
    
    private let calendar = Calendar.current
    
    init() {
        let today = calendar.startOfDay(for: Date())
        self.currentEntry = DailyEntry(
            date: today,
            dailyQuestion: DailyQuestions.randomQuestion()
        )
        loadData()
    }
    
    var greeting: String {
        let hour = calendar.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good morning. Ready to start the day?"
        case 12..<17:
            return "Good afternoon. How is your day going?"
        case 17..<21:
            return "Good evening. Time to reflect on today?"
        default:
            return "Good night. Rest well and dream sweetly."
        }
    }
    
    func addTask(_ task: TaskG) {
        if task.isHabit {
            habits.append(task)
        } else {
            currentEntry.tasks.append(task)
        }
        saveData()
    }
    
    func toggleTaskCompletion(_ task: TaskG) {
        if task.isHabit {
            if let index = habits.firstIndex(where: { $0.id == task.id }) {
                habits[index].isCompleted.toggle()
                
                if habits[index].isCompleted {
                    let today = calendar.startOfDay(for: Date())
                    if !habits[index].completedDates.contains(where: { calendar.isDate($0, inSameDayAs: today) }) {
                        habits[index].completedDates.append(today)
                    }
                }
            }
        } else {
            if let index = currentEntry.tasks.firstIndex(where: { $0.id == task.id }) {
                currentEntry.tasks[index].isCompleted.toggle()
            }
        }
        saveData()
    }
    
    func deleteTask(_ task: TaskG) {
        if task.isHabit {
            habits.removeAll { $0.id == task.id }
        } else {
            currentEntry.tasks.removeAll { $0.id == task.id }
        }
        saveData()
    }
    
    func setMood(_ mood: Mood) {
        currentEntry.mood = mood
        saveData()
    }
    
    func updateDailyAnswer(_ answer: String) {
        currentEntry.dailyAnswer = answer
        saveData()
    }
    
    func getEntry(for date: Date) -> DailyEntry? {
        let dayStart = calendar.startOfDay(for: date)
        return dailyEntries.first { calendar.isDate($0.date, inSameDayAs: dayStart) }
    }
    
    func loadSampleData() {
        let (entries, sampleHabits) = SampleData.generate(calendar: calendar)
        dailyEntries = entries
        habits = sampleHabits
        let today = calendar.startOfDay(for: Date())
        if let todayEntry = entries.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            currentEntry = todayEntry
        } else {
            currentEntry = DailyEntry(
                date: today,
                dailyQuestion: DailyQuestions.randomQuestion()
            )
        }
        saveData()
    }
    
    private func saveData() {
        if let index = dailyEntries.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: currentEntry.date) }) {
            dailyEntries[index] = currentEntry
        } else {
            dailyEntries.append(currentEntry)
        }
        
        if let entriesData = try? JSONEncoder().encode(dailyEntries) {
            UserDefaults.standard.set(entriesData, forKey: "dailyEntries")
        }
        
        if let habitsData = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(habitsData, forKey: "habits")
        }
    }
    
    private func loadData() {
        if let entriesData = UserDefaults.standard.data(forKey: "dailyEntries"),
           let entries = try? JSONDecoder().decode([DailyEntry].self, from: entriesData) {
            dailyEntries = entries
            
            let today = calendar.startOfDay(for: Date())
            if let todayEntry = entries.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
                currentEntry = todayEntry
            }
        }
        
        if let habitsData = UserDefaults.standard.data(forKey: "habits"),
           let loadedHabits = try? JSONDecoder().decode([TaskG].self, from: habitsData) {
            habits = loadedHabits
            
            let today = calendar.startOfDay(for: Date())
            for i in habits.indices {
                let wasCompletedToday = habits[i].completedDates.contains { calendar.isDate($0, inSameDayAs: today) }
                habits[i].isCompleted = wasCompletedToday
            }
        }
    }
}

enum SampleData {
    static func generate(calendar: Calendar) -> (entries: [DailyEntry], habits: [TaskG]) {
        let today = calendar.startOfDay(for: Date())
        var entries: [DailyEntry] = []
        let questions = DailyQuestions.questions
        let moods: [Mood] = [.happy, .excited, .neutral, .happy, .tired, .neutral, .happy]
        
        for dayOffset in (0..<7).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let dayStart = calendar.startOfDay(for: date)
            let questionIndex = dayOffset % questions.count
            
            var tasks: [TaskG] = [
                TaskG(title: "Morning routine", isCompleted: dayOffset < 3, isHabit: false, icon: "sunrise.fill"),
                TaskG(title: "Review goals", isCompleted: dayOffset < 5, isHabit: false, icon: "target"),
                TaskG(title: "Evening reflection", isCompleted: dayOffset < 2, isHabit: false, icon: "moon.fill")
            ]
            
            let progress = dayOffset == 0 ? 0.0 : (Double(7 - dayOffset) / 7.0) * 0.8 + 0.2
            let completedCount = Int(round(progress * Double(tasks.count)))
            for i in 0..<tasks.count {
                tasks[i].isCompleted = i < completedCount
            }
            
            let entry = DailyEntry(
                date: dayStart,
                mood: moods[dayOffset % moods.count],
                tasks: tasks,
                dailyQuestion: questions[questionIndex],
                dailyAnswer: dayOffset == 0 ? "" : "Sample reflection for this day."
            )
            entries.append(entry)
        }
        
        var habit1 = TaskG(title: "Morning walk", isCompleted: false, isHabit: true, icon: "figure.walk", repeatDaily: true)
        var habit2 = TaskG(title: "Read 10 pages", isCompleted: false, isHabit: true, icon: "book.fill", repeatDaily: true)
        var habit3 = TaskG(title: "Drink water", isCompleted: false, isHabit: true, icon: "drop.fill", repeatDaily: true)
        
        for dayOffset in 0..<5 {
            if let d = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                habit1.completedDates.append(calendar.startOfDay(for: d))
            }
        }
        for dayOffset in 0..<3 {
            if let d = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                habit2.completedDates.append(calendar.startOfDay(for: d))
            }
        }
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today) {
            habit3.completedDates.append(calendar.startOfDay(for: yesterday))
        }
        habit1.isCompleted = habit1.completedDates.contains { calendar.isDate($0, inSameDayAs: today) }
        habit2.isCompleted = habit2.completedDates.contains { calendar.isDate($0, inSameDayAs: today) }
        habit3.isCompleted = habit3.completedDates.contains { calendar.isDate($0, inSameDayAs: today) }
        
        return (entries, [habit1, habit2, habit3])
    }
}
