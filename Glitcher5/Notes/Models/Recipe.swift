import Foundation

struct Recipe: Identifiable, Codable, Equatable {
    let id: UUID
    var dishName: String
    var meatType: String
    var cookingTime: String
    var sauceMarinate: String
    var cookingStep: String
    var comment: String
    var isFavorite: Bool
    let dateCreated: Date
    
    init(dishName: String, meatType: String, cookingTime: String, sauceMarinate: String, cookingStep: String, comment: String, isFavorite: Bool = false) {
        self.id = UUID()
        self.dishName = dishName
        self.meatType = meatType
        self.cookingTime = cookingTime
        self.sauceMarinate = sauceMarinate
        self.cookingStep = cookingStep
        self.comment = comment
        self.isFavorite = isFavorite
        self.dateCreated = Date()
    }
}

enum MeatType: String, CaseIterable {
    case beef = "Beef"
    case chicken = "Chicken"
    case pork = "Pork"
    case fish = "Fish"
    case vegetables = "Vegetables"
}
