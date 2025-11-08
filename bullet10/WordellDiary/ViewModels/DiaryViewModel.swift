import Foundation
import Combine

enum TimeFilter: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case all = "All"
    
    var days: Int? {
        switch self {
        case .week: return 7
        case .month: return 30
        case .all: return nil
        }
    }
}

class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = []
    @Published var filteredEntries: [DiaryEntry] = []
    @Published var selectedMoodFilters: Set<Mood> = []
    @Published var timeFilter: TimeFilter = .all
    @Published var customThemes: [CustomTheme] = []
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "diary_entries"
    private let themesKey = "custom_themes"
    private let moodFiltersKey = "mood_filters"
    private let timeFilterKey = "time_filter"
    
    init() {
        loadEntries()
        loadCustomThemes()
        loadFilters()
        applyFilters()
    }
    
    func addEntry(_ entry: DiaryEntry) {
        if let existingIndex = entries.firstIndex(where: { $0.id == entry.id }) {
            var updatedEntry = entry
            updatedEntry.createdAt = entries[existingIndex].createdAt
            entries[existingIndex] = updatedEntry
        } else {
            if let existingIndex = entries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: entry.date) }) {
                var updatedEntry = entry
                updatedEntry.createdAt = entries[existingIndex].createdAt
                updatedEntry.updatedAt = Date()
                entries[existingIndex] = updatedEntry
            } else {
                entries.append(entry)
            }
        }
        
        sortEntries()
        saveEntries()
        applyFilters()
    }
    
    func deleteEntry(_ entry: DiaryEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
        applyFilters()
    }
    
    func getEntry(for date: Date) -> DiaryEntry? {
        return entries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func applyFilters() {
        var filtered = entries
        
        if let days = timeFilter.days {
            let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
            filtered = filtered.filter { $0.date >= cutoffDate }
        }
        
        if !selectedMoodFilters.isEmpty {
            filtered = filtered.filter { selectedMoodFilters.contains($0.mood) }
        }
        
        filteredEntries = filtered.sorted { $0.date > $1.date }
    }
    
    func setMoodFilters(_ moods: Set<Mood>) {
        selectedMoodFilters = moods
        saveMoodFilters()
        applyFilters()
    }
    
    func setTimeFilter(_ filter: TimeFilter) {
        timeFilter = filter
        saveTimeFilter()
        applyFilters()
    }
    
    func clearFilters() {
        selectedMoodFilters.removeAll()
        timeFilter = .all
        saveMoodFilters()
        saveTimeFilter()
        applyFilters()
    }
    
    func addCustomTheme(_ theme: CustomTheme) {
        customThemes.insert(theme, at: 0)
        saveCustomThemes()
    }
    
    func updateCustomTheme(_ theme: CustomTheme) {
        if let index = customThemes.firstIndex(where: { $0.id == theme.id }) {
            var updatedTheme = theme
            updatedTheme.updatedAt = Date()
            customThemes[index] = updatedTheme
            saveCustomThemes()
        }
    }
    
    func deleteCustomTheme(_ theme: CustomTheme) {
        customThemes.removeAll { $0.id == theme.id }
        saveCustomThemes()
    }
    
    func getStatistics() -> (totalEntries: Int, lastEntryDate: Date?, mostFrequentMood: Mood?) {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentEntries = entries.filter { $0.date >= thirtyDaysAgo }
        
        let totalEntries = recentEntries.count
        let lastEntryDate = recentEntries.max(by: { $0.date < $1.date })?.date
        
        let moodCounts = Dictionary(grouping: recentEntries, by: { $0.mood })
            .mapValues { $0.count }
        
        let mostFrequentMood = moodCounts.max { a, b in
            if a.value == b.value {
                let priority: [Mood] = [.happy, .neutral, .sad, .love, .angry]
                let aIndex = priority.firstIndex(of: a.key) ?? priority.count
                let bIndex = priority.firstIndex(of: b.key) ?? priority.count
                return aIndex > bIndex
            }
            return a.value < b.value
        }?.key
        
        return (totalEntries, lastEntryDate, mostFrequentMood)
    }
    
    func getActivityData() -> [Bool] {
        var activityData: [Bool] = []
        let calendar = Calendar.current
        
        for i in 0..<30 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date()) ?? Date()
            let hasEntry = entries.contains { calendar.isDate($0.date, inSameDayAs: date) }
            activityData.append(hasEntry)
        }
        
        return activityData.reversed()
    }
    
    func getMoodDistribution() -> [Mood: Int] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentEntries = entries.filter { $0.date >= thirtyDaysAgo }
        
        return Dictionary(grouping: recentEntries, by: { $0.mood })
            .mapValues { $0.count }
    }
    
    func getBuiltInThemes() -> [String] {
        return [
            "What made you smile today?",
            "What feeling stood out the most?",
            "What would you like to remember from this day?",
            "What small detail made the day special?",
            "If this day was a photo — what would be in the frame?",
            "What sound defined your day?",
            "What smell brings back today's memory?",
            "What conversation touched you today?",
            "What challenge did you overcome?",
            "What moment of peace did you find?",
            "What made you feel grateful?",
            "What surprised you today?",
            "What would you tell yesterday's you?",
            "What energy surrounded you today?",
            "What color represents your day?"
        ].shuffled()
    }
    
    private func sortEntries() {
        entries.sort { $0.date > $1.date }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([DiaryEntry].self, from: data) {
            entries = decoded
            sortEntries()
        }
    }
    
    private func saveCustomThemes() {
        if let encoded = try? JSONEncoder().encode(customThemes) {
            userDefaults.set(encoded, forKey: themesKey)
        }
    }
    
    private func loadCustomThemes() {
        if let data = userDefaults.data(forKey: themesKey),
           let decoded = try? JSONDecoder().decode([CustomTheme].self, from: data) {
            customThemes = decoded
        }
    }
    
    private func saveMoodFilters() {
        let moodStrings = selectedMoodFilters.map { $0.rawValue }
        userDefaults.set(moodStrings, forKey: moodFiltersKey)
    }
    
    private func saveTimeFilter() {
        userDefaults.set(timeFilter.rawValue, forKey: timeFilterKey)
    }
    
    private func loadFilters() {
        if let moodStrings = userDefaults.array(forKey: moodFiltersKey) as? [String] {
            selectedMoodFilters = Set(moodStrings.compactMap { Mood(rawValue: $0) })
        }
        
        if let timeFilterString = userDefaults.string(forKey: timeFilterKey),
           let filter = TimeFilter(rawValue: timeFilterString) {
            timeFilter = filter
        }
    }
}
