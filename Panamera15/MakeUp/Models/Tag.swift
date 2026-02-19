import Foundation

struct Tag: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let count: Int
    
    init(name: String, count: Int) {
        self.name = name
        self.count = count
    }
}
