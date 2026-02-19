import Foundation

struct Experiment: Identifiable, Codable {
    let id: UUID
    var tried: String
    var changed: String
    var result: String
    let createdAt: Date
    var updatedAt: Date
    
    init(tried: String, changed: String, result: String) {
        self.id = UUID()
        self.tried = tried
        self.changed = changed
        self.result = result
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func update(tried: String, changed: String, result: String) {
        self.tried = tried
        self.changed = changed
        self.result = result
        self.updatedAt = Date()
    }
    
    func contains(_ searchText: String) -> Bool {
        let lowercasedSearch = searchText.lowercased()
        return tried.lowercased().contains(lowercasedSearch) ||
               changed.lowercased().contains(lowercasedSearch) ||
               result.lowercased().contains(lowercasedSearch)
    }
}
