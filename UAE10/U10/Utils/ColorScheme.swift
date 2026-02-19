import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let white = Color.white
    
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.95)
    static let mediumGray = Color(red: 0.6, green: 0.6, blue: 0.7)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.4)
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 0.9, green: 0.7, blue: 0.2)
    static let error = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.1, blue: 0.25),
            Color(red: 0.15, green: 0.2, blue: 0.35),
            Color(red: 0.1, green: 0.15, blue: 0.3)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.2, green: 0.25, blue: 0.4).opacity(0.8),
            Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.6)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [lightBlue, Color(red: 0.1, green: 0.5, blue: 0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let orangeGradient = LinearGradient(
        colors: [orange, Color(red: 0.9, green: 0.5, blue: 0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension View {
    func appBackground() -> some View {
        self.background(AppColors.backgroundGradient.ignoresSafeArea())
    }
}
