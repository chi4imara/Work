import Foundation
import SwiftUI

class EventStore: ObservableObject {
    @Published var events: [Event] = []
    @Published var selectedDate = Date()
    @Published var selectedMonth = Date()
    @Published var searchText = ""
    @Published var selectedEventTypes: Set<EventType> = Set(EventType.allCases) {
        didSet {
            saveFilters()
        }
    }
    @Published var sortOption: SortOption = .nearestFirst {
        didSet {
            saveFilters()
        }
    }
    
    enum SortOption: String, CaseIterable {
        case nearestFirst = "Nearest First"
        case oldestFirst = "Oldest First"
        case byType = "By Type"
        case byName = "By Name"
    }
    
    private let userDefaults = UserDefaults.standard
    private let eventsKey = AppConstants.UserDefaultsKeys.savedEvents
    private let selectedEventTypesKey = AppConstants.UserDefaultsKeys.selectedEventTypes
    private let sortOptionKey = AppConstants.UserDefaultsKeys.sortOption
    
    init() {
        loadEvents()
        loadFilters()
        generateSampleEvents()
    }
    
    func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            userDefaults.set(encoded, forKey: eventsKey)
        }
    }
    
    func loadEvents() {
        if let data = userDefaults.data(forKey: eventsKey),
           let decoded = try? JSONDecoder().decode([Event].self, from: data) {
            events = decoded
        }
    }
    
    func loadFilters() {
        if let data = userDefaults.data(forKey: selectedEventTypesKey),
           let decoded = try? JSONDecoder().decode(Set<EventType>.self, from: data) {
            selectedEventTypes = decoded
        } else {
            selectedEventTypes = Set(EventType.allCases)
        }
        
        if let sortOptionString = userDefaults.string(forKey: sortOptionKey),
           let sortOption = SortOption(rawValue: sortOptionString) {
            self.sortOption = sortOption
        }
    }
    
    func saveFilters() {
        if let encoded = try? JSONEncoder().encode(selectedEventTypes) {
            userDefaults.set(encoded, forKey: selectedEventTypesKey)
        }
        
        userDefaults.set(sortOption.rawValue, forKey: sortOptionKey)
    }
    
    func addEvent(_ event: Event) {
        events.append(event)
        saveEvents()
    }
    
    func updateEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveEvents()
        }
    }
    
    func deleteEvent(_ event: Event) {
        events.removeAll { $0.id == event.id }
        saveEvents()
    }
    
    func toggleFavorite(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].isFavorite.toggle()
            saveEvents()
        }
    }
    
    func archiveEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index].isActive = false
            saveEvents()
        }
    }
    
    var activeEvents: [Event] {
        events.filter { $0.isActive }
    }
    
    var favoriteEvents: [Event] {
        activeEvents.filter { $0.isFavorite }
            .sorted { $0.date < $1.date }
    }
    
    var filteredEvents: [Event] {
        let filtered = activeEvents.filter { event in
            let matchesSearch = searchText.isEmpty || event.title.localizedCaseInsensitiveContains(searchText)
            let matchesType = selectedEventTypes.contains(event.type)
            return matchesSearch && matchesType
        }
        
        return sortEvents(filtered)
    }
    
    func eventsForDate(_ date: Date) -> [Event] {
        let calendar = Calendar.current
        return activeEvents.filter { event in
            calendar.isDate(event.date, inSameDayAs: date) &&
            selectedEventTypes.contains(event.type)
        }.sorted { event1, event2 in
            let typePriority = [EventType.birthday, .anniversary, .holiday, .other]
            let priority1 = typePriority.firstIndex(of: event1.type) ?? 0
            let priority2 = typePriority.firstIndex(of: event2.type) ?? 0
            return priority1 < priority2
        }
    }
    
    func eventsForMonth(_ date: Date) -> [Event] {
        let calendar = Calendar.current
        return activeEvents.filter { event in
            calendar.isDate(event.date, equalTo: date, toGranularity: .month) &&
            selectedEventTypes.contains(event.type)
        }
    }
    
    private func sortEvents(_ events: [Event]) -> [Event] {
        switch sortOption {
        case .nearestFirst:
            return events.sorted { $0.date < $1.date }
        case .oldestFirst:
            return events.sorted { $0.date > $1.date }
        case .byType:
            return events.sorted { $0.type.rawValue < $1.type.rawValue }
        case .byName:
            return events.sorted { $0.title < $1.title }
        }
    }
    
    private func generateSampleEvents() {
        if events.isEmpty {
            let sampleEvents = [
                Event(title: "John's Birthday", type: .birthday, date: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(), note: "Don't forget the cake!", isFavorite: true),
                Event(title: "Wedding Anniversary", type: .anniversary, date: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(), note: "Book restaurant", giftIdeas: ["Flowers", "Jewelry"], isFavorite: true),
                Event(title: "International Coffee Day", type: .holiday, date: Calendar.current.date(byAdding: .day, value: 15, to: Date()) ?? Date(), note: "Try new coffee shop"),
                Event(title: "Team Meeting", type: .other, date: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(), note: "Quarterly review"),
                Event(title: "Mom's Birthday", type: .birthday, date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), note: "Call in the morning", isFavorite: true)
            ]
            
            events = sampleEvents
            saveEvents()
        }
    }
}
