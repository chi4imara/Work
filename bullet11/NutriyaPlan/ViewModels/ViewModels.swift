
import Foundation
import SwiftUI
import StoreKit
import Combine

class AppViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var fertilizationHistory: [FertilizationEntry] = []
    @Published var userNotes: [UserNote] = []
    @Published var settings: AppSettings = .default
    @Published var showingSplash = true
    @Published var showingOnboarding = false
    
    private let userDefaults = UserDefaults.standard
    private let plantsKey = "saved_plants"
    private let historyKey = "fertilization_history"
    private let notesKey = "user_notes"
    private let settingsKey = "app_settings"
    
    init() {
        loadData()
        checkOnboardingStatus()
    }
    
    private func loadData() {
        loadPlants()
        loadHistory()
        loadNotes()
        loadSettings()
    }
    
    private func loadPlants() {
        if let data = userDefaults.data(forKey: plantsKey),
           let decodedPlants = try? JSONDecoder().decode([Plant].self, from: data) {
            plants = decodedPlants
        }
    }
    
    private func savePlants() {
        if let encoded = try? JSONEncoder().encode(plants) {
            userDefaults.set(encoded, forKey: plantsKey)
        }
    }
    
    private func loadHistory() {
        if let data = userDefaults.data(forKey: historyKey),
           let decodedHistory = try? JSONDecoder().decode([FertilizationEntry].self, from: data) {
            fertilizationHistory = decodedHistory
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(fertilizationHistory) {
            userDefaults.set(encoded, forKey: historyKey)
        }
    }
    
    private func loadNotes() {
        if let data = userDefaults.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([UserNote].self, from: data) {
            userNotes = decodedNotes
        }
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(userNotes) {
            userDefaults.set(encoded, forKey: notesKey)
        }
    }
    
    private func loadSettings() {
        if let data = userDefaults.data(forKey: settingsKey),
           let decodedSettings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decodedSettings
        }
    }
    
    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            userDefaults.set(encoded, forKey: settingsKey)
        }
    }
    
    private func checkOnboardingStatus() {
        if !settings.hasCompletedOnboarding {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.showingSplash = false
                self.showingOnboarding = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.showingSplash = false
            }
        }
    }
    
    func completeOnboarding() {
        settings.hasCompletedOnboarding = true
        saveSettings()
        showingOnboarding = false
    }
    
    func addPlant(_ plant: Plant) {
        plants.append(plant)
        savePlants()
    }
    
    func updatePlant(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index] = plant
            savePlants()
        }
    }
    
    func deletePlant(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        fertilizationHistory.removeAll { $0.plantId == plant.id }
        savePlants()
        saveHistory()
    }
    
    func fertilizePlantToday(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].lastFertilizedDate = Date()
            savePlants()
        }
        
        let entry = FertilizationEntry(
            plantId: plant.id,
            date: Date(),
            fertilizerType: plant.fertilizerType
        )
        fertilizationHistory.append(entry)
        saveHistory()
    }
    
    func filteredAndSortedPlants() -> [Plant] {
        var filtered = plants
        
        switch settings.currentFilter {
        case .all:
            break
        case .needsFertilizing:
            filtered = filtered.filter { $0.status == .needsFertilizing }
        }
        
        switch settings.currentSort {
        case .byLastFertilized:
            filtered.sort { plant1, plant2 in
                if plant1.status != plant2.status {
                    switch (plant1.status, plant2.status) {
                    case (.needsFertilizing, _):
                        return true
                    case (_, .needsFertilizing):
                        return false
                    case (.soonToFertilize, .recentlyFertilized):
                        return true
                    case (.recentlyFertilized, .soonToFertilize):
                        return false
                    default:
                        return false
                    }
                }
                return plant1.daysPassed > plant2.daysPassed
            }
        case .byName:
            filtered.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
        
        return filtered
    }
    
    func updateFilter(_ filter: PlantFilter) {
        settings.currentFilter = filter
        saveSettings()
    }
    
    func updateSort(_ sort: PlantSortOption) {
        settings.currentSort = sort
        saveSettings()
    }
    
    func deleteHistoryEntry(_ entry: FertilizationEntry) {
        fertilizationHistory.removeAll { $0.id == entry.id }
        
        if let plant = plants.first(where: { $0.id == entry.plantId }) {
            let plantEntries = fertilizationHistory.filter { $0.plantId == plant.id }
            if let mostRecentEntry = plantEntries.max(by: { $0.date < $1.date }) {
                if let index = plants.firstIndex(where: { $0.id == plant.id }) {
                    plants[index].lastFertilizedDate = mostRecentEntry.date
                    savePlants()
                }
            }
        }
        
        saveHistory()
    }
    
    func getHistoryForPlant(_ plantId: UUID, limit: Int? = nil) -> [FertilizationEntry] {
        let plantHistory = fertilizationHistory
            .filter { $0.plantId == plantId }
            .sorted { $0.date > $1.date }
        
        if let limit = limit {
            return Array(plantHistory.prefix(limit))
        }
        return plantHistory
    }
    
    func getAllHistorySorted() -> [FertilizationEntry] {
        return fertilizationHistory.sorted { $0.date > $1.date }
    }
    
    func addNote(_ note: UserNote) {
        userNotes.append(note)
        saveNotes()
    }
    
    func updateNote(_ note: UserNote) {
        if let index = userNotes.firstIndex(where: { $0.id == note.id }) {
            userNotes[index] = note
            saveNotes()
        }
    }
    
    func deleteNote(_ note: UserNote) {
        userNotes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    func sortedNotes() -> [UserNote] {
        return userNotes.sorted { $0.dateModified > $1.dateModified }
    }
    
    func getTotalFertilizations() -> Int {
        return fertilizationHistory.count
    }
    
    func getLastFertilizationDate() -> Date? {
        return fertilizationHistory.max(by: { $0.date < $1.date })?.date
    }
    
    func getMostFertilizedPlant() -> Plant? {
        let plantCounts = Dictionary(grouping: fertilizationHistory, by: { $0.plantId })
            .mapValues { $0.count }
        
        guard let mostFertilizedPlantId = plantCounts.max(by: { $0.value < $1.value })?.key else {
            return nil
        }
        
        return plants.first { $0.id == mostFertilizedPlantId }
    }
    
    func getAverageInterval(for plantId: UUID? = nil) -> Double? {
        let entries: [FertilizationEntry]
        
        if let plantId = plantId {
            entries = fertilizationHistory.filter { $0.plantId == plantId }.sorted { $0.date < $1.date }
        } else {
            var plantAverages: [Double] = []
            
            for plant in plants {
                let plantEntries = fertilizationHistory.filter { $0.plantId == plant.id }.sorted { $0.date < $1.date }
                if plantEntries.count >= 2 {
                    let firstDate = plantEntries.first!.date
                    let lastDate = plantEntries.last!.date
                    let daysDifference = Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0
                    let average = Double(daysDifference) / Double(plantEntries.count - 1)
                    plantAverages.append(average)
                }
            }
            
            return plantAverages.isEmpty ? nil : plantAverages.reduce(0, +) / Double(plantAverages.count)
        }
        
        guard entries.count >= 2 else { return nil }
        
        let firstDate = entries.first!.date
        let lastDate = entries.last!.date
        let daysDifference = Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0
        
        return Double(daysDifference) / Double(entries.count - 1)
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
