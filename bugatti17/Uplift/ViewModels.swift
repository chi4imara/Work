import Foundation
import SwiftUI
import Combine
import StoreKit

class AppViewModel: ObservableObject {
    @Published var appState = AppState()
    @Published var showSplashScreen = true
    
    private let userDefaultsKey = "AppStateData"
    
    init() {
        loadAppState()
        setupInitialData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showSplashScreen = false
            }
        }
    }
    
    private func loadAppState() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedState = try? JSONDecoder().decode(AppState.self, from: data) {
            appState = decodedState
        }
    }
    
    private func saveAppState() {
        if let encodedData = try? JSONEncoder().encode(appState) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }
    
    private func setupInitialData() {
        if appState.miniChallenges.isEmpty {
            appState.miniChallenges = AppConstants.defaultMiniChallenges
        }
    }
    
    func loadSampleData() {
        appState.habits = SampleData.habits
        appState.miniChallenges = AppConstants.defaultMiniChallenges
        appState.dailyEntries = SampleData.dailyEntries(
            habitIds: appState.habits.map(\.id),
            challengeIds: appState.miniChallenges.map(\.id),
            dailyQuestions: AppConstants.dailyQuestions
        )
        saveAppState()
    }
    
    func completeOnboarding() {
        appState.hasCompletedOnboarding = true
        saveAppState()
    }
    
    func selectTab(_ tab: TabItem) {
        appState.selectedTab = tab
    }
    
    func getTodayProgress() -> Double {
        let today = Calendar.current.startOfDay(for: Date())
        let todayEntry = appState.dailyEntries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
        
        let totalTasks = appState.habits.count + appState.miniChallenges.count
        guard totalTasks > 0 else { return 0 }
        
        let completedHabits = appState.habits.filter { $0.isCompleted }.count
        let completedChallenges = appState.miniChallenges.filter { $0.isCompleted }.count
        
        return Double(completedHabits + completedChallenges) / Double(totalTasks)
    }
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
    
    func getDailyQuestion() -> String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let questionIndex = (dayOfYear - 1) % AppConstants.dailyQuestions.count
        return AppConstants.dailyQuestions[questionIndex]
    }
    
    func addHabit(_ habit: Habit) {
        appState.habits.append(habit)
        saveAppState()
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = appState.habits.firstIndex(where: { $0.id == habit.id }) {
            appState.habits[index] = habit
            saveAppState()
        }
    }
    
    func deleteHabit(_ habitId: UUID) {
        appState.habits.removeAll { $0.id == habitId }
        saveAppState()
    }
    
    func toggleHabitCompletion(_ habitId: UUID) {
        guard let index = appState.habits.firstIndex(where: { $0.id == habitId }) else { return }
        let today = Date()
        let calendar = Calendar.current
        if appState.habits[index].isCompleted {
            appState.habits[index].completedDates.removeAll { calendar.isDate($0, inSameDayAs: today) }
        } else {
            appState.habits[index].completedDates.append(today)
        }
        syncTodayEntryCompletedHabits()
        saveAppState()
    }
    
    func addChallenge(_ challenge: MiniChallenge) {
        appState.miniChallenges.append(challenge)
        saveAppState()
    }
    
    func toggleChallengeCompletion(_ challengeId: UUID) {
        guard let index = appState.miniChallenges.firstIndex(where: { $0.id == challengeId }) else { return }
        appState.miniChallenges[index].isCompleted.toggle()
        appState.miniChallenges[index].completedDate = appState.miniChallenges[index].isCompleted ? Date() : nil
        syncTodayEntryCompletedChallenges()
        saveAppState()
    }
    
    func deleteChallenge(_ challengeId: UUID) {
        appState.miniChallenges.removeAll { $0.id == challengeId }
        saveAppState()
    }
    
    func setTodayMoods(_ moods: [String]) {
        updateTodayEntry { $0.selectedMoods = moods }
    }
    
    func setTodayDailyQuestionAnswer(_ answer: String) {
        updateTodayEntry {
            $0.dailyQuestionAnswer = answer
            $0.dailyQuestion = getDailyQuestion()
        }
    }
    
    private func syncTodayEntryCompletedHabits() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let completedIds = appState.habits.filter { $0.isCompleted }.map { $0.id }
        updateTodayEntry { $0.completedHabits = completedIds }
    }
    
    private func syncTodayEntryCompletedChallenges() {
        let completedIds = appState.miniChallenges.filter { $0.isCompleted }.map { $0.id }
        updateTodayEntry { $0.completedChallenges = completedIds }
    }
    
    private func updateTodayEntry(_ update: (inout DailyEntry) -> Void) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if let index = appState.dailyEntries.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            var entry = appState.dailyEntries[index]
            update(&entry)
            appState.dailyEntries[index] = entry
        } else {
            var entry = DailyEntry(date: today)
            entry.dailyQuestion = getDailyQuestion()
            update(&entry)
            appState.dailyEntries.append(entry)
        }
        saveAppState()
    }
    
    func getEntry(for date: Date) -> DailyEntry? {
        appState.dailyEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func hasActivity(on date: Date) -> Bool {
        guard let entry = getEntry(for: date) else { return false }
        return !entry.selectedMoods.isEmpty ||
            !entry.completedHabits.isEmpty ||
            !entry.completedChallenges.isEmpty ||
            !entry.dailyQuestionAnswer.isEmpty
    }
    
    func getCompletionRate(for date: Date) -> Double {
        guard let entry = getEntry(for: date) else { return 0 }
        let totalTasks = entry.completedHabits.count + entry.completedChallenges.count
        return totalTasks > 0 ? 1.0 : 0.0
    }
}

class MoodViewModel: ObservableObject {
    @Published var selectedMoods: Set<String> = []
    @Published var showThankYouMessage = false
    
    func toggleMood(_ moodId: String) {
        if selectedMoods.contains(moodId) {
            selectedMoods.remove(moodId)
        } else {
            if selectedMoods.count < 3 {
                selectedMoods.insert(moodId)
            }
        }
        
        if !selectedMoods.isEmpty && !showThankYouMessage {
            withAnimation(.easeInOut(duration: 0.5)) {
                showThankYouMessage = true
            }
        } else if selectedMoods.isEmpty {
            showThankYouMessage = false
        }
    }
    
    func isMoodSelected(_ moodId: String) -> Bool {
        selectedMoods.contains(moodId)
    }
}

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var showingAddHabit = false
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }
    
    func toggleHabitCompletion(_ habitId: UUID) {
        if let index = habits.firstIndex(where: { $0.id == habitId }) {
            let today = Date()
            if habits[index].isCompleted {
                habits[index].completedDates.removeAll { Calendar.current.isDate($0, inSameDayAs: today) }
            } else {
                habits[index].completedDates.append(today)
            }
        }
    }
    
    func deleteHabit(_ habitId: UUID) {
        habits.removeAll { $0.id == habitId }
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        }
    }
}

class MiniChallengesViewModel: ObservableObject {
    @Published var challenges: [MiniChallenge] = []
    @Published var showingAddChallenge = false
    
    func addChallenge(_ challenge: MiniChallenge) {
        challenges.append(challenge)
    }
    
    func toggleChallengeCompletion(_ challengeId: UUID) {
        if let index = challenges.firstIndex(where: { $0.id == challengeId }) {
            challenges[index].isCompleted.toggle()
            if challenges[index].isCompleted {
                challenges[index].completedDate = Date()
            } else {
                challenges[index].completedDate = nil
            }
        }
    }
    
    func deleteChallenge(_ challengeId: UUID) {
        challenges.removeAll { $0.id == challengeId }
    }
}

class HistoryViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var dailyEntries: [DailyEntry] = []
    
    func getEntry(for date: Date) -> DailyEntry? {
        return dailyEntries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func hasActivity(on date: Date) -> Bool {
        guard let entry = getEntry(for: date) else { return false }
        return !entry.selectedMoods.isEmpty || 
               !entry.completedHabits.isEmpty || 
               !entry.completedChallenges.isEmpty ||
               !entry.dailyQuestionAnswer.isEmpty
    }
    
    func getCompletionRate(for date: Date) -> Double {
        guard let entry = getEntry(for: date) else { return 0 }
        let totalTasks = entry.completedHabits.count + entry.completedChallenges.count
        return totalTasks > 0 ? 1.0 : 0.0
    }
}

class AddHabitViewModel: ObservableObject {
    @Published var title = ""
    @Published var selectedCategory = AppConstants.habitCategories[0]
    @Published var selectedIcon = "checkmark.circle.fill"
    @Published var selectedFrequency = HabitFrequency.daily
    @Published var note = ""
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func createHabit() -> Habit {
        return Habit(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            category: selectedCategory.id,
            icon: selectedIcon,
            frequency: selectedFrequency,
            note: note.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
    
    func reset() {
        title = ""
        selectedCategory = AppConstants.habitCategories[0]
        selectedIcon = "checkmark.circle.fill"
        selectedFrequency = .daily
        note = ""
    }
}

class SettingsViewModel: ObservableObject {
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                if #available(iOS 14.0, *) {
                    SKStoreReviewController.requestReview(in: scene)
                } else {
                    SKStoreReviewController.requestReview()
                }
            }
        }
    }
}
