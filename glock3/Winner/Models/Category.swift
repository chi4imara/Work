import Foundation

struct Category: Identifiable, Codable {
    var id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

extension Category {
    static let sampleData: [Category] = [
        
    ]
}
