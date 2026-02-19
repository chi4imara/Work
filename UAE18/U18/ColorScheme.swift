import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.5, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let accent = Color(red: 0.3, green: 0.7, blue: 1.0)
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let primaryGradient = LinearGradient(
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
            Color.white.opacity(0.1),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [lightBlue, accent],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let orangeGradient = LinearGradient(
        colors: [orange, Color(red: 1.0, green: 0.6, blue: 0.3)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            Rectangle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.02),
                            Color.clear,
                            Color.black.opacity(0.1)
                        ],
                        center: .topTrailing,
                        startRadius: 100,
                        endRadius: 400
                    )
                )
                .ignoresSafeArea()
        }
    }
}
