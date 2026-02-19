import Foundation

struct Category: Identifiable, Codable {
    let id: UUID
    let name: String
    var productCount: Int
    
    init(name: String, productCount: Int = 0) {
        self.id = UUID()
        self.name = name
        self.productCount = productCount
    }
}
