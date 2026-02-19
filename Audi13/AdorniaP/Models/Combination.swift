import Foundation

struct Combination: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    var jewelries: [Jewelry]
    let createdAt: Date
    
    init(name: String = "", description: String = "", jewelries: [Jewelry] = []) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.jewelries = jewelries
        self.createdAt = Date()
    }
    
    var jewelryCount: Int {
        return jewelries.count
    }
    
    var shortDescription: String {
        if description.isEmpty {
            return "No description"
        }
        return description.count > 50 ? String(description.prefix(50)) + "..." : description
    }
    
    var jewelryList: String {
        if jewelries.isEmpty {
            return "No jewelry added"
        }
        return jewelries.map { jewelry in
            jewelry.name.isEmpty ? jewelry.type.displayName : jewelry.name
        }.joined(separator: ", ")
    }
}

enum CombinationCategory: String, CaseIterable {
    case everyday = "Everyday"
    case evening = "Evening"
    case special = "Special Occasion"
    case work = "Work"
    case casual = "Casual"
    case formal = "Formal"
    
    var keywords: [String] {
        switch self {
        case .everyday:
            return ["everyday", "daily", "casual", "simple", "basic"]
        case .evening:
            return ["evening", "night", "dinner", "date", "romantic"]
        case .special:
            return ["special", "occasion", "celebration", "party", "wedding", "event"]
        case .work:
            return ["work", "office", "professional", "business", "meeting"]
        case .casual:
            return ["casual", "relaxed", "weekend", "comfortable", "laid-back"]
        case .formal:
            return ["formal", "elegant", "sophisticated", "classy", "dressy"]
        }
    }
}
