import Foundation

struct Workout: Identifiable, Codable {
    let id: UUID
    var date: Date
    var type: String
    var result: String
    var comment: String
    
    init(date: Date, type: String, result: String, comment: String = "") {
        self.id = UUID()
        self.date = date
        self.type = type
        self.result = result
        self.comment = comment
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case type
        case result
        case comment
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let idString = try? container.decode(String.self, forKey: .id),
           let uuid = UUID(uuidString: idString) {
            self.id = uuid
        } else {
            self.id = UUID()
        }
        
        self.date = try container.decode(Date.self, forKey: .date)
        self.type = try container.decode(String.self, forKey: .type)
        self.result = try container.decode(String.self, forKey: .result)
        self.comment = try container.decode(String.self, forKey: .comment)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(type, forKey: .type)
        try container.encode(result, forKey: .result)
        try container.encode(comment, forKey: .comment)
    }
}
