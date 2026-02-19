import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let lightBlue = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let white = Color.white
    
    static let gray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let green = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let red = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let primaryGradient = LinearGradient(
        colors: [darkBlue, Color(red: 0.15, green: 0.25, blue: 0.5)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [lightBlue, Color(red: 0.4, green: 0.7, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color(red: 0.2, green: 0.3, blue: 0.5), Color(red: 0.15, green: 0.25, blue: 0.45)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
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
                            Color.white.opacity(0.1),
                            Color.clear,
                            Color.black.opacity(0.2)
                        ],
                        center: .topTrailing,
                        startRadius: 50,
                        endRadius: 400
                    )
                )
                .ignoresSafeArea()
        }
    }
}
