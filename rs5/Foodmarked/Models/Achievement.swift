import Foundation
import SwiftUI

enum Achievement: String, CaseIterable, Codable {
    case firstProduct = "first_product"
    case tenProducts = "ten_products"
    case fiftyProducts = "fifty_products"
    case hundredProducts = "hundred_products"
    case weekStreak = "week_streak"
    case monthStreak = "month_streak"
    case explorer = "explorer"
    case organizer = "organizer"
    case perfectionist = "perfectionist"
    case collector = "collector"
    
    var title: String {
        switch self {
        case .firstProduct:
            return "Getting Started"
        case .tenProducts:
            return "Growing Collection"
        case .fiftyProducts:
            return "Product Master"
        case .hundredProducts:
            return "Ultimate Collector"
        case .weekStreak:
            return "Week Warrior"
        case .monthStreak:
            return "Monthly Champion"
        case .explorer:
            return "Category Explorer"
        case .organizer:
            return "Super Organizer"
        case .perfectionist:
            return "Perfectionist"
        case .collector:
            return "Favorite Collector"
        }
    }
    
    var description: String {
        switch self {
        case .firstProduct:
            return "Add your first product"
        case .tenProducts:
            return "Add 10 products to your list"
        case .fiftyProducts:
            return "Reach 50 products"
        case .hundredProducts:
            return "Amazing! 100 products tracked"
        case .weekStreak:
            return "Use the app for 7 days in a row"
        case .monthStreak:
            return "Maintain a 30-day streak"
        case .explorer:
            return "Add products from all 8 categories"
        case .organizer:
            return "Mark 20 products as favorites"
        case .perfectionist:
            return "Have 80% suitable products"
        case .collector:
            return "Collect 15 favorite products"
        }
    }
    
    var icon: String {
        switch self {
        case .firstProduct:
            return "🌟"
        case .tenProducts:
            return "📦"
        case .fiftyProducts:
            return "🏆"
        case .hundredProducts:
            return "👑"
        case .weekStreak:
            return "🔥"
        case .monthStreak:
            return "💎"
        case .explorer:
            return "🗺️"
        case .organizer:
            return "⭐"
        case .perfectionist:
            return "✨"
        case .collector:
            return "💫"
        }
    }
    
    var color: Color {
        switch self {
        case .firstProduct:
            return ColorManager.primaryYellow
        case .tenProducts:
            return ColorManager.primaryBlue
        case .fiftyProducts:
            return ColorManager.suitableGreen
        case .hundredProducts:
            return Color(red: 1.0, green: 0.84, blue: 0.0)
        case .weekStreak:
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case .monthStreak:
            return Color(red: 0.5, green: 0.3, blue: 1.0)
        case .explorer:
            return ColorManager.primaryBlue
        case .organizer:
            return ColorManager.primaryYellow
        case .perfectionist:
            return ColorManager.suitableGreen
        case .collector:
            return Color(red: 1.0, green: 0.6, blue: 0.8)
        }
    }
}