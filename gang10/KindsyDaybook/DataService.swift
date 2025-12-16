import Foundation
import Combine

class DataService: ObservableObject {
    static let shared = DataService()
    
    @Published var smiles: [Smile] = []
    @Published var thoughts: [Thought] = []
    
    private let smilesKey = "SavedSmiles"
    private let thoughtsKey = "SavedThoughts"
    
    private init() {
        loadSmiles()
        loadThoughts()
    }
    
    func addSmile(_ smile: Smile) {
        smiles.insert(smile, at: 0)
        saveSmiles()
    }
    
    func updateSmile(_ smile: Smile) {
        if let index = smiles.firstIndex(where: { $0.id == smile.id }) {
            smiles[index] = smile
            saveSmiles()
        }
    }
    
    func deleteSmile(_ smile: Smile) {
        smiles.removeAll { $0.id == smile.id }
        saveSmiles()
    }
    
    func getTodaysSmiles() -> [Smile] {
        let calendar = Calendar.current
        let today = Date()
        return smiles.filter { calendar.isDate($0.createdAt, inSameDayAs: today) }
    }
    
    func getSmilesGroupedByDate() -> [(Date, [Smile])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: smiles) { smile in
            calendar.startOfDay(for: smile.createdAt)
        }
        
        return grouped.sorted { $0.key > $1.key }.map { (date, smiles) in
            (date, smiles.sorted { $0.createdAt > $1.createdAt })
        }
    }
    
    func getFilteredSmiles(filter: SmileFilter) -> [Smile] {
        return smiles.filter { filter.matches($0) }
    }
    
    func getSmileStatistics() -> SmileStatistics {
        let totalSmiles = smiles.count
        let lastSmileDate = smiles.first?.createdAt
        
        let calendar = Calendar.current
        let groupedByDay = Dictionary(grouping: smiles) { smile in
            calendar.startOfDay(for: smile.createdAt)
        }
        let maxSmilesInDay = groupedByDay.values.map { $0.count }.max() ?? 0
        
        let daysWithSmiles = Set(smiles.map { calendar.startOfDay(for: $0.createdAt) }).count
        
        return SmileStatistics(
            totalSmiles: totalSmiles,
            lastSmileDate: lastSmileDate,
            maxSmilesInDay: maxSmilesInDay,
            daysWithSmiles: daysWithSmiles
        )
    }
    
    func addThought(_ thought: Thought) {
        thoughts.insert(thought, at: 0)
        saveThoughts()
    }
    
    func updateThought(_ thought: Thought) {
        if let index = thoughts.firstIndex(where: { $0.id == thought.id }) {
            var updatedThought = thought
            updatedThought.updatedAt = Date()
            thoughts[index] = updatedThought
            saveThoughts()
        }
    }
    
    func deleteThought(_ thought: Thought) {
        thoughts.removeAll { $0.id == thought.id }
        saveThoughts()
    }
    
    private func saveSmiles() {
        if let encoded = try? JSONEncoder().encode(smiles) {
            UserDefaults.standard.set(encoded, forKey: smilesKey)
        }
    }
    
    private func loadSmiles() {
        if let data = UserDefaults.standard.data(forKey: smilesKey),
           let decoded = try? JSONDecoder().decode([Smile].self, from: data) {
            smiles = decoded.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    private func saveThoughts() {
        if let encoded = try? JSONEncoder().encode(thoughts) {
            UserDefaults.standard.set(encoded, forKey: thoughtsKey)
        }
    }
    
    private func loadThoughts() {
        if let data = UserDefaults.standard.data(forKey: thoughtsKey),
           let decoded = try? JSONDecoder().decode([Thought].self, from: data) {
            thoughts = decoded.sorted { $0.createdAt > $1.createdAt }
        }
    }
}

