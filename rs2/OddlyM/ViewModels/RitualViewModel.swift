import Foundation
import SwiftUI
import Combine

@MainActor
class RitualViewModel: ObservableObject {
    @Published var rituals: [Ritual] = []
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    private let ritualsKey = "savedRituals"
    
    init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        loadRituals()
    }
    
    func loadRituals() {
        if let data = UserDefaults.standard.data(forKey: ritualsKey),
           let decoded = try? JSONDecoder().decode([Ritual].self, from: data) {
            rituals = decoded
        }
    }
    
    func saveRituals() {
        if let encoded = try? JSONEncoder().encode(rituals) {
            UserDefaults.standard.set(encoded, forKey: ritualsKey)
        }
    }
    
    func addRitual(_ ritual: Ritual) {
        rituals.append(ritual)
        saveRituals()
    }
    
    func updateRitual(_ ritual: Ritual) {
        if let index = rituals.firstIndex(where: { $0.id == ritual.id }) {
            rituals[index] = ritual
            saveRituals()
        }
    }
    
    func deleteRitual(_ ritual: Ritual) {
        rituals.removeAll { $0.id == ritual.id }
        saveRituals()
    }
    
    func deleteAllRituals() {
        rituals.removeAll()
        saveRituals()
    }
    
    func getRitual(by id: UUID) -> Ritual? {
        return rituals.first { $0.id == id }
    }
    
    func markCompletion(for ritualId: UUID) {
        guard var ritual = getRitual(by: ritualId) else { return }
        let today = Date()
        
        if ritual.isCompletedToday() {
            ritual.completionDates.removeAll { date in
                Calendar.current.startOfDay(for: date) == Calendar.current.startOfDay(for: today)
            }
        } else {
            ritual.completionDates.append(today)
        }
        
        updateRitual(ritual)
    }
    
    var totalRituals: Int {
        rituals.count
    }
    
    var repeatingRitualsCount: Int {
        rituals.filter { $0.isRepeating }.count
    }
    
    var totalCompletions: Int {
        rituals.reduce(0) { $0 + $1.completionCount }
    }
    
    var daysWithCompletions: Int {
        let allDates = Set(rituals.flatMap { $0.completionDates.map { Calendar.current.startOfDay(for: $0) } })
        return allDates.count
    }
    
    var mostFrequentRituals: [Ritual] {
        rituals.sorted { $0.completionCount > $1.completionCount }.prefix(3).map { $0 }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}
