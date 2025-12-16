import SwiftUI

enum RecipeCategory: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case desserts = "Desserts"
    case snacks = "Snacks"
    case beverages = "Beverages"
    
    var displayName: String {
        return rawValue
    }
    
    var icon: String {
        switch self {
        case .breakfast: return "sunrise"
        case .lunch: return "sun.max"
        case .dinner: return "moon"
        case .desserts: return "birthday.cake"
        case .snacks: return "leaf"
        case .beverages: return "cup.and.saucer"
        }
    }
    
    var color: Color {
        switch self {
        case .breakfast: return AppColors.primaryYellow
        case .lunch: return AppColors.accent
        case .dinner: return AppColors.primaryBlue
        case .desserts: return AppColors.success
        case .snacks: return AppColors.primaryBlue.opacity(0.8)
        case .beverages: return AppColors.warning
        }
    }
    
    static var allCategories: [RecipeCategory] {
        return RecipeCategory.allCases
    }
}
