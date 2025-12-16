import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    
    static let backgroundWhite = Color.white
    static let backgroundLight = Color(red: 0.98, green: 0.98, blue: 1.0)
    
    static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.2)
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.5)
    static let textLight = Color(red: 0.6, green: 0.6, blue: 0.7)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            backgroundWhite,
            Color(red: 0.95, green: 0.95, blue: 1.0),
            Color(red: 0.9, green: 0.9, blue: 0.98)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let purpleGradient = LinearGradient(
        gradient: Gradient(colors: [
            primaryPurple.opacity(0.3),
            primaryBlue.opacity(0.2)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            backgroundWhite,
            backgroundLight
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Circle()
                .fill(AppColors.primaryPurple.opacity(0.1))
                .frame(width: 200, height: 200)
                .offset(x: -100, y: -300)
            
            Circle()
                .fill(AppColors.primaryBlue.opacity(0.08))
                .frame(width: 150, height: 150)
                .offset(x: 120, y: -200)
            
            Circle()
                .fill(AppColors.primaryYellow.opacity(0.06))
                .frame(width: 180, height: 180)
                .offset(x: -80, y: 250)
        }
    }
}
