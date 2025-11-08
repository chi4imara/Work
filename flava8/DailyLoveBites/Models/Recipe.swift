import Foundation

struct Recipe: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var servings: Int
    var cookingTime: Int?
    var difficulty: Difficulty
    var tags: [String]
    var ingredients: [Ingredient]
    var steps: [CookingStep]
    var isFavorite: Bool
    var notes: String?
    let createdAt: Date
    var updatedAt: Date
    
    init(name: String, 
         servings: Int, 
         cookingTime: Int? = nil, 
         difficulty: Difficulty = .easy, 
         tags: [String] = [], 
         ingredients: [Ingredient] = [], 
         steps: [CookingStep] = [], 
         isFavorite: Bool = false, 
         notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.servings = servings
        self.cookingTime = cookingTime
        self.difficulty = difficulty
        self.tags = tags
        self.ingredients = ingredients
        self.steps = steps
        self.isFavorite = isFavorite
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    enum Difficulty: String, CaseIterable, Codable {
        case easy = "easy"
        case medium = "medium"
        case hard = "hard"
        
        var localizedString: String {
            switch self {
            case .easy: return "Easy"
            case .medium: return "Medium"
            case .hard: return "Hard"
            }
        }
        
        var emoji: String {
            switch self {
            case .easy: return "🟢"
            case .medium: return "🟡"
            case .hard: return "🔴"
            }
        }
    }
    
    var formattedCookingTime: String {
        guard let time = cookingTime else { return "" }
        return "\(time) min"
    }
    
    var formattedServings: String {
        return "\(servings) serving\(servings == 1 ? "" : "s")"
    }
    
    var metadataString: String {
        var components: [String] = []
        
        if let time = cookingTime {
            components.append("\(time) min")
        }
        
        components.append(formattedServings)
        components.append(difficulty.localizedString)
        
        return components.joined(separator: " • ")
    }
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
        updatedAt = Date()
    }
    
    func matchesSearchQuery(_ query: String) -> Bool {
        let lowercaseQuery = query.lowercased()
        
        if name.lowercased().contains(lowercaseQuery) {
            return true
        }
        
        for tag in tags {
            if tag.lowercased().contains(lowercaseQuery) || "#\(tag.lowercased())".contains(lowercaseQuery) {
                return true
            }
        }
        
        return false
    }
}
