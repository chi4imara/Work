import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var currentTab: TabType = .today
    @Published var showOnboarding = true
    @Published var showSplash = true
    
    @Published var habits: [Habit] = []
    @Published var dailyProgress: [DailyProgress] = []
    @Published var selectedMoods: [Mood] = []
    @Published var todayChallenge: Challenge?
    @Published var meditationCompleted = false
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
        setupTodayChallenge()
        setupSaveOnBackground()
    }
    
    private func setupSaveOnBackground() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.saveAllData()
        }
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.saveAllData()
        }
    }
    
    private func loadData() {
        showOnboarding = !userDefaults.bool(forKey: "hasCompletedOnboarding")
        loadHabits()
        loadDailyProgress()
    }
    
    private func saveData() {
        saveHabits()
        saveDailyProgress()
    }
    
    private var habitsKey: String { "habits" }
    private var dailyProgressKey: String { "dailyProgress" }
    
    private func loadHabits() {
        guard let data = userDefaults.data(forKey: habitsKey) else { return }
        if let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            self.habits = decoded
        }
    }
    
    private func saveHabits() {
        guard let data = try? JSONEncoder().encode(habits) else { return }
        userDefaults.set(data, forKey: habitsKey)
    }
    
    private func loadDailyProgress() {
        guard let data = userDefaults.data(forKey: dailyProgressKey) else { return }
        if let decoded = try? JSONDecoder().decode([DailyProgress].self, from: data) {
            self.dailyProgress = decoded
            restoreTodayState()
        }
    }
    
    private func saveDailyProgress() {
        guard let data = try? JSONEncoder().encode(dailyProgress) else { return }
        userDefaults.set(data, forKey: dailyProgressKey)
    }
    
    private func restoreTodayState() {
        guard let today = todayProgress else { return }
        selectedMoods = today.selectedMoods
        meditationCompleted = today.meditationCompleted
        if var challenge = todayChallenge {
            challenge.isCompleted = !today.completedChallenges.isEmpty
            todayChallenge = challenge
        }
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: "hasCompletedOnboarding")
        showOnboarding = false
    }
    
    func hideSplash() {
        showSplash = false
    }
    
    private func setupTodayChallenge() {
        let challenges = Challenge.dailyChallenges
        todayChallenge = challenges.randomElement()
    }
    
    func selectMoods(_ moods: [Mood]) {
        selectedMoods = moods
        updateTodayProgress()
    }
    
    func completeMeditation() {
        meditationCompleted = true
        updateTodayProgress()
    }
    
    func completeChallenge() {
        if var challenge = todayChallenge {
            challenge.isCompleted = true
            todayChallenge = challenge
        }
        updateTodayProgress()
    }
    
    private func updateTodayProgress() {
        let today = Calendar.current.startOfDay(for: Date())
        let completedHabitIds = habits.filter { $0.isCompletedToday }.map { $0.id }
        
        if let index = dailyProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyProgress[index].selectedMoods = selectedMoods
            dailyProgress[index].meditationCompleted = meditationCompleted
            dailyProgress[index].completedHabits = completedHabitIds
            if todayChallenge?.isCompleted == true, let id = todayChallenge?.id {
                dailyProgress[index].completedChallenges = [id]
            }
        } else {
            let newProgress = DailyProgress(
                date: today,
                selectedMoods: selectedMoods,
                completedHabits: completedHabitIds,
                completedChallenges: todayChallenge?.isCompleted == true ? [todayChallenge!.id] : [],
                meditationCompleted: meditationCompleted
            )
            dailyProgress.append(newProgress)
        }
        saveDailyProgress()
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }
    
    func toggleHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            let today = Date()
            if habits[index].isCompletedToday {
                habits[index].completedDates.removeAll { Calendar.current.isDate($0, inSameDayAs: today) }
            } else {
                habits[index].completedDates.append(today)
            }
            updateTodayProgress()
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
    }
    
    func saveAllData() {
        saveHabits()
        saveDailyProgress()
    }
    
    func loadAllData() {
        loadHabits()
        loadDailyProgress()
    }
    
    func loadSampleData() {
        let firstChallenge = Challenge.dailyChallenges[0]
        let (sampleHabits, sampleProgress) = SampleData.generate(challengeId: firstChallenge.id)
        
        habits = sampleHabits
        dailyProgress = sampleProgress
        todayChallenge = firstChallenge
        restoreTodayState()
        saveAllData()
    }
    
    func progress(for date: Date) -> DailyProgress? {
        dailyProgress.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    var todayProgress: DailyProgress? {
        let today = Calendar.current.startOfDay(for: Date())
        return dailyProgress.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    var activeHabits: [Habit] {
        habits.filter { $0.isActive }
    }
    
    var greetingText: String {
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
}

enum TabType: String, CaseIterable {
    case today = "Today"
    case habits = "Habits"
    case history = "History"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .today: return "house.fill"
        case .habits: return "list.bullet"
        case .history: return "calendar"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}
