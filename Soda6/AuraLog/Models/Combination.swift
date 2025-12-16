import Foundation

struct Combination: Identifiable, Codable {
    let id = UUID()
    var name: String
    var comment: String
    var dateAdded: Date = Date()
}
