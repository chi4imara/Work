import Foundation

struct Category: Identifiable, Codable {
    let id: UUID
    var name: String
    var itemCount: Int
    
    init(name: String, itemCount: Int = 0) {
        self.id = UUID()
        self.name = name
        self.itemCount = itemCount
    }
}
