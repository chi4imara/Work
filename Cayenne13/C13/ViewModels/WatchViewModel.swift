import Foundation
import SwiftUI
import Combine

class WatchViewModel: ObservableObject {
    @Published var watches: [Watch] = []
    @Published var selectedWatch: Watch?
    
    private let dataManager = DataManager.shared
    
    init() {
        loadWatches()
    }
    
    func addWatch(_ watch: Watch) {
        watches.append(watch)
        saveWatches()
    }
    
    func updateWatch(_ watch: Watch) {
        if let index = watches.firstIndex(where: { $0.id == watch.id }) {
            watches[index] = watch
            saveWatches()
        }
    }
    
    func deleteWatch(_ watch: Watch) {
        watches.removeAll { $0.id == watch.id }
        saveWatches()
    }
    
    func getWatch(by id: UUID) -> Watch? {
        return watches.first { $0.id == id }
    }
    
    func addWearingDay(to watchId: UUID, date: Date) {
        if let index = watches.firstIndex(where: { $0.id == watchId }) {
            let wearingDay = WearingDay(date: date, watchId: watchId)
            watches[index].wearingDays.append(wearingDay)
            saveWatches()
        }
    }
    
    func removeWearingDay(from watchId: UUID, wearingDayId: UUID) {
        if let index = watches.firstIndex(where: { $0.id == watchId }) {
            watches[index].wearingDays.removeAll { $0.id == wearingDayId }
            saveWatches()
        }
    }
    
    func getWearingDaysCount(for watchId: UUID) -> Int {
        return watches.first { $0.id == watchId }?.wearingDays.count ?? 0
    }
    
    func getAllWearingDays() -> [WearingDay] {
        return watches.flatMap { $0.wearingDays }
    }
    
    func getWatchesWithWearingDays() -> [(watch: Watch, count: Int)] {
        return watches.compactMap { watch in
            let count = watch.wearingDays.count
            return count > 0 ? (watch, count) : nil
        }.sorted { $0.count > $1.count }
    }
    
    private func saveWatches() {
        dataManager.saveWatches(watches)
    }
    
    private func loadWatches() {
        watches = dataManager.loadWatches()
    }
}
