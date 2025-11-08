import Foundation
import SwiftUI

struct OnboardingPage: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let gradientColors: [Color]
    
    static func == (lhs: OnboardingPage, rhs: OnboardingPage) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let pages = [
        OnboardingPage(
            title: "Welcome to LoveiSpice",
            description: "Your personal recipe organization assistant. Create, save, and share your favorite dishes with ease.",
            iconName: "heart.fill",
            gradientColors: [Color.primaryPurple, Color.primaryBlue]
        ),
        OnboardingPage(
            title: "Manage Ingredients",
            description: "Add ingredients to recipes and automatically create shopping lists. Never forget to buy the products you need again.",
            iconName: "list.bullet.clipboard",
            gradientColors: [Color.accentGreen, Color.primaryBlue]
        ),
        OnboardingPage(
            title: "Organize by Categories",
            description: "Sort recipes by categories: soups, salads, baking, desserts and much more. Quickly find what you're looking for.",
            iconName: "folder.fill",
            gradientColors: [Color.accentOrange, Color.accentRed]
        ),
        OnboardingPage(
            title: "Ready to Start?",
            description: "Start building your recipe collection right now. Add your first recipe and enjoy cooking!",
            iconName: "sparkles",
            gradientColors: [Color.primaryBlue, Color.primaryPurple]
        )
    ]
}
