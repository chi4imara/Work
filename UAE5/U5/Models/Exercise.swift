import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var reps: String
    
    init(name: String, reps: String) {
        self.id = UUID()
        self.name = name
        self.reps = reps
    }
}
