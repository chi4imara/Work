import Foundation
import Combine

class EventStore: ObservableObject {
    @Published var events: [Event] = []
    
    private let userDefaults = UserDefaults.standard
    private let eventsKey = "SavedEvents"
    
    init() {
        loadEvents()
    }
        
    func addEvent(_ event: Event) {
        events.append(event)
        sortEventsByDate()
        saveEvents()
    }
    
    func updateEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            sortEventsByDate()
            saveEvents()
        }
    }
    
    func deleteEvent(_ event: Event) {
        events.removeAll { $0.id == event.id }
        saveEvents()
    }
    
    func getEvent(by id: UUID) -> Event? {
        return events.first { $0.id == id }
    }
    
    /// Replaces current events with sample data for testing.
    func loadSampleData() {
        events = SampleData.generate()
        saveEvents()
    }
        
    private func sortEventsByDate() {
        events.sort { $0.date > $1.date }
    }
    
    private func saveEvents() {
        do {
            let data = try JSONEncoder().encode(events)
            userDefaults.set(data, forKey: eventsKey)
        } catch {
            print("Failed to save events: \(error)")
        }
    }
    
    private func loadEvents() {
        guard let data = userDefaults.data(forKey: eventsKey) else { return }
        
        do {
            events = try JSONDecoder().decode([Event].self, from: data)
            sortEventsByDate()
        } catch {
            print("Failed to load events: \(error)")
            events = []
        }
    }
}
