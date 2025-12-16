import Foundation
import Combine

struct Manicure: Identifiable, Codable {
    let id: UUID
    var date: Date
    var color: String
    var salon: String
    var note: String
    let createdAt: Date
    
    init(date: Date, color: String, salon: String = "", note: String = "") {
        self.id = UUID()
        self.date = date
        self.color = color
        self.salon = salon
        self.note = note
        self.createdAt = Date()
    }
}

struct Idea: Identifiable, Codable {
    let id: UUID
    var title: String
    var note: String
    let createdAt: Date
    
    init(title: String, note: String = "") {
        self.id = UUID()
        self.title = title
        self.note = note
        self.createdAt = Date()
    }
}

struct ColorStatistic: Identifiable {
    let id = UUID()
    let color: String
    let count: Int
    let lastUsed: Date
    let manicures: [Manicure]
}

class ManicureStore: ObservableObject {
    @Published var manicures: [Manicure] = []
    
    private let userDefaults = UserDefaults.standard
    private let manicuresKey = "SavedManicures"
    
    init() {
        loadManicures()
    }
    
    func addManicure(_ manicure: Manicure) {
        manicures.append(manicure)
        saveManicures()
    }
    
    func updateManicure(_ manicure: Manicure) {
        if let index = manicures.firstIndex(where: { $0.id == manicure.id }) {
            manicures[index] = manicure
            saveManicures()
        }
    }
    
    func deleteManicure(_ manicure: Manicure) {
        manicures.removeAll { $0.id == manicure.id }
        saveManicures()
    }
    
    func deleteManicure(by id: UUID) {
        manicures.removeAll { $0.id == id }
        saveManicures()
    }
    
    func getManicure(by id: UUID) -> Manicure? {
        return manicures.first { $0.id == id }
    }
    
    func getColorStatistics() -> [ColorStatistic] {
        let groupedByColor = Dictionary(grouping: manicures) { $0.color.lowercased() }
        
        return groupedByColor.map { (color, manicures) in
            let sortedManicures = manicures.sorted { $0.date > $1.date }
            return ColorStatistic(
                color: color.capitalized,
                count: manicures.count,
                lastUsed: sortedManicures.first?.date ?? Date(),
                manicures: sortedManicures
            )
        }.sorted { $0.color < $1.color }
    }
    
    func getManicuresForColor(_ color: String) -> [Manicure] {
        return manicures.filter { $0.color.lowercased() == color.lowercased() }
            .sorted { $0.date > $1.date }
    }
    
    func searchManicures(_ searchText: String) -> [Manicure] {
        if searchText.isEmpty {
            return manicures.sorted { $0.date > $1.date }
        }
        
        return manicures.filter { manicure in
            manicure.color.localizedCaseInsensitiveContains(searchText) ||
            manicure.salon.localizedCaseInsensitiveContains(searchText) ||
            manicure.note.localizedCaseInsensitiveContains(searchText)
        }.sorted { $0.date > $1.date }
    }
    
    private func saveManicures() {
        if let encoded = try? JSONEncoder().encode(manicures) {
            userDefaults.set(encoded, forKey: manicuresKey)
        }
    }
    
    private func loadManicures() {
        if let data = userDefaults.data(forKey: manicuresKey),
           let decoded = try? JSONDecoder().decode([Manicure].self, from: data) {
            manicures = decoded
        }
    }
}

class IdeaStore: ObservableObject {
    @Published var ideas: [Idea] = []
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedIdeas"
    
    init() {
        loadIdeas()
    }
    
    func addIdea(_ idea: Idea) {
        ideas.append(idea)
        saveIdeas()
    }
    
    func deleteIdea(_ idea: Idea) {
        ideas.removeAll { $0.id == idea.id }
        saveIdeas()
    }
    
    private func saveIdeas() {
        if let encoded = try? JSONEncoder().encode(ideas) {
            userDefaults.set(encoded, forKey: ideasKey)
        }
    }
    
    private func loadIdeas() {
        if let data = userDefaults.data(forKey: ideasKey),
           let decoded = try? JSONDecoder().decode([Idea].self, from: data) {
            ideas = decoded
        }
    }
}
