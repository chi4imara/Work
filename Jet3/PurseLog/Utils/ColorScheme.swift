import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [primaryBlue, primaryYellow.opacity(0.3)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.9)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let darkText = Color.black
    static let lightText = Color.white
    
    static let accent = primaryPurple
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let buttonPrimary = primaryPurple
    static let buttonSecondary = Color.white.opacity(0.2)
    static let tabBarBackground = Color.white.opacity(0.1)
    static let tabBarSelected = primaryYellow
    static let tabBarUnselected = Color.white.opacity(0.6)
    
    static let shadowColor = Color.black.opacity(0.1)
    static let cardShadow = Color.black.opacity(0.05)
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Circle()
                .fill(AppColors.primaryYellow.opacity(0.1))
                .frame(width: 300, height: 300)
                .blur(radius: 100)
                .offset(x: 100, y: -200)
            
            Circle()
                .fill(AppColors.primaryPurple.opacity(0.1))
                .frame(width: 200, height: 200)
                .blur(radius: 80)
                .offset(x: -150, y: 300)
        }
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
