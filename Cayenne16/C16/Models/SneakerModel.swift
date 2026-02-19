import Foundation

enum SneakerCondition: String, CaseIterable, Codable {
    case new = "New"
    case excellent = "Excellent"
    case good = "Good"
    case worn = "Worn"
    case needsCare = "Needs Care"
}

struct WearingDate: Identifiable, Codable {
    let id: UUID
    let date: Date
    
    init(date: Date) {
        self.id = UUID()
        self.date = date
    }
    
    init(id: UUID, date: Date) {
        self.id = id
        self.date = date
    }
    
    enum CodingKeys: String, CodingKey {
        case id, date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
    }
}

struct Sneaker: Identifiable, Codable {
    let id: UUID
    var model: String
    var purchaseDate: Date
    var condition: SneakerCondition
    var comment: String
    var wearingDates: [WearingDate]
    
    init(model: String, purchaseDate: Date, condition: SneakerCondition, comment: String = "") {
        self.id = UUID()
        self.model = model
        self.purchaseDate = purchaseDate
        self.condition = condition
        self.comment = comment
        self.wearingDates = []
    }
    
    init(id: UUID, model: String, purchaseDate: Date, condition: SneakerCondition, comment: String, wearingDates: [WearingDate]) {
        self.id = id
        self.model = model
        self.purchaseDate = purchaseDate
        self.condition = condition
        self.comment = comment
        self.wearingDates = wearingDates
    }
    
    enum CodingKeys: String, CodingKey {
        case id, model, purchaseDate, condition, comment, wearingDates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        model = try container.decode(String.self, forKey: .model)
        purchaseDate = try container.decode(Date.self, forKey: .purchaseDate)
        condition = try container.decode(SneakerCondition.self, forKey: .condition)
        comment = try container.decode(String.self, forKey: .comment)
        wearingDates = try container.decode([WearingDate].self, forKey: .wearingDates)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(model, forKey: .model)
        try container.encode(purchaseDate, forKey: .purchaseDate)
        try container.encode(condition, forKey: .condition)
        try container.encode(comment, forKey: .comment)
        try container.encode(wearingDates, forKey: .wearingDates)
    }
    
    var wearingCount: Int {
        return wearingDates.count
    }
    
    mutating func addWearingDate(_ date: Date) {
        let wearingDate = WearingDate(date: date)
        wearingDates.append(wearingDate)
        wearingDates.sort { $0.date > $1.date }
    }
    
    mutating func removeWearingDate(withId id: UUID) {
        wearingDates.removeAll { $0.id == id }
    }
}
