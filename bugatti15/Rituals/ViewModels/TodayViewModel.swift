import Foundation
import SwiftUI
import Combine

class TodayViewModel: ObservableObject {
    @Published var todayEntry: DailyEntry
    @Published var selectedMoods: [MoodType] = []
    @Published var dailyGoals: [Goal] = []
    @Published var dailyQuestion: String = ""
    @Published var dailyAnswer: String = ""
    @Published var progressPercentage: Double = 0.0
    @Published var motivationalTips: [String] = []
    
    private let dataManager = DataManager.shared
    
    init() {
        self.todayEntry = DailyEntry()
        loadTodayData()
        setupDailyQuestion()
        setupMotivationalTips()
    }
    
    private func loadTodayData() {
        todayEntry = dataManager.getTodayEntry()
        dailyGoals = dataManager.getTodayGoals()
        selectedMoods = todayEntry.moods.map { $0.type }
        dailyQuestion = todayEntry.dailyQuestion ?? ""
        dailyAnswer = todayEntry.dailyAnswer ?? ""
        updateProgress()
    }
    
    func refresh() {
        loadTodayData()
    }
    
    private func setupDailyQuestion() {
        if todayEntry.dailyQuestion == nil || (todayEntry.dailyQuestion ?? "").isEmpty {
            dailyQuestion = DailyQuestions.randomQuestion()
            todayEntry.setDailyQuestion(dailyQuestion)
        } else {
            dailyQuestion = todayEntry.dailyQuestion ?? ""
            dailyAnswer = todayEntry.dailyAnswer ?? ""
        }
    }
    
    private func setupMotivationalTips() {
        motivationalTips = [
            "You can start with one step - that's already success",
            "You're taking care of yourself - that's important",
            "Small actions create big changes",
            "Every moment is a new beginning",
            "You deserve happiness and joy"
        ]
    }
    
    func addMood(_ moodType: MoodType) {
        if !selectedMoods.contains(moodType) && selectedMoods.count < 3 {
            selectedMoods.append(moodType)
            let mood = Mood(type: moodType)
            todayEntry.addMood(mood)
            dataManager.saveTodayEntry(todayEntry)
        }
    }
    
    func removeMood(_ moodType: MoodType) {
        selectedMoods.removeAll { $0 == moodType }
        todayEntry.moods.removeAll { $0.type == moodType }
        dataManager.saveTodayEntry(todayEntry)
    }
    
    func toggleGoalCompletion(_ goal: Goal) {
        if let index = dailyGoals.firstIndex(where: { $0.id == goal.id }) {
            dailyGoals[index].isCompleted.toggle()
            
            if dailyGoals[index].isCompleted {
                dailyGoals[index].markCompleted()
                todayEntry.completeGoal(goal.id)
            } else {
                dailyGoals[index].markIncomplete()
                todayEntry.uncompleteGoal(goal.id)
            }
            
            dataManager.updateGoal(dailyGoals[index])
            updateProgress()
        }
    }
    
    func saveDailyAnswer(_ answer: String) {
        dailyAnswer = answer
        todayEntry.setDailyQuestion(dailyQuestion, answer: answer)
        dataManager.saveTodayEntry(todayEntry)
    }
    
    private func updateProgress() {
        let totalGoals = dailyGoals.count
        let completedGoals = dailyGoals.filter { $0.isCompleted }.count
        progressPercentage = totalGoals > 0 ? Double(completedGoals) / Double(totalGoals) : 0.0
        todayEntry.updateProgress(totalGoals: totalGoals)
        dataManager.saveTodayEntry(todayEntry)
    }
    
    func getRandomTip() -> String {
        return motivationalTips.randomElement() ?? motivationalTips[0]
    }
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good morning! How's your mood today?"
        case 12..<17:
            return "Good afternoon! How are you feeling?"
        case 17..<22:
            return "Good evening! How was your day?"
        default:
            return "Good night! How are you feeling?"
        }
    }
}
