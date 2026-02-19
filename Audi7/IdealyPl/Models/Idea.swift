import Foundation

struct Idea: Identifiable, Codable {
    let id: UUID
    var text: String
    let createdAt: Date
    var updatedAt: Date
    var isFavorite: Bool
    
    init(text: String) {
        self.id = UUID()
        self.text = text
        self.createdAt = Date()
        self.updatedAt = Date()
        self.isFavorite = false
    }
    
    mutating func updateText(_ newText: String) {
        self.text = newText
        self.updatedAt = Date()
    }
    
    mutating func toggleFavorite() {
        self.isFavorite.toggle()
    }
    
    var preview: String {
        let lines = text.components(separatedBy: .newlines)
        let firstLine = lines.first ?? ""
        return firstLine.count > 50 ? String(firstLine.prefix(50)) + "..." : firstLine
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, text, createdAt, updatedAt, isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
}
