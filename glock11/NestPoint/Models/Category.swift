import Foundation

struct Category: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var placesCount: Int = 0
    var lastAddedPlace: String = ""
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
