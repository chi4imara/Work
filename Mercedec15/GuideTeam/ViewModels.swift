import Foundation
import SwiftUI
import Combine

private enum StorageKeys {
    static let salons = "spabuddy_salons"
    static let bookings = "spabuddy_bookings"
    static let profile = "spabuddy_profile"
}

class SPAListViewModel: ObservableObject {
    @Published var salons: [SPASalon] = []
    @Published var filteredSalons: [SPASalon] = []
    @Published var filterOptions = FilterOptions()
    @Published var isLoading = false
    @Published var searchText = ""
    
    init() {
        loadSalons()
        applyFilters()
    }
    
    func loadSalons() {
        guard let data = UserDefaults.standard.data(forKey: StorageKeys.salons),
              let decoded = try? JSONDecoder().decode([SPASalon].self, from: data) else {
            salons = []
            return
        }
        salons = decoded
    }
    
    func loadSampleData() {
        salons = SampleData.salons
        saveSalons()
    }
    
    func saveSalons() {
        guard let data = try? JSONEncoder().encode(salons) else { return }
        UserDefaults.standard.set(data, forKey: StorageKeys.salons)
    }
    
    func addSalon(_ salon: SPASalon) {
        salons.insert(salon, at: 0)
        applyFilters()
        saveSalons()
    }
    
    func removeSalon(at offsets: IndexSet) {
        salons.remove(atOffsets: offsets)
        applyFilters()
        saveSalons()
    }
    
    func applyFilters() {
        filteredSalons = salons.filter { salon in
            filterOptions.matches(salon: salon) &&
            (searchText.isEmpty || salon.name.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    func updateFilters(_ newFilters: FilterOptions) {
        filterOptions = newFilters
        applyFilters()
    }
    
    func resetFilters() {
        filterOptions = FilterOptions()
        searchText = ""
        applyFilters()
    }
    
    func refreshSalons() {
        isLoading = true
        loadSalons()
        applyFilters()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isLoading = false
        }
    }
}

class BookingsViewModel: ObservableObject {
    @Published var bookings: [Booking] = []
    @Published var isLoading = false
    
    init() {
        loadBookings()
    }
    
    func loadBookings() {
        guard let data = UserDefaults.standard.data(forKey: StorageKeys.bookings),
              let decoded = try? JSONDecoder().decode([Booking].self, from: data) else {
            bookings = []
            return
        }
        bookings = decoded
    }
    
    func loadSampleData() {
        bookings = SampleData.bookings(calendar: .current)
        saveBookings()
    }
    
    func saveBookings() {
        guard let data = try? JSONEncoder().encode(bookings) else { return }
        UserDefaults.standard.set(data, forKey: StorageKeys.bookings)
    }
    
    func cancelBooking(_ booking: Booking) {
        if let index = bookings.firstIndex(where: { $0.id == booking.id }) {
            bookings[index].status = .cancelled
            saveBookings()
        }
    }
    
    func addBooking(_ booking: Booking) {
        bookings.insert(booking, at: 0)
        saveBookings()
    }
    
    func updateBooking(_ booking: Booking) {
        if let index = bookings.firstIndex(where: { $0.id == booking.id }) {
            bookings[index] = booking
            saveBookings()
        }
    }
}

class ProgressViewModel: ObservableObject {
    @Published var statistics: VisitStatistics
    @Published var isLoading = false
    
    private let visitGoalDefault = 4
    
    init() {
        statistics = ProgressViewModel.emptyStatistics()
    }
    
    func recalculate(bookings: [Booking], visitGoal: Int = 4) {
        let completed = bookings.filter { $0.status == .completed }
        let totalVisits = completed.count
        let calendar = Calendar.current
        let now = Date()
        let currentMonthVisits = completed.filter { calendar.isDate($0.date, equalTo: now, toGranularity: .month) }.count
        let goal = visitGoal > 0 ? visitGoal : visitGoalDefault
        let visitGoalProgress = min(1.0, Double(currentMonthVisits) / Double(goal))
        let averageSpending = completed.isEmpty ? 0.0 : completed.map(\.price).reduce(0, +) / Double(completed.count)
        let uniqueSalons = Set(completed.map(\.salonName)).count
        
        let achievements: [Achievement] = [
            Achievement(
                title: "Regular Visitor",
                description: "Complete 10 visits",
                icon: "star.fill",
                isUnlocked: totalVisits >= 10,
                progress: min(1.0, Double(totalVisits) / 10.0)
            ),
            Achievement(
                title: "Spa Explorer",
                description: "Visit 3 different salons",
                icon: "map.fill",
                isUnlocked: uniqueSalons >= 3,
                progress: min(1.0, Double(uniqueSalons) / 3.0)
            ),
            Achievement(
                title: "Wellness Warrior",
                description: "Complete 25 visits",
                icon: "heart.fill",
                isUnlocked: totalVisits >= 25,
                progress: min(1.0, Double(totalVisits) / 25.0)
            ),
            Achievement(
                title: "Relaxation Master",
                description: "Try all service types",
                icon: "leaf.fill",
                isUnlocked: false,
                progress: 0.0
            )
        ]
        
        statistics = VisitStatistics(
            totalVisits: totalVisits,
            currentMonthVisits: currentMonthVisits,
            favoriteService: nil,
            averageSpending: averageSpending,
            visitGoalProgress: visitGoalProgress,
            achievements: achievements
        )
    }
    
    static func emptyStatistics() -> VisitStatistics {
        VisitStatistics(
            totalVisits: 0,
            currentMonthVisits: 0,
            favoriteService: nil,
            averageSpending: 0.0,
            visitGoalProgress: 0.0,
            achievements: [
                Achievement(title: "Regular Visitor", description: "Complete 10 visits", icon: "star.fill", isUnlocked: false, progress: 0),
                Achievement(title: "Spa Explorer", description: "Visit 3 different salons", icon: "map.fill", isUnlocked: false, progress: 0),
                Achievement(title: "Wellness Warrior", description: "Complete 25 visits", icon: "heart.fill", isUnlocked: false, progress: 0),
                Achievement(title: "Relaxation Master", description: "Try all service types", icon: "leaf.fill", isUnlocked: false, progress: 0)
            ]
        )
    }
    
    func refreshStatistics(bookings: [Booking], visitGoal: Int = 4) {
        isLoading = true
        recalculate(bookings: bookings, visitGoal: visitGoal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isLoading = false
        }
    }
}

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile
    @Published var isLoading = false
    @Published var isSaving = false
    
    init() {
        profile = UserProfile()
        loadProfile()
    }
    
    func loadProfile() {
        guard let data = UserDefaults.standard.data(forKey: StorageKeys.profile),
              let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            profile = UserProfile()
            return
        }
        profile = decoded
    }
    
    func loadSampleData() {
        profile = SampleData.profile
        saveProfile()
    }
    
    func saveProfile() {
        isSaving = true
        guard let data = try? JSONEncoder().encode(profile) else {
            isSaving = false
            return
        }
        UserDefaults.standard.set(data, forKey: StorageKeys.profile)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isSaving = false
        }
    }
    
    func updateNotificationSettings(_ enabled: Bool) {
        profile.notificationsEnabled = enabled
        saveProfile()
    }
    
    func setAvatar(filename: String?) {
        profile.avatarURL = filename
        saveProfile()
    }
}
