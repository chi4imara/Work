import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.35, green: 0.65, blue: 0.9)
    static let secondaryBlue = Color(red: 0.45, green: 0.75, blue: 0.95)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.9)
    static let accentText = Color.black
    
    static let primaryAccent = Color(red: 1.0, green: 0.85, blue: 0.2)
    static let accentLight = Color(red: 1.0, green: 0.9, blue: 0.4)
    
    static let primaryBackground = LinearGradient(
        colors: [primaryBlue, secondaryBlue, darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.2)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let success = Color.green
    static let warning = Color.orange
    static let info = Color.blue
    static let lightGray = Color.gray.opacity(0.3)
    
    static let softGradient = LinearGradient(
        colors: [primaryAccent.opacity(0.25), primaryAccent.opacity(0.1)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let buttonGradient = LinearGradient(
        colors: [primaryAccent.opacity(0.9), accentLight.opacity(0.8)],
        startPoint: .top,
        endPoint: .bottom
    )
}

struct BackgroundView: View {
    var body: some View {
        AppColors.primaryBackground
            .ignoresSafeArea(.all)
    }
}
