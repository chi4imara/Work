import Foundation

struct Dream: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var description: String
    var tags: [String]
    var isFavorite: Bool
    var favoriteDate: Date?
    
    init(date: Date, description: String, tags: [String] = [], isFavorite: Bool = false) {
        self.date = date
        self.description = description
        self.tags = tags
        self.isFavorite = isFavorite
        self.favoriteDate = isFavorite ? Date() : nil
    }
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
        favoriteDate = isFavorite ? Date() : nil
    }
}

extension Dream {
    static let sampleDreams: [Dream] = [
        Dream(date: Date().addingTimeInterval(-86400 * 2), description: "I was flying over a beautiful landscape with mountains and rivers. The sky was painted in vibrant colors of orange and pink.", tags: ["vivid", "beautiful"]),
        Dream(date: Date().addingTimeInterval(-86400 * 5), description: "A scary nightmare where I was being chased through dark corridors.", tags: ["scary", "dark"], isFavorite: true),
        Dream(date: Date().addingTimeInterval(-86400 * 10), description: "Funny dream where all my friends were talking animals having a tea party.", tags: ["funny", "animals"])
    ]
}
