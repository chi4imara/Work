import Foundation
import SwiftUI

enum ChallengeType: String, Codable {
    case addProducts = "add_products"
    case exploreCategory = "explore_category"
    case markFavorites = "mark_favorites"
    case maintainStreak = "maintain_streak"
    case balanceRatio = "balance_ratio"
    
    var title: String {
        switch self {
        case .addProducts:
            return "Product Collector"
        case .exploreCategory:
            return "Category Explorer"
        case .markFavorites:
            return "Favorite Marker"
        case .maintainStreak:
            return "Streak Keeper"
        case .balanceRatio:
            return "Balance Master"
        }
    }
    
    var description: String {
        switch self {
        case .addProducts:
            return "Add 3 new products today"
        case .exploreCategory:
            return "Add products from 3 different categories"
        case .markFavorites:
            return "Mark 5 products as favorites"
        case .maintainStreak:
            return "Use the app for 3 days in a row"
        case .balanceRatio:
            return "Have 60% suitable products"
        }
    }
    
    var icon: String {
        switch self {
        case .addProducts:
            return "📦"
        case .exploreCategory:
            return "🗺️"
        case .markFavorites:
            return "⭐"
        case .maintainStreak:
            return "🔥"
        case .balanceRatio:
            return "⚖️"
        }
    }
    
    var color: Color {
        switch self {
        case .addProducts:
            return ColorManager.primaryBlue
        case .exploreCategory:
            return ColorManager.primaryBlue
        case .markFavorites:
            return ColorManager.primaryYellow
        case .maintainStreak:
            return Color(red: 1.0, green: 0.4, blue: 0.4)
        case .balanceRatio:
            return ColorManager.suitableGreen
        }
    }
}

struct DailyChallenge: Identifiable, Codable {
    let id = UUID()
    let type: ChallengeType
    let date: Date
    var isCompleted: Bool
    var progress: Double
    
    init(type: ChallengeType, date: Date = Date()) {
        self.type = type
        self.date = date
        self.isCompleted = false
        self.progress = 0.0
    }
}