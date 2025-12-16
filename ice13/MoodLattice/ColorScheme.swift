import SwiftUI

struct AppColors {
    static let background = Color.white
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.purple]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryText = Color.blue
    static let secondaryText = Color.gray
    static let accentText = Color.white
    
    static let accent = Color.yellow
    static let cardBackground = Color.white.opacity(0.9)
    static let shadowColor = Color.black.opacity(0.1)
    
    static let happyMood = Color.green
    static let calmMood = Color.blue.opacity(0.7)
    static let neutralMood = Color.gray
    static let sadMood = Color.orange
    static let angryMood = Color.red
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
}

struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white,
                Color.purple.opacity(0.1),
                Color.blue.opacity(0.05)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
