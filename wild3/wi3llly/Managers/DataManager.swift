import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var dreams: [DreamModel] = []
    @Published var tags: [TagModel] = []
    
    private let dreamsKey = "SavedDreams"
    private let tagsKey = "SavedTags"
    
    private init() {
        loadData()
    }
    
    private func loadData() {
        loadDreams()
        loadTags()
    }
    
    private func loadDreams() {
        if let data = UserDefaults.standard.data(forKey: dreamsKey),
           let decodedDreams = try? JSONDecoder().decode([DreamModel].self, from: data) {
            dreams = decodedDreams.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    private func loadTags() {
        if let data = UserDefaults.standard.data(forKey: tagsKey),
           let decodedTags = try? JSONDecoder().decode([TagModel].self, from: data) {
            tags = decodedTags.sorted { $0.name < $1.name }
        }
    }
    
    private func saveDreams() {
        if let encoded = try? JSONEncoder().encode(dreams) {
            UserDefaults.standard.set(encoded, forKey: dreamsKey)
        }
    }
    
    private func saveTags() {
        if let encoded = try? JSONEncoder().encode(tags) {
            UserDefaults.standard.set(encoded, forKey: tagsKey)
        }
    }
    
    func addDream(_ dream: DreamModel) {
        dreams.insert(dream, at: 0)
        
        for tagName in dream.tags {
            addTagIfNotExists(tagName)
        }
        
        saveDreams()
    }
    
    func updateDream(_ dream: DreamModel) {
        if let index = dreams.firstIndex(where: { $0.id == dream.id }) {
            dreams[index] = dream
            
            for tagName in dream.tags {
                addTagIfNotExists(tagName)
            }
            
            saveDreams()
        }
    }
    
    func deleteDream(withId id: UUID) {
        dreams.removeAll { $0.id == id }
        saveDreams()
        
        cleanupUnusedTags()
    }
    
    func getDream(withId id: UUID) -> DreamModel? {
        return dreams.first { $0.id == id }
    }
    
    func addTag(_ tag: TagModel) -> Bool {
        if tags.contains(where: { $0.name == tag.name }) {
            return false
        }
        
        tags.append(tag)
        tags.sort { $0.name < $1.name }
        saveTags()
        return true
    }
    
    private func addTagIfNotExists(_ tagName: String) {
        let normalizedName = tagName.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if !tags.contains(where: { $0.name == normalizedName }) {
            let newTag = TagModel(name: normalizedName)
            tags.append(newTag)
            tags.sort { $0.name < $1.name }
            saveTags()
        }
    }
    
    func deleteTag(withName name: String) {
        tags.removeAll { $0.name == name }
        saveTags()
        
        for i in dreams.indices {
            dreams[i].tags.removeAll { $0 == name }
        }
        saveDreams()
    }
    
    func getTagNames() -> [String] {
        return tags.map { $0.name }.sorted()
    }
    
    private func cleanupUnusedTags() {
        let usedTags = Set(dreams.flatMap { $0.tags })
        tags.removeAll { tag in
            !usedTags.contains(tag.name)
        }
        saveTags()
    }
    
    func getDreamCount() -> Int {
        return dreams.count
    }
    
    func getTagCount() -> Int {
        return tags.count
    }
    
    func getDreamCount(for tagName: String) -> Int {
        return dreams.filter { $0.tags.contains(tagName) }.count
    }
    
    func getTagFrequencies() -> [(String, Int)] {
        let allTags = dreams.flatMap { $0.tags }
        let tagCounts = Dictionary(grouping: allTags, by: { $0 })
            .mapValues { $0.count }
        
        return tagCounts.sorted { $0.value > $1.value }
    }
    
    func getDreamsByDate() -> [DreamDateData] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: dreams) { dream in
            calendar.startOfDay(for: dream.createdAt)
        }
        
        return grouped.map { date, dreams in
            DreamDateData(date: date, count: dreams.count)
        }
        .sorted { $0.date < $1.date }
    }
    
    func filterDreams(by tags: Set<String>, searchText: String = "") -> [DreamModel] {
        var filtered = dreams
        
        if !tags.isEmpty {
            filtered = filtered.filter { dream in
                let dreamTags = Set(dream.tags)
                return !tags.isDisjoint(with: dreamTags)
            }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { dream in
                dream.title.localizedCaseInsensitiveContains(searchText) ||
                dream.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    func sortDreams(_ dreams: [DreamModel], by sortOption: DreamSortOption) -> [DreamModel] {
        switch sortOption {
        case .dateDescending:
            return dreams.sorted { $0.createdAt > $1.createdAt }
        case .dateAscending:
            return dreams.sorted { $0.createdAt < $1.createdAt }
        case .titleAscending:
            return dreams.sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .titleDescending:
            return dreams.sorted { $0.title.localizedCompare($1.title) == .orderedDescending }
        }
    }
}

enum DreamSortOption: String, CaseIterable {
    case dateDescending = "Date (Newest First)"
    case dateAscending = "Date (Oldest First)"
    case titleAscending = "Title (A-Z)"
    case titleDescending = "Title (Z-A)"
}
