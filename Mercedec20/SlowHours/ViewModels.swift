import Foundation
import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var userProfile = UserProfile.defaultProfile
    @Published var activities: [Activity] = []
    @Published var events: [LeisureEvent] = []
    @Published var progressData = ProgressData()
    @Published var selectedTab = 0
    @Published var showSplash = true
    @Published var showAddActivitySheet = false
    @Published var hasCompletedOnboarding = false
    
    init() {
        loadData()
        FontManager.shared.registerFonts()
    }
    
    func loadData() {
        let storage = UserDefaultsStorage.shared
        
        hasCompletedOnboarding = storage.loadHasCompletedOnboarding()
        
        if let profile = storage.loadUserProfile() {
            userProfile = profile
        }
        
        if let activities = storage.loadActivities() {
            self.activities = activities
        }
        
        if let events = storage.loadEvents() {
            self.events = events
        }
        
        if let progress = storage.loadProgressData() {
            progressData = progress
        }
    }
    
    func saveData() {
        let storage = UserDefaultsStorage.shared
        storage.saveUserProfile(userProfile)
        storage.saveActivities(activities)
        storage.saveEvents(events)
        storage.saveProgressData(progressData)
        storage.saveHasCompletedOnboarding(hasCompletedOnboarding)
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaultsStorage.shared.saveHasCompletedOnboarding(true)
    }
    
    func loadSampleData() {
        let data = SampleData.load()
        activities = data.activities
        events = data.events
        progressData = data.progressData
        saveData()
    }
}

class HomeViewModel: ObservableObject {
    @Published var recommendedActivities: [Activity] = []
    @Published var selectedFilters: ActivityFilters = ActivityFilters()
    
    private let appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        updateRecommendations()
    }
    
    func updateRecommendations() {
        var filtered = appViewModel.activities
        
        if !selectedFilters.activityTypes.isEmpty {
            filtered = filtered.filter { selectedFilters.activityTypes.contains($0.type) }
        }
        
        if !selectedFilters.goals.isEmpty {
            filtered = filtered.filter { selectedFilters.goals.contains($0.goal) }
        }
        
        if selectedFilters.maxDuration > 0 {
            filtered = filtered.filter { $0.duration <= selectedFilters.maxDuration }
        }
        
        recommendedActivities = Array(filtered.shuffled().prefix(6))
    }
    
    func scheduleActivity(_ activity: Activity, for date: Date = Date()) {
        let event = LeisureEvent(activity: activity, scheduledDate: date, status: .scheduled)
        appViewModel.events.append(event)
        appViewModel.saveData()
    }
    
    func resetFilters() {
        selectedFilters = ActivityFilters()
        updateRecommendations()
    }
}

struct ActivityFilters {
    var activityTypes: Set<ActivityType> = []
    var goals: Set<ActivityGoal> = []
    var maxDuration: Int = 0
}

class EventsViewModel: ObservableObject {
    @Published var sortOption: EventSortOption = .date
    @Published var filterStatus: EventStatus?
    @Published var showingAddNote = false
    @Published var selectedEvent: LeisureEvent?
    
    private let appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var sortedEvents: [LeisureEvent] {
        var events = appViewModel.events
        
        if let status = filterStatus {
            events = events.filter { $0.status == status }
        }
        
        switch sortOption {
        case .date:
            events.sort { $0.scheduledDate > $1.scheduledDate }
        case .type:
            events.sort { $0.activity.type.rawValue < $1.activity.type.rawValue }
        case .status:
            events.sort { $0.status.rawValue < $1.status.rawValue }
        }
        
        return events
    }
    
    func updateEventStatus(_ event: LeisureEvent, status: EventStatus) {
        if let index = appViewModel.events.firstIndex(where: { $0.id == event.id }) {
            appViewModel.events[index].status = status
            
            if status == .completed {
                updateProgress()
            }
            
            appViewModel.saveData()
        }
    }
    
    func addNote(to event: LeisureEvent, note: String, rating: Int?) {
        if let index = appViewModel.events.firstIndex(where: { $0.id == event.id }) {
            appViewModel.events[index].notes = note
            appViewModel.events[index].rating = rating
            appViewModel.saveData()
        }
    }
    
    func deleteEvent(_ event: LeisureEvent) {
        appViewModel.events.removeAll { $0.id == event.id }
        appViewModel.saveData()
    }
    
    private func updateProgress() {
        appViewModel.progressData.totalActivitiesCompleted += 1
        checkAchievements()
    }
    
    private func checkAchievements() {
        var achievements = appViewModel.progressData.achievements
        
        if appViewModel.progressData.totalActivitiesCompleted == 1 {
            if let index = Achievement.availableAchievements.firstIndex(where: { $0.title == "First Step" }) {
                var achievement = Achievement.availableAchievements[index]
                achievement.isUnlocked = true
                achievement.dateEarned = Date()
                achievements.append(achievement)
            }
        }
        
        appViewModel.progressData.achievements = achievements
    }
}

enum EventSortOption: String, CaseIterable {
    case date = "Date"
    case type = "Type"
    case status = "Status"
}

class ProgressViewModel: ObservableObject {
    @Published var selectedTimeRange: TimeRange = .week
    @Published var showingMoodEntry = false
    
    private let appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    var completedEventsCount: Int {
        appViewModel.events.filter { $0.status == .completed }.count
    }
    
    var currentStreak: Int {
        calculateCurrentStreak()
    }
    
    var weeklyActivityData: [ChartDataPoint] {
        generateWeeklyData()
    }
    
    var moodData: [ChartDataPoint] {
        generateMoodData()
    }
    
    var unlockedAchievements: [Achievement] {
        appViewModel.progressData.achievements.filter { $0.isUnlocked }
    }
    
    func addMoodEntry(_ mood: MoodLevel) {
        let today = Calendar.current.startOfDay(for: Date())
        appViewModel.progressData.moodTracking[today] = mood
        appViewModel.saveData()
    }
    
    private func calculateCurrentStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var currentDate = today
        
        while true {
            let hasActivity = appViewModel.events.contains { event in
                calendar.isDate(event.scheduledDate, inSameDayAs: currentDate) && event.status == .completed
            }
            
            if hasActivity {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func generateWeeklyData() -> [ChartDataPoint] {
        let calendar = Calendar.current
        let today = Date()
        var data: [ChartDataPoint] = []
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: today) ?? today
            let dayStart = calendar.startOfDay(for: date)
            
            let count = appViewModel.events.filter { event in
                calendar.isDate(event.scheduledDate, inSameDayAs: dayStart) && event.status == .completed
            }.count
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            
            data.append(ChartDataPoint(
                label: formatter.string(from: date),
                value: Double(count),
                date: dayStart
            ))
        }
        
        return data.reversed()
    }
    
    private func generateMoodData() -> [ChartDataPoint] {
        let calendar = Calendar.current
        let today = Date()
        var data: [ChartDataPoint] = []
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: today) ?? today
            let dayStart = calendar.startOfDay(for: date)
            
            let mood = appViewModel.progressData.moodTracking[dayStart] ?? .neutral
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            
            data.append(ChartDataPoint(
                label: formatter.string(from: date),
                value: Double(mood.value),
                date: dayStart
            ))
        }
        
        return data.reversed()
    }
}

enum TimeRange: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let date: Date
}

class ProfileViewModel: ObservableObject {
    @Published var isEditing = false
    @Published var tempProfile: UserProfile
    
    private let appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        self.tempProfile = appViewModel.userProfile
    }
    
    func startEditing() {
        tempProfile = appViewModel.userProfile
        isEditing = true
    }
    
    func saveChanges() {
        appViewModel.userProfile = tempProfile
        appViewModel.saveData()
        isEditing = false
    }
    
    func cancelEditing() {
        tempProfile = appViewModel.userProfile
        isEditing = false
    }
}

class AddActivityViewModel: ObservableObject {
    @Published var name = ""
    @Published var selectedType: ActivityType = .walk
    @Published var duration = 60
    @Published var selectedGoal: ActivityGoal = .relaxation
    @Published var description = ""
    @Published var notes = ""
    @Published var scheduledDate = Date()
    
    private let appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    func saveActivity() {
        let activity = Activity(
            name: name,
            type: selectedType,
            duration: duration,
            goal: selectedGoal,
            description: description
        )
        
        let event = LeisureEvent(
            activity: activity,
            scheduledDate: scheduledDate,
            status: .scheduled,
            notes: notes
        )
        
        appViewModel.activities.append(activity)
        appViewModel.events.append(event)
        appViewModel.saveData()
        
        resetForm()
    }
    
    func resetForm() {
        name = ""
        selectedType = .walk
        duration = 60
        selectedGoal = .relaxation
        description = ""
        notes = ""
        scheduledDate = Date()
    }
    
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        duration > 0
    }
}
