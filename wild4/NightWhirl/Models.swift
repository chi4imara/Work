import Foundation
import SwiftUI

struct Recipe: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let description: String
    let imageName: String
    let imageFileName: String?
    let ingredients: [Ingredient]
    let instructions: [String]
    let category: RecipeCategory
    let cookingTime: Int
    let difficulty: Difficulty
    let date: Date?
    
    init(id: UUID = UUID(), name: String, description: String, imageName: String = "photo", imageFileName: String? = nil, ingredients: [Ingredient], instructions: [String], category: RecipeCategory, cookingTime: Int, difficulty: Difficulty, date: Date?) {
        self.id = id
        self.name = name
        self.description = description
        self.imageName = imageName
        self.imageFileName = imageFileName
        self.ingredients = ingredients
        self.instructions = instructions
        self.category = category
        self.cookingTime = cookingTime
        self.difficulty = difficulty
        self.date = date
    }
    
    enum Difficulty: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}

struct Ingredient: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let amount: String
    var isChecked: Bool = false
    
    init(name: String, amount: String) {
        self.id = UUID()
        self.name = name
        self.amount = amount
    }
}

enum RecipeCategory: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case dessert = "Dessert"
    case snack = "Snack"
    case soup = "Soup"
    case salad = "Salad"
    case beverage = "Beverage"
    
    var icon: String {
        switch self {
        case .breakfast: return "sunrise"
        case .lunch: return "sun.max"
        case .dinner: return "moon"
        case .dessert: return "birthday.cake"
        case .snack: return "leaf"
        case .soup: return "drop"
        case .salad: return "carrot"
        case .beverage: return "cup.and.saucer"
        }
    }
    
    var color: Color {
        switch self {
        case .breakfast: return AppColors.accentOrange
        case .lunch: return AppColors.primaryYellow
        case .dinner: return AppColors.primaryBlue
        case .dessert: return AppColors.accentRed
        case .snack: return AppColors.accentGreen
        case .soup: return AppColors.primaryBlue
        case .salad: return AppColors.accentGreen
        case .beverage: return AppColors.accentOrange
        }
    }
}

enum TabItem: String, CaseIterable {
    case today = "Today"
    case favorites = "Favorites"
    case history = "History"
    case categories = "Categories"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .today: return "fork.knife"
        case .favorites: return "star"
        case .history: return "clock"
        case .categories: return "square.grid.2x2"
        case .settings: return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .today: return "fork.knife"
        case .favorites: return "star.fill"
        case .history: return "clock.fill"
        case .categories: return "square.grid.2x2.fill"
        case .settings: return "gearshape.fill"
        }
    }
}


