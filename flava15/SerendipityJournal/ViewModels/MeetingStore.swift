import Foundation
import Combine

class MeetingStore: ObservableObject {
    @Published var meetings: [Meeting] = []
    @Published var filteredMeetings: [Meeting] = []
    @Published var selectedPeriod: FilterPeriod = .all
    @Published var selectedLocation: String = "All locations"
    @Published var searchText: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let meetingsKey = "SavedMeetings"
    
    init() {
        loadMeetings()
        updateFilteredMeetings()
    }

    private func saveMeetings() {
        if let encoded = try? JSONEncoder().encode(meetings) {
            userDefaults.set(encoded, forKey: meetingsKey)
        }
    }
    
    private func loadMeetings() {
        if let data = userDefaults.data(forKey: meetingsKey),
           let decoded = try? JSONDecoder().decode([Meeting].self, from: data) {
            meetings = decoded.sorted { $0.date > $1.date }
        }
    }
    
    func addMeeting(_ meeting: Meeting) {
        meetings.append(meeting)
        meetings.sort { $0.date > $1.date }
        saveMeetings()
        updateFilteredMeetings()
    }
    
    func updateMeeting(_ meeting: Meeting) {
        if let index = meetings.firstIndex(where: { $0.id == meeting.id }) {
            meetings[index] = meeting
            meetings.sort { $0.date > $1.date }
            saveMeetings()
            updateFilteredMeetings()
        }
    }
    
    func deleteMeeting(_ meeting: Meeting) {
        meetings.removeAll { $0.id == meeting.id }
        saveMeetings()
        updateFilteredMeetings()
    }
    
    func deleteMeeting(at indexSet: IndexSet) {
        let meetingsToDelete = indexSet.map { filteredMeetings[$0] }
        for meeting in meetingsToDelete {
            deleteMeeting(meeting)
        }
    }
    
    func updateFilteredMeetings() {
        var filtered = meetings
        
        if let dateRange = selectedPeriod.dateRange() {
            filtered = filtered.filter { meeting in
                meeting.date >= dateRange.start && meeting.date < dateRange.end
            }
        }
        
        if selectedLocation != "All locations" {
            filtered = filtered.filter { meeting in
                meeting.location?.lowercased() == selectedLocation.lowercased()
            }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { meeting in
                meeting.title.localizedCaseInsensitiveContains(searchText) ||
                meeting.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredMeetings = filtered
    }
    
    func applyFilters(period: FilterPeriod, location: String) {
        selectedPeriod = period
        selectedLocation = location
        updateFilteredMeetings()
    }
    
    func resetFilters() {
        selectedPeriod = .all
        selectedLocation = "All locations"
        searchText = ""
        updateFilteredMeetings()
    }
    
    var uniqueLocations: [String] {
        let locations = meetings.compactMap { $0.location }.filter { !$0.isEmpty }
        return Array(Set(locations)).sorted()
    }
    
    var meetingsCount: Int {
        filteredMeetings.count
    }
    
    func meetingsForDate(_ date: Date) -> [Meeting] {
        let calendar = Calendar.current
        return meetings.filter { meeting in
            calendar.isDate(meeting.date, inSameDayAs: date)
        }
    }
    
    func meetingsCountForDate(_ date: Date) -> Int {
        meetingsForDate(date).count
    }
    
    func statisticsForPeriod(_ period: StatisticsPeriod) -> MeetingStatistics {
        let calendar = Calendar.current
        let now = Date()
        let meetings: [Meeting]
        
        switch period {
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            meetings = self.meetings.filter { $0.date >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            meetings = self.meetings.filter { $0.date >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            meetings = self.meetings.filter { $0.date >= yearAgo }
        }
        
        return MeetingStatistics(meetings: meetings, period: period)
    }
}

struct MeetingStatistics {
    let totalMeetings: Int
    let uniqueDays: Int
    let averagePerWeek: Double
    let mostActiveDay: (date: Date, count: Int)?
    let topLocations: [(location: String, count: Int)]
    let weekdayDistribution: [Int]
    
    init(meetings: [Meeting], period: StatisticsPeriod) {
        self.totalMeetings = meetings.count
        
        let calendar = Calendar.current
        let uniqueDates = Set(meetings.map { calendar.startOfDay(for: $0.date) })
        self.uniqueDays = uniqueDates.count
        
        let days = period == .week ? 7 : (period == .month ? 30 : 365)
        self.averagePerWeek = days == 7 ? Double(totalMeetings) : Double(totalMeetings) * 7.0 / Double(days)
        
        let dayGroups = Dictionary(grouping: meetings) { meeting in
            calendar.startOfDay(for: meeting.date)
        }
        let mostActive = dayGroups.max { $0.value.count < $1.value.count }
        self.mostActiveDay = mostActive.map { (date: $0.key, count: $0.value.count) }
        
        let locationGroups = Dictionary(grouping: meetings.compactMap { $0.location?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }) { $0 }
        self.topLocations = locationGroups
            .map { (location: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
            .prefix(5)
            .map { $0 }
        
        var weekdays = Array(repeating: 0, count: 7)
        for meeting in meetings {
            let weekday = (calendar.component(.weekday, from: meeting.date) + 5) % 7 
            weekdays[weekday] += 1
        }
        self.weekdayDistribution = weekdays
    }
}
