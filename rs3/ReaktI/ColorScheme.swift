import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let accentOrange = Color(red: 1.0, green: 0.5, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    
    static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.2)
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.5)
    static let textOnDark = Color.white
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.95, green: 0.98, blue: 1.0),
            Color(red: 0.92, green: 0.96, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.9),
            Color(red: 0.98, green: 0.99, blue: 1.0).opacity(0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [primaryBlue, primaryBlue.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let yellowButtonGradient = LinearGradient(
        colors: [primaryYellow, primaryYellow.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Circle()
                .fill(AppColors.primaryBlue.opacity(0.05))
                .frame(width: 300, height: 300)
                .offset(x: -100, y: -200)
            
            Circle()
                .fill(AppColors.primaryYellow.opacity(0.03))
                .frame(width: 200, height: 200)
                .offset(x: 150, y: 100)
            
            Circle()
                .fill(AppColors.accentPurple.opacity(0.04))
                .frame(width: 250, height: 250)
                .offset(x: -50, y: 300)
        }
    }
}
