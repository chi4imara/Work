import SwiftUI
import Combine

class EnergyViewModel: ObservableObject {
    @Published var energyEntries: [EnergyEntry] = []
    @Published var currentMood: MoodType = .happy
    @Published var currentEnergyLevel: Int = 5
    @Published var currentNote: String = ""
    
    init() {
        loadEnergyEntries()
    }
    
    func addEnergyEntry() {
        let entry = EnergyEntry(
            energyLevel: currentEnergyLevel,
            mood: currentMood,
            note: currentNote
        )
        energyEntries.append(entry)
        saveEnergyEntries()
        
        currentNote = ""
        currentEnergyLevel = 5
        currentMood = .happy
    }
    
    func getEntriesForLast7Days() -> [EnergyEntry] {
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        return energyEntries.filter { $0.timestamp >= sevenDaysAgo }
            .sorted { $0.timestamp < $1.timestamp }
    }
    
    func getAverageEnergyForLast7Days() -> Double {
        let entries = getEntriesForLast7Days()
        guard !entries.isEmpty else { return 0 }
        
        let total = entries.reduce(0) { $0 + $1.energyLevel }
        return Double(total) / Double(entries.count)
    }
    
    func getMoodDistribution() -> [MoodType: Int] {
        var distribution: [MoodType: Int] = [:]
        
        for mood in MoodType.allCases {
            distribution[mood] = 0
        }
        
        for entry in getEntriesForLast7Days() {
            distribution[entry.mood, default: 0] += 1
        }
        
        return distribution
    }
    
    private func generateSampleData() {
        if energyEntries.isEmpty {
            let calendar = Calendar.current
            let moods = MoodType.allCases
            
            for i in 0..<7 {
                if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                    let entry = EnergyEntry(
                        energyLevel: Int.random(in: 3...8),
                        mood: moods.randomElement() ?? .happy,
                        note: "Sample entry for day \(i + 1)",
                        timestamp: date
                    )
                    energyEntries.append(entry)
                }
            }
            saveEnergyEntries()
        }
    }
    
    private func loadEnergyEntries() {
        if let data = UserDefaults.standard.data(forKey: "energy_entries"),
           let entries = try? JSONDecoder().decode([EnergyEntry].self, from: data) {
            energyEntries = entries
        }
    }
    
    private func saveEnergyEntries() {
        if let data = try? JSONEncoder().encode(energyEntries) {
            UserDefaults.standard.set(data, forKey: "energy_entries")
        }
    }
}
