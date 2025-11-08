import Foundation

enum FavoriteType: String, Codable, CaseIterable {
    case task = "task"
    case theme = "theme"
    
    var icon: String {
        switch self {
        case .task:
            return "star.circle"
        case .theme:
            return "theatermasks"
        }
    }
}

struct FavoriteItem: Identifiable, Codable, Equatable {
    let id = UUID()
    var text: String
    var type: FavoriteType
    var dateAdded: Date
    
    init(text: String, type: FavoriteType) {
        self.text = text
        self.type = type
        self.dateAdded = Date()
    }
}
