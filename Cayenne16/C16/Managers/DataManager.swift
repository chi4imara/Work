import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var sneakers: [Sneaker] = []
    
    private let userDefaults = UserDefaults.standard
    private let sneakersKey = "SavedSneakers"
    
    private init() {
        loadSneakers()
    }
    
    func addSneaker(_ sneaker: Sneaker) {
        sneakers.append(sneaker)
        saveSneakers()
    }
    
    func updateSneaker(_ updatedSneaker: Sneaker) {
        if let index = sneakers.firstIndex(where: { $0.id == updatedSneaker.id }) {
            sneakers[index] = updatedSneaker
            saveSneakers()
        }
    }
    
    func deleteSneaker(withId id: UUID) {
        sneakers.removeAll { $0.id == id }
        saveSneakers()
    }
    
    func getSneaker(withId id: UUID) -> Sneaker? {
        return sneakers.first { $0.id == id }
    }
    
    
    func addWearingDate(to sneakerId: UUID, date: Date) {
        if let index = sneakers.firstIndex(where: { $0.id == sneakerId }) {
            sneakers[index].addWearingDate(date)
            saveSneakers()
        }
    }
    
    func removeWearingDate(from sneakerId: UUID, wearingDateId: UUID) {
        if let index = sneakers.firstIndex(where: { $0.id == sneakerId }) {
            sneakers[index].removeWearingDate(withId: wearingDateId)
            saveSneakers()
        }
    }
        
    func getSneakersWithWearingData() -> [Sneaker] {
        return sneakers.filter { !$0.wearingDates.isEmpty }
            .sorted { $0.wearingCount > $1.wearingCount }
    }
    
    func getAllWearingDates() -> [(sneaker: Sneaker, wearingDate: WearingDate)] {
        var allDates: [(sneaker: Sneaker, wearingDate: WearingDate)] = []
        
        for sneaker in sneakers {
            for wearingDate in sneaker.wearingDates {
                allDates.append((sneaker: sneaker, wearingDate: wearingDate))
            }
        }
        
        return allDates.sorted { $0.wearingDate.date > $1.wearingDate.date }
    }
        
    private func saveSneakers() {
        if let encoded = try? JSONEncoder().encode(sneakers) {
            userDefaults.set(encoded, forKey: sneakersKey)
        }
    }
    
    private func loadSneakers() {
        if let data = userDefaults.data(forKey: sneakersKey),
           let decoded = try? JSONDecoder().decode([Sneaker].self, from: data) {
            sneakers = decoded
        }
    }
}
