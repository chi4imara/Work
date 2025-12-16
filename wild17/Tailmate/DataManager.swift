import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var events: [PetEvent] = []
    @Published var pet: Pet = Pet()
    @Published var filter: EventFilter = EventFilter()
    @Published var hasCompletedOnboarding: Bool = false
    
    private let eventsKey = "pet_events"
    private let petKey = "pet_profile"
    private let filterKey = "event_filter"
    private let onboardingKey = "completed_onboarding"
    
    private init() {
        loadData()
    }
    
    func saveData() {
        saveEvents()
        savePet()
        saveFilter()
        saveOnboardingStatus()
    }
    
    private func loadData() {
        loadEvents()
        loadPet()
        loadFilter()
        loadOnboardingStatus()
    }
    
    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: eventsKey)
        }
    }
    
    private func loadEvents() {
        if let data = UserDefaults.standard.data(forKey: eventsKey),
           let decoded = try? JSONDecoder().decode([PetEvent].self, from: data) {
            events = decoded
        }
    }
    
    private func savePet() {
        if let encoded = try? JSONEncoder().encode(pet) {
            UserDefaults.standard.set(encoded, forKey: petKey)
        }
    }
    
    private func loadPet() {
        if let data = UserDefaults.standard.data(forKey: petKey),
           let decoded = try? JSONDecoder().decode(Pet.self, from: data) {
            pet = decoded
        }
    }
    
    private func saveFilter() {
        if let encoded = try? JSONEncoder().encode(filter) {
            UserDefaults.standard.set(encoded, forKey: filterKey)
        }
    }
    
    private func loadFilter() {
        if let data = UserDefaults.standard.data(forKey: filterKey),
           let decoded = try? JSONDecoder().decode(EventFilter.self, from: data) {
            filter = decoded
        }
    }
    
    private func saveOnboardingStatus() {
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: onboardingKey)
    }
    
    private func loadOnboardingStatus() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    func addEvent(_ event: PetEvent) {
        events.append(event)
        saveData()
    }
    
    func updateEvent(_ event: PetEvent) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
            saveData()
        }
    }
    
    func deleteEvent(_ event: PetEvent) {
        events.removeAll { $0.id == event.id }
        saveData()
    }
    
    func deleteEvent(at indexSet: IndexSet) {
        let indicesToRemove = indexSet.sorted(by: >)
        for index in indicesToRemove {
            if index < events.count {
                events.remove(at: index)
            }
        }
        saveData()
    }
    
    func updatePet(_ newPet: Pet) {
        pet = newPet
        saveData()
    }
    
    func updateVetVisitToToday() {
        pet.lastVetVisit = Date()
        
        let vetEvent = PetEvent(
            type: .veterinarian,
            date: Date(),
            time: Date(),
            comment: "Vet visit updated from profile"
        )
        addEvent(vetEvent)
        
        saveData()
    }
    
    func updateFilter(_ newFilter: EventFilter) {
        filter = newFilter
        saveFilter()
    }
    
    func resetFilters() {
        filter = EventFilter()
        saveFilter()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveOnboardingStatus()
    }
    
    func eventsForDate(_ date: Date) -> [PetEvent] {
        let calendar = Calendar.current
        return events.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func eventsForPeriod(_ period: TimePeriod) -> [PetEvent] {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .allTime:
            return events
        }
        
        return events.filter { $0.date >= startDate }
    }
    
    func filteredEvents() -> [PetEvent] {
        let periodEvents = eventsForPeriod(filter.period)
        return periodEvents.filter { filter.selectedTypes.contains($0.type) }
    }
    
    func todayEvents() -> [PetEvent] {
        return eventsForDate(Date())
    }
    
    func getDayAnalytics(for date: Date) -> DayAnalytics {
        let dayEvents = eventsForDate(date)
        let eventTypes = Set(dayEvents.map { $0.type })
        
        return DayAnalytics(
            date: date,
            totalEvents: dayEvents.count,
            eventTypes: eventTypes,
            feedingCount: dayEvents.filter { $0.type == .feeding }.count,
            walkCount: dayEvents.filter { $0.type == .walk }.count,
            hasVitamins: dayEvents.contains { $0.type == .vitamins },
            hasVeterinarian: dayEvents.contains { $0.type == .veterinarian }
        )
    }
    
    func getWeekAnalytics() -> [DayAnalytics] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<7).compactMap { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { return nil }
            return getDayAnalytics(for: date)
        }.reversed()
    }
    
    func getPeriodAnalytics(for period: TimePeriod) -> PeriodAnalytics {
        let periodEvents = eventsForPeriod(period)
        
        let totalFeedings = periodEvents.filter { $0.type == .feeding }.count
        let totalWalks = periodEvents.filter { $0.type == .walk }.count
        let veterinarianVisits = periodEvents.filter { $0.type == .veterinarian }.count
        
        let vitaminDates = Set(periodEvents.filter { $0.type == .vitamins }.map {
            Calendar.current.startOfDay(for: $0.date) 
        })
        let vitaminDays = vitaminDates.count
        
        let calendar = Calendar.current
        let now = Date()
        let periodDays: Int
        
        switch period {
        case .week:
            periodDays = 7
        case .month:
            periodDays = 30
        case .allTime:
            if let firstEvent = events.min(by: { $0.date < $1.date }) {
                periodDays = calendar.dateComponents([.day], from: firstEvent.date, to: now).day ?? 1
            } else {
                periodDays = 1
            }
        }
        
        let averageFeedingsPerDay = periodDays > 0 ? Double(totalFeedings) / Double(periodDays) : 0
        let averageWalksPerDay = periodDays > 0 ? Double(totalWalks) / Double(periodDays) : 0
        let vitaminPercentage = periodDays > 0 ? (Double(vitaminDays) / Double(periodDays)) * 100 : 0
        
        let uniqueDates = Set(periodEvents.map { Calendar.current.startOfDay(for: $0.date) })
        let topDays = uniqueDates.map { getDayAnalytics(for: $0) }
            .sorted { $0.totalEvents > $1.totalEvents }
            .prefix(5)
            .map { $0 }
        
        return PeriodAnalytics(
            totalFeedings: totalFeedings,
            totalWalks: totalWalks,
            vitaminDays: vitaminDays,
            veterinarianVisits: veterinarianVisits,
            totalActions: periodEvents.count,
            averageFeedingsPerDay: averageFeedingsPerDay,
            averageWalksPerDay: averageWalksPerDay,
            vitaminPercentage: vitaminPercentage,
            topDays: topDays
        )
    }
}
