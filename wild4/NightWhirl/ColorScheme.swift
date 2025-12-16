import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let gradientStart = Color(red: 0.9, green: 0.95, blue: 1.0)
    static let gradientEnd = Color(red: 0.7, green: 0.85, blue: 1.0)
    
    static let textPrimary = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let textLight = Color.white
    
    static let backgroundPrimary = LinearGradient(
        gradient: Gradient(colors: [gradientStart, gradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.9)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let shadowColor = Color.black.opacity(0.1)
}

extension View {
    func primaryBackground() -> some View {
        self.background(AppColors.backgroundPrimary)
    }
    
    func cardStyle() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .foregroundColor(AppColors.textLight)
            .padding()
            .background(AppColors.primaryYellow)
            .cornerRadius(25)
            .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
    }
}
