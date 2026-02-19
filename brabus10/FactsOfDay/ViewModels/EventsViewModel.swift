import Foundation
import SwiftUI
import Combine

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var selectedDate = Date()
    @Published var use24HourFormat = false
    
    private let userDefaults = UserDefaults.standard
    private let eventsKey = "SavedEvents"
    private let timeFormatKey = "use24HourFormat"
    
    init() {
        loadEvents()
        loadSettings()
    }
    
    func addEvent(_ event: Event) {
        events.append(event)
        saveEvents()
    }
    
    func updateEvent(_ updatedEvent: Event) {
        if let index = events.firstIndex(where: { $0.id == updatedEvent.id }) {
            events[index] = Event(id: updatedEvent.id, text: updatedEvent.text, timestamp: events[index].timestamp)
            saveEvents()
        }
    }
    
    func deleteEvent(_ event: Event) {
        events.removeAll { $0.id == event.id }
        saveEvents()
    }
    
    func clearAllEvents() {
        events.removeAll()
        saveEvents()
    }
    
    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            userDefaults.set(encoded, forKey: eventsKey)
        }
    }
    
    private func loadEvents() {
        if let data = userDefaults.data(forKey: eventsKey),
           let decoded = try? JSONDecoder().decode([Event].self, from: data) {
            events = decoded.sorted { $0.timestamp > $1.timestamp }
        }
    }
    
    func toggleTimeFormat() {
        use24HourFormat.toggle()
        userDefaults.set(use24HourFormat, forKey: timeFormatKey)
    }
    
    private func loadSettings() {
        use24HourFormat = userDefaults.bool(forKey: timeFormatKey)
    }
    
    var todayEvents: [Event] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        return events.filter { event in
            event.timestamp >= today && event.timestamp < tomorrow
        }.sorted { $0.timestamp < $1.timestamp }
    }
    
    func eventsForDate(_ date: Date) -> [Event] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return events.filter { event in
            event.timestamp >= startOfDay && event.timestamp < endOfDay
        }.sorted { $0.timestamp < $1.timestamp }
    }
    
    func hasEventsForDate(_ date: Date) -> Bool {
        !eventsForDate(date).isEmpty
    }
    
    func getEvent(by id: UUID) -> Event? {
        events.first { $0.id == id }
    }
    
    var archivedEvents: [Event] {
        let today = Calendar.current.startOfDay(for: Date())
        return events.filter { event in
            event.timestamp < today
        }.sorted { $0.timestamp > $1.timestamp }
    }
    
    var eventsByMonth: [String: [Event]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        var grouped: [String: [Event]] = [:]
        for event in events {
            let key = formatter.string(from: event.timestamp)
            grouped[key, default: []].append(event)
        }
        
        return grouped
    }
    
    var totalEventsCount: Int {
        events.count
    }
    
    var eventsThisWeek: Int {
        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
        
        return events.filter { $0.timestamp >= weekAgo }.count
    }
    
    var eventsThisMonth: Int {
        let calendar = Calendar.current
        let now = Date()
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
        
        return events.filter { $0.timestamp >= monthAgo }.count
    }
    
    var mostActiveDay: (date: Date, count: Int)? {
        let grouped = Dictionary(grouping: events) { event in
            Calendar.current.startOfDay(for: event.timestamp)
        }
        
        if let maxEntry = grouped.max(by: { $0.value.count < $1.value.count }) {
            return (date: maxEntry.key, count: maxEntry.value.count)
        }
        return nil
    }
}
