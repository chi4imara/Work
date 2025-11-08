import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var dreams: [Dream] = []
    @Published var tags: [Tag] = []
    
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
           let decodedDreams = try? JSONDecoder().decode([Dream].self, from: data) {
            dreams = decodedDreams
        }
    }
    
    private func loadTags() {
        if let data = UserDefaults.standard.data(forKey: tagsKey),
           let decodedTags = try? JSONDecoder().decode([Tag].self, from: data) {
            tags = decodedTags
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
    
    func addDream(_ dream: Dream) {
        dreams.append(dream)
        updateTagsFromDream(dream)
        saveDreams()
    }
    
    func updateDream(_ dream: Dream) {
        if let index = dreams.firstIndex(where: { $0.id == dream.id }) {
            dreams[index] = dream
            updateTagsFromDream(dream)
            saveDreams()
        }
    }
    
    func deleteDream(_ dream: Dream) {
        dreams.removeAll { $0.id == dream.id }
        cleanupUnusedTags()
        saveDreams()
    }
    
    func addTag(_ tagName: String) -> Bool {
        let trimmedName = tagName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty,
              !tags.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else {
            return false
        }
        
        let newTag = Tag(name: trimmedName)
        tags.append(newTag)
        saveTags()
        return true
    }
    
    func renameTag(from oldName: String, to newName: String) -> Bool {
        let trimmedNewName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedNewName.isEmpty,
              !tags.contains(where: { $0.name.lowercased() == trimmedNewName.lowercased() && $0.name != oldName }) else {
            return false
        }
        
        if let tagIndex = tags.firstIndex(where: { $0.name == oldName }) {
            tags[tagIndex].name = trimmedNewName
        }
        
        for i in 0..<dreams.count {
            if let tagIndex = dreams[i].tags.firstIndex(of: oldName) {
                dreams[i].tags[tagIndex] = trimmedNewName
            }
        }
        
        saveTags()
        saveDreams()
        return true
    }
    
    func deleteTag(_ tagName: String) -> Bool {
        let isUsed = dreams.contains { $0.tags.contains(tagName) }
        guard !isUsed else { return false }
        
        tags.removeAll { $0.name == tagName }
        saveTags()
        return true
    }
    
    private func updateTagsFromDream(_ dream: Dream) {
        for tagName in dream.tags {
            if !tags.contains(where: { $0.name == tagName }) {
                let newTag = Tag(name: tagName)
                tags.append(newTag)
            }
        }
        saveTags()
    }
    
    private func cleanupUnusedTags() {
        let usedTags = Set(dreams.flatMap { $0.tags })
        tags = tags.filter { usedTags.contains($0.name) }
        saveTags()
    }
    
    func getTagStatistics(_ tagName: String) -> (total: Int, waiting: Int, fulfilled: Int, notFulfilled: Int) {
        let tagDreams = dreams.filter { $0.tags.contains(tagName) }
        let waiting = tagDreams.filter { $0.status == .waiting }.count
        let fulfilled = tagDreams.filter { $0.status == .fulfilled }.count
        let notFulfilled = tagDreams.filter { $0.status == .notFulfilled }.count
        
        return (total: tagDreams.count, waiting: waiting, fulfilled: fulfilled, notFulfilled: notFulfilled)
    }
    
    func getDreamsByTag(_ tagName: String) -> [Dream] {
        return dreams.filter { $0.tags.contains(tagName) }
    }
    
    func getDreamsByStatus(_ status: DreamStatus) -> [Dream] {
        return dreams.filter { $0.status == status }
    }
}
