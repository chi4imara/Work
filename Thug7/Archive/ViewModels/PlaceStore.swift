import Foundation
import SwiftUI
import Combine

class PlaceStore: ObservableObject {
    static let shared = PlaceStore()
    
    @Published var places: [Place] = []
    @Published var filteredPlaces: [Place] = []
    @Published var selectedCategories: Set<PlaceCategory> = Set(PlaceCategory.allCases)
    @Published var sortOrder: SortOrder = .newestFirst
    @Published var filterPeriod: FilterPeriod = .allTime
    
    enum SortOrder: String, CaseIterable {
        case newestFirst = "Newest First"
        case oldestFirst = "Oldest First"
        case alphabetical = "Alphabetical"
    }
    
    enum FilterPeriod: String, CaseIterable {
        case today = "Today"
        case week = "Week"
        case month = "Month"
        case year = "Year"
        case allTime = "All Time"
    }
    
    private let userDefaults = UserDefaults.standard
    private let placesKey = "SavedPlaces"
    
    private init() {
        loadPlaces()
        applyFilters()
    }
    
    func addPlace(_ place: Place) {
        places.append(place)
        savePlaces()
        applyFilters()
    }
    
    func updatePlace(_ place: Place) {
        if let index = places.firstIndex(where: { $0.id == place.id }) {
            places[index] = place
            savePlaces()
            applyFilters()
        }
    }
    
    func deletePlace(_ place: Place) {
        places.removeAll { $0.id == place.id }
        savePlaces()
        applyFilters()
    }
    
    func applyFilters() {
        var filtered = places
        
        filtered = filtered.filter { selectedCategories.contains($0.category) }
        
        let calendar = Calendar.current
        let now = Date()
        
        switch filterPeriod {
        case .today:
            filtered = filtered.filter { calendar.isDate($0.dateAdded, inSameDayAs: now) }
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            filtered = filtered.filter { $0.dateAdded >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            filtered = filtered.filter { $0.dateAdded >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            filtered = filtered.filter { $0.dateAdded >= yearAgo }
        case .allTime:
            break
        }
        
        switch sortOrder {
        case .newestFirst:
            filtered.sort { $0.dateAdded > $1.dateAdded }
        case .oldestFirst:
            filtered.sort { $0.dateAdded < $1.dateAdded }
        case .alphabetical:
            filtered.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
        
        filteredPlaces = filtered
    }
    
    func resetFilters() {
        selectedCategories = Set(PlaceCategory.allCases)
        filterPeriod = .allTime
        applyFilters()
    }
    
    func placesCount(for category: PlaceCategory) -> Int {
        places.filter { $0.category == category }.count
    }
    
    func totalPlacesCount() -> Int {
        places.count
    }
    
    func lastAddedDate() -> Date? {
        places.max(by: { $0.dateAdded < $1.dateAdded })?.dateAdded
    }
    
    func categoryDistribution() -> [(category: PlaceCategory, count: Int, percentage: Double)] {
        let total = places.count
        guard total > 0 else { return [] }
        
        return PlaceCategory.allCases.map { category in
            let count = placesCount(for: category)
            let percentage = Double(count) / Double(total) * 100
            return (category: category, count: count, percentage: percentage)
        }.filter { $0.count > 0 }
    }
    
    func dailyAdditions(for period: FilterPeriod) -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        default:
            startDate = places.min(by: { $0.dateAdded < $1.dateAdded })?.dateAdded ?? now
        }
        
        let filteredPlaces = places.filter { $0.dateAdded >= startDate }
        let groupedByDate = Dictionary(grouping: filteredPlaces) { place in
            calendar.startOfDay(for: place.dateAdded)
        }
        
        return groupedByDate.map { (date: $0.key, count: $0.value.count) }
            .sorted { $0.date < $1.date }
    }
    
    private func savePlaces() {
        if let encoded = try? JSONEncoder().encode(places) {
            userDefaults.set(encoded, forKey: placesKey)
        }
    }
    
    private func loadPlaces() {
        if let data = userDefaults.data(forKey: placesKey),
           let decoded = try? JSONDecoder().decode([Place].self, from: data) {
            places = decoded
        } else {
            places = Place.sampleData
            savePlaces()
        }
    }
}
