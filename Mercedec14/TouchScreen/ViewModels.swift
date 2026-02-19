import Foundation
import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    @Published var currentUser: User
    @Published var isOnboardingCompleted: Bool
    @Published var isSplashScreenShown: Bool
    @Published var selectedTab: Int = 0
    @Published var masters: [Master] = []
    @Published var sampleDataLoadedTrigger: UUID?
    
    init() {
        self.currentUser = UserDefaultsStorage.load(User.self, forKey: UserDefaultsStorage.Key.currentUser) ?? User()
        self.isOnboardingCompleted = UserDefaults.standard.bool(forKey: UserDefaultsStorage.Key.onboardingCompleted)
        self.isSplashScreenShown = false
        self.masters = UserDefaultsStorage.load([Master].self, forKey: UserDefaultsStorage.Key.masters) ?? []
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
        UserDefaults.standard.set(true, forKey: UserDefaultsStorage.Key.onboardingCompleted)
    }
    
    func completeSplashScreen() {
        isSplashScreenShown = true
    }
    
    func addMaster(_ master: Master) {
        masters.append(master)
        saveMasters()
    }
    
    func saveMasters() {
        UserDefaultsStorage.save(masters, forKey: UserDefaultsStorage.Key.masters)
    }
    
    func saveCurrentUser() {
        UserDefaultsStorage.save(currentUser, forKey: UserDefaultsStorage.Key.currentUser)
    }
    
    func loadSampleData() {
        masters = SampleData.masters
        saveMasters()
        let catalog = SampleData.catalogSessions(masters: masters)
        UserDefaultsStorage.save(catalog, forKey: UserDefaultsStorage.Key.catalogSessions)
        let booked = SampleData.bookedSessions(masters: masters)
        UserDefaultsStorage.save(booked, forKey: UserDefaultsStorage.Key.bookedSessions)
        UserDefaultsStorage.save(SampleData.stressLevels, forKey: UserDefaultsStorage.Key.stressLevels)
        sampleDataLoadedTrigger = UUID()
    }
}

class MainScreenViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var filteredSessions: [Session] = []
    @Published var selectedMassageTypes: Set<MassageType> = []
    @Published var selectedDurations: Set<SessionDuration> = []
    @Published var maxPrice: Double = 200.0
    @Published var minRating: Double = 0.0
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    init() {
        sessions = UserDefaultsStorage.load([Session].self, forKey: UserDefaultsStorage.Key.catalogSessions) ?? []
        applyFilters()
    }
    
    func seedCatalogIfNeeded(masters: [Master]) {
        guard sessions.isEmpty, masters.count >= 3 else { return }
        sessions = SampleData.catalogSessions(masters: masters)
        saveSessions()
        applyFilters()
    }
    
    func reloadFromStorage() {
        sessions = UserDefaultsStorage.load([Session].self, forKey: UserDefaultsStorage.Key.catalogSessions) ?? []
        applyFilters()
    }
    
    func addSessionToCatalog(_ session: Session) {
        sessions.append(session)
        saveSessions()
        applyFilters()
    }
    
    func removeSessionFromCatalog(_ session: Session) {
        sessions.removeAll { $0.id == session.id }
        saveSessions()
        applyFilters()
    }
    
    private func saveSessions() {
        UserDefaultsStorage.save(sessions, forKey: UserDefaultsStorage.Key.catalogSessions)
    }
    
    func applyFilters() {
        var filtered = sessions
        
        if !selectedMassageTypes.isEmpty {
            filtered = filtered.filter { selectedMassageTypes.contains($0.type) }
        }
        
        if !selectedDurations.isEmpty {
            filtered = filtered.filter { selectedDurations.contains($0.duration) }
        }
        
        filtered = filtered.filter { $0.price <= maxPrice }
        filtered = filtered.filter { $0.master.rating >= minRating }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.master.name.localizedCaseInsensitiveContains(searchText) ||
                $0.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredSessions = filtered.sorted { $0.date < $1.date }
    }
    
    func refreshRecommendations() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.applyFilters()
            self.isLoading = false
        }
    }
    
    func clearFilters() {
        selectedMassageTypes.removeAll()
        selectedDurations.removeAll()
        maxPrice = 200.0
        minRating = 0.0
        searchText = ""
        applyFilters()
    }
    
    var onBookSession: ((Session) -> Void)?
    
    func bookSession(_ session: Session) {
        onBookSession?(session)
    }
}

class BookingsViewModel: ObservableObject {
    @Published var bookedSessions: [Session] = []
    @Published var selectedSortOption: SortOption = .date
    @Published var selectedFilterStatus: SessionStatus? = nil
    
    enum SortOption: String, CaseIterable {
        case date = "Date"
        case type = "Type"
        case price = "Price"
    }
    
    init() {
        bookedSessions = UserDefaultsStorage.load([Session].self, forKey: UserDefaultsStorage.Key.bookedSessions) ?? []
    }
    
    func seedBookingsIfNeeded(masters: [Master]) {
        guard bookedSessions.isEmpty, masters.count >= 3 else { return }
        bookedSessions = SampleData.bookedSessions(masters: masters)
        saveBookedSessions()
    }
    
    func reloadFromStorage() {
        bookedSessions = UserDefaultsStorage.load([Session].self, forKey: UserDefaultsStorage.Key.bookedSessions) ?? []
    }
    
    private func saveBookedSessions() {
        UserDefaultsStorage.save(bookedSessions, forKey: UserDefaultsStorage.Key.bookedSessions)
    }
    
    var displayedSessions: [Session] {
        var list = bookedSessions
        if let status = selectedFilterStatus {
            list = list.filter { $0.status == status }
        }
        switch selectedSortOption {
        case .date:
            list.sort { $0.date > $1.date }
        case .type:
            list.sort { $0.type.rawValue < $1.type.rawValue }
        case .price:
            list.sort { $0.price > $1.price }
        }
        return list
    }
    
    func addBooking(_ session: Session) {
        bookedSessions.append(session)
        saveBookedSessions()
    }
    
    func applySortingAndFiltering() {
        objectWillChange.send()
    }
    
    func cancelSession(_ session: Session) {
        guard let index = bookedSessions.firstIndex(where: { $0.id == session.id }) else { return }
        bookedSessions[index].status = .cancelled
        saveBookedSessions()
    }
    
    func markAsCompleted(_ session: Session) {
        guard let index = bookedSessions.firstIndex(where: { $0.id == session.id }) else { return }
        bookedSessions[index].status = .completed
        saveBookedSessions()
    }
    
    func rescheduleSession(_ session: Session, newDate: Date) {
        guard let index = bookedSessions.firstIndex(where: { $0.id == session.id }) else { return }
        bookedSessions[index].date = newDate
        saveBookedSessions()
    }
    
    func addNote(_ session: Session, note: String) {
        guard let index = bookedSessions.firstIndex(where: { $0.id == session.id }) else { return }
        bookedSessions[index].notes = note
        saveBookedSessions()
    }
    
    func addRating(_ session: Session, rating: Int, review: String? = nil) {
        guard let index = bookedSessions.firstIndex(where: { $0.id == session.id }) else { return }
        bookedSessions[index].userRating = rating
        if let review = review {
            bookedSessions[index].userReview = review
        }
        saveBookedSessions()
    }
    
    var completedSessions: [Session] {
        bookedSessions.filter { $0.status == .completed }
    }
}

class ProgressViewModel: ObservableObject {
    @Published var progressData: ProgressData
    @Published var achievements: [Achievement]
    @Published var selectedTimeRange: TimeRange = .month
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case threeMonths = "3 Months"
        case year = "Year"
    }
    
    init() {
        self.progressData = ProgressData()
        self.achievements = Achievement.defaultDefinitions.map { def in
            Achievement(
                title: def.title,
                description: def.description,
                icon: def.icon,
                isUnlocked: false,
                progress: 0,
                requiredCount: def.requiredCount,
                currentCount: 0
            )
        }
        if let savedLevels = UserDefaultsStorage.load([StressDataPoint].self, forKey: UserDefaultsStorage.Key.stressLevels) {
            self.progressData.stressLevels = savedLevels
        }
    }
    
    func addStressLevel(_ level: Int, date: Date = Date()) {
        let newDataPoint = StressDataPoint(date: date, level: level)
        progressData.stressLevels.append(newDataPoint)
        saveStressLevels()
    }
    
    private func saveStressLevels() {
        UserDefaultsStorage.save(progressData.stressLevels, forKey: UserDefaultsStorage.Key.stressLevels)
    }
    
    func reloadFromStorage() {
        progressData.stressLevels = UserDefaultsStorage.load([StressDataPoint].self, forKey: UserDefaultsStorage.Key.stressLevels) ?? []
    }
    
    private var stressLevelCutoffDate: Date {
        let calendar = Calendar.current
        let now = Date()
        switch selectedTimeRange {
        case .week:
            return calendar.date(byAdding: .weekOfYear, value: -1, to: now)!
        case .month:
            return calendar.date(byAdding: .month, value: -1, to: now)!
        case .threeMonths:
            return calendar.date(byAdding: .month, value: -3, to: now)!
        case .year:
            return calendar.date(byAdding: .year, value: -1, to: now)!
        }
    }
    
    var displayedStressLevels: [StressDataPoint] {
        progressData.stressLevels.filter { $0.date >= stressLevelCutoffDate }
    }
    
    func updateFromCompletedSessions(_ completed: [Session]) {
        var typeCounts: [MassageType: Int] = [:]
        for type in MassageType.allCases { typeCounts[type] = 0 }
        for session in completed {
            typeCounts[session.type, default: 0] += 1
        }
        progressData.sessionCounts = typeCounts.map { SessionTypeCount(type: $0.key, count: $0.value) }.filter { $0.count > 0 }
        
        let calendar = Calendar.current
        var weekCounts: [String: Int] = [:]
        for session in completed {
            let week = calendar.component(.weekOfYear, from: session.date)
            let year = calendar.component(.year, from: session.date)
            let key = "W\(week)-\(year)"
            weekCounts[key, default: 0] += 1
        }
        progressData.weeklyProgress = weekCounts.sorted(by: { $0.key > $1.key }).prefix(8).map { WeeklyProgress(week: $0.key, sessionsCount: $0.value) }
        
        for i in achievements.indices {
            let def = Achievement.defaultDefinitions[i]
            let current: Int
            switch def.title {
            case "First Steps":
                current = completed.isEmpty ? 0 : 1
            case "Relaxation Master":
                current = progressData.sessionCounts.first { $0.type == .relaxation }?.count ?? 0
            case "Variety Seeker":
                current = Set(completed.map { $0.type }).count
            default:
                current = 0
            }
            let progress = def.requiredCount > 0 ? min(Double(current) / Double(def.requiredCount), 1.0) : 0
            achievements[i] = Achievement(
                id: achievements[i].id,
                title: def.title,
                description: def.description,
                icon: def.icon,
                isUnlocked: current >= def.requiredCount,
                progress: progress,
                requiredCount: def.requiredCount,
                currentCount: current
            )
        }
    }
    
    func checkAchievements() {
        let sessionCounts = progressData.sessionCounts
        let totalCompleted = sessionCounts.reduce(0) { $0 + $1.count }
        let distinctTypesCount = sessionCounts.count
        
        for i in achievements.indices {
            let def = Achievement.defaultDefinitions[i]
            let current: Int
            switch def.title {
            case "First Steps":
                current = totalCompleted >= 1 ? 1 : 0
            case "Relaxation Master":
                current = sessionCounts.first { $0.type == .relaxation }?.count ?? 0
            case "Variety Seeker":
                current = distinctTypesCount
            default:
                current = 0
            }
            let progress = def.requiredCount > 0 ? min(Double(current) / Double(def.requiredCount), 1.0) : 0
            achievements[i] = Achievement(
                id: achievements[i].id,
                title: def.title,
                description: def.description,
                icon: def.icon,
                isUnlocked: current >= def.requiredCount,
                progress: progress,
                requiredCount: def.requiredCount,
                currentCount: current
            )
        }
    }
}

class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isEditing: Bool = false
    @Published var tempUser: User
    
    init(user: User) {
        self.user = user
        self.tempUser = user
    }
    
    func setUser(_ user: User) {
        self.user = user
        self.tempUser = user
    }
    
    func setAvatarPath(_ path: String?) {
        tempUser.avatar = path
    }
    
    func startEditing() {
        tempUser = user
        isEditing = true
    }
    
    func saveChanges() {
        user = tempUser
        isEditing = false
    }
    
    func cancelEditing() {
        tempUser = user
        isEditing = false
    }
    
    func updatePreference(type: MassageType, isSelected: Bool) {
        if isSelected {
            if !tempUser.preferences.preferredTypes.contains(type) {
                tempUser.preferences.preferredTypes.append(type)
            }
        } else {
            tempUser.preferences.preferredTypes.removeAll { $0 == type }
        }
    }
    
    func updateNotificationSetting(keyPath: WritableKeyPath<NotificationSettings, Bool>, value: Bool) {
        tempUser.notificationSettings[keyPath: keyPath] = value
    }
}

class SettingsViewModel: ObservableObject {
    @Published var showingRateApp = false
    @Published var showingPrivacyPolicy = false
    @Published var showingContactEmail = false
    
    func rateApp() {
        showingRateApp = true
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://www.freeprivacypolicy.com/live/9586625d-4b2d-44ae-a9cb-f310af25dba9") {
            UIApplication.shared.open(url)
        }
    }
    
    func contactSupport() {
        if let url = URL(string: "https://forms.gle/q5CiT8Ya3xoMWXQ39") {
            UIApplication.shared.open(url)
        }
    }
}
