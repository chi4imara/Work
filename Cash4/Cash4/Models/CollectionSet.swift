import Foundation

struct CollectionSet: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: String
    var totalItems: Int
    var completedItems: Int
    var dateCreated: Date
    
    init(name: String = "", category: String = "", totalItems: Int = 0) {
        self.name = name
        self.category = category
        self.totalItems = totalItems
        self.completedItems = 0
        self.dateCreated = Date()
    }
    
    var completionPercentage: Double {
        guard totalItems > 0 else { return 0 }
        return Double(completedItems) / Double(totalItems) * 100
    }
    
    var isComplete: Bool {
        return completedItems >= totalItems && totalItems > 0
    }
}
