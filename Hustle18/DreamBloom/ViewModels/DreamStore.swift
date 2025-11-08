import Foundation
import Combine

class DreamStore: ObservableObject {
    @Published var dreams: [Dream] = []
    @Published var customTags: [Tag] = []
    @Published var selectedTags: Set<String> = []
    @Published var searchText: String = ""
    @Published var sortOrder: SortOrder = .newestFirst
    @Published var hasCompletedOnboarding: Bool = false
    
    enum SortOrder: String, CaseIterable {
        case newestFirst = "Newest First"
        case oldestFirst = "Oldest First"
    }
    
    private let dreamsKey = "SavedDreams"
    private let customTagsKey = "CustomTags"
    private let onboardingKey = "HasCompletedOnboarding"
    private let filtersKey = "SavedFilters"
    
    init() {
        loadData()
        loadOnboardingStatus()
        loadFilters()
    }
    
    func addDream(_ dream: Dream) {
        dreams.append(dream)
        saveDreams()
    }
    
    func updateDream(_ dream: Dream) {
        if let index = dreams.firstIndex(where: { $0.id == dream.id }) {
            dreams[index] = dream
            saveDreams()
        }
    }
    
    func deleteDream(_ dream: Dream) {
        dreams.removeAll { $0.id == dream.id }
        saveDreams()
    }
    
    func toggleFavorite(for dreamId: UUID) {
        if let index = dreams.firstIndex(where: { $0.id == dreamId }) {
            dreams[index].toggleFavorite()
            saveDreams()
        }
    }
    
    func addCustomTag(_ tagName: String) {
        let trimmedName = tagName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        let allTagNames = (Tag.defaultTags.map { $0.name } + customTags.map { $0.name }).map { $0.lowercased() }
        
        if !trimmedName.isEmpty && !allTagNames.contains(trimmedName) {
            let newTag = Tag(name: trimmedName, isDefault: false)
            customTags.append(newTag)
            saveCustomTags()
        }
    }
    
    var allTags: [Tag] {
        return Tag.defaultTags + customTags
    }
    
    var filteredDreams: [Dream] {
        var filtered = dreams
        
        if !selectedTags.isEmpty {
            filtered = filtered.filter { dream in
                !Set(dream.tags).isDisjoint(with: selectedTags)
            }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { dream in
                dream.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch sortOrder {
        case .newestFirst:
            filtered.sort { $0.date > $1.date }
        case .oldestFirst:
            filtered.sort { $0.date < $1.date }
        }
        
        return filtered
    }
    
    var favoriteDreams: [Dream] {
        return dreams
            .filter { $0.isFavorite }
            .sorted { ($0.favoriteDate ?? Date.distantPast) > ($1.favoriteDate ?? Date.distantPast) }
    }
    
    var totalDreamsCount: Int {
        return dreams.count
    }
    
    var tagStatistics: [String: Int] {
        var stats: [String: Int] = [:]
        for dream in dreams {
            for tag in dream.tags {
                stats[tag, default: 0] += 1
            }
        }
        return stats
    }
    
    var mostFrequentTag: String? {
        return tagStatistics.max(by: { $0.value < $1.value })?.key
    }
    
    var averageDreamsPerWeek: Double {
        guard !dreams.isEmpty else { return 0 }
        
        let sortedDates = dreams.map { $0.date }.sorted()
        guard let firstDate = sortedDates.first,
              let lastDate = sortedDates.last else { return 0 }
        
        let timeInterval = lastDate.timeIntervalSince(firstDate)
        let weeks = timeInterval / (7 * 24 * 60 * 60)
        
        return weeks > 0 ? Double(dreams.count) / weeks : Double(dreams.count)
    }
    
    func monthlyDreamCounts() -> [(month: String, count: Int)] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        var monthlyCounts: [String: Int] = [:]
        
        for dream in dreams {
            let monthKey = formatter.string(from: dream.date)
            monthlyCounts[monthKey, default: 0] += 1
        }
        
        return monthlyCounts.map { (month: $0.key, count: $0.value) }
            .sorted { $0.month < $1.month }
    }
    
    func resetFilters() {
        selectedTags.removeAll()
        searchText = ""
        sortOrder = .newestFirst
        saveFilters()
    }
    
    func applyFilters() {
        saveFilters()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
    
    private func saveDreams() {
        if let encoded = try? JSONEncoder().encode(dreams) {
            UserDefaults.standard.set(encoded, forKey: dreamsKey)
        }
    }
    
    private func saveCustomTags() {
        if let encoded = try? JSONEncoder().encode(customTags) {
            UserDefaults.standard.set(encoded, forKey: customTagsKey)
        }
    }
    
    private func saveFilters() {
        let filters = [
            "selectedTags": Array(selectedTags),
            "searchText": searchText,
            "sortOrder": sortOrder.rawValue
        ] as [String: Any]
        
        UserDefaults.standard.set(filters, forKey: filtersKey)
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: dreamsKey),
           let decoded = try? JSONDecoder().decode([Dream].self, from: data) {
            dreams = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: customTagsKey),
           let decoded = try? JSONDecoder().decode([Tag].self, from: data) {
            customTags = decoded
        }
    }
    
    private func loadOnboardingStatus() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    private func loadFilters() {
        if let filters = UserDefaults.standard.dictionary(forKey: filtersKey) {
            if let tags = filters["selectedTags"] as? [String] {
                selectedTags = Set(tags)
            }
            if let search = filters["searchText"] as? String {
                searchText = search
            }
            if let sort = filters["sortOrder"] as? String,
               let sortOrder = SortOrder(rawValue: sort) {
                self.sortOrder = sortOrder
            }
        }
    }
}
