import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var plants: [PlantModel] = []
    @Published var entries: [EntryModel] = []
    
    private let plantsKey = "saved_plants"
    private let entriesKey = "saved_entries"
    
    private init() {
        loadData()
    }
    
    private func loadData() {
        loadPlants()
        loadEntries()
    }
    
    private func loadPlants() {
        if let data = UserDefaults.standard.data(forKey: plantsKey),
           let decodedPlants = try? JSONDecoder().decode([PlantModel].self, from: data) {
            plants = decodedPlants
        }
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: entriesKey),
           let decodedEntries = try? JSONDecoder().decode([EntryModel].self, from: data) {
            entries = decodedEntries
        }
    }
    
    private func savePlants() {
        if let encoded = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(encoded, forKey: plantsKey)
        }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: entriesKey)
        }
    }
    
    func addPlant(_ plant: PlantModel) {
        plants.append(plant)
        savePlants()
    }
    
    func updatePlant(_ plant: PlantModel) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index] = plant
            savePlants()
        }
    }
    
    func deletePlant(_ plant: PlantModel) {
        plants.removeAll { $0.id == plant.id }
        entries.removeAll { $0.plantId == plant.id }
        savePlants()
        saveEntries()
    }
    
    func getPlant(by id: UUID) -> PlantModel? {
        return plants.first { $0.id == id }
    }
    
    func addEntry(_ entry: EntryModel) {
        entries.append(entry)
        saveEntries()
    }
    
    func updateEntry(_ entry: EntryModel) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: EntryModel) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func getEntries(for plantId: UUID) -> [EntryModel] {
        return entries.filter { $0.plantId == plantId }.sorted { $0.date > $1.date }
    }
    
    func getAllEntries() -> [EntryModel] {
        return entries.sorted { $0.date > $1.date }
    }
    
    func getPlantsWithEntries() -> [PlantModel] {
        return plants.map { plant in
            var updatedPlant = plant
            updatedPlant.entries = getEntries(for: plant.id)
            return updatedPlant
        }
    }
    
    func getEntriesInPeriod(days: Int) -> [EntryModel] {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return entries.filter { $0.date >= cutoffDate }
    }
    
    func getEntriesForDate(_ date: Date) -> [EntryModel] {
        let calendar = Calendar.current
        return entries.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    func getUniqueDaysWithEntries() -> [Date] {
        let calendar = Calendar.current
        let uniqueDays = Set(entries.map { calendar.startOfDay(for: $0.date) })
        return Array(uniqueDays).sorted { $0 > $1 }
    }
    
    func getAppSummary() -> (plants: Int, entries7: Int, entries30: Int, frequency: Double) {
        let plantsCount = plants.count
        let now = Date()
        let week = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now
        let month = Calendar.current.date(byAdding: .day, value: -30, to: now) ?? now
        
        let entries7 = entries.filter { $0.date >= week }.count
        let entries30 = entries.filter { $0.date >= month }.count
        
        let monthEntries = entries.filter { $0.date >= month }
        let uniqueDays = Set(monthEntries.map { Calendar.current.startOfDay(for: $0.date) })
        let frequency = uniqueDays.isEmpty ? 0 : Double(entries30) / Double(uniqueDays.count)
        
        return (plantsCount, entries7, entries30, frequency)
    }
    
    func getGrowthLeaders(period: Int) -> [(plant: PlantModel, growth: Double, entries: Int)] {
        let periodStart = Calendar.current.date(byAdding: .day, value: -period, to: Date()) ?? Date()
        
        var leaderData: [(plant: PlantModel, growth: Double, entries: Int)] = []
        
        for plant in plants {
            let plantEntries = entries.filter { $0.plantId == plant.id && $0.date >= periodStart && $0.height > 0 }
                .sorted { $0.date < $1.date }
            
            if plantEntries.count >= 2 {
                let firstHeight = plantEntries.first!.height
                let lastHeight = plantEntries.last!.height
                let growth = lastHeight - firstHeight
                
                leaderData.append((plant: plant, growth: growth, entries: plantEntries.count))
            }
        }
        
        return leaderData.sorted { $0.growth > $1.growth }
    }
    
    func getCareQuality(period: Int) -> (watering: Int, spraying: Int, fertilizing: Int, repotting: Int) {
        let periodStart = Calendar.current.date(byAdding: .day, value: -period, to: Date()) ?? Date()
        let recentEntries = entries.filter { $0.date >= periodStart }
        
        var watering = 0
        var spraying = 0
        var fertilizing = 0
        var repotting = 0
        
        for entry in recentEntries {
            for tag in entry.careTags {
                switch tag {
                case .watering:
                    watering += 1
                case .spraying:
                    spraying += 1
                case .fertilizing:
                    fertilizing += 1
                case .repotting:
                    repotting += 1
                }
            }
        }
        
        return (watering, spraying, fertilizing, repotting)
    }
}
