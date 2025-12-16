import SwiftUI

extension Color {
    static let primaryBackground = Color.white
    static let primaryPurple = Color(red: 0.5, green: 0.3, blue: 0.8)
    static let secondaryPurple = Color(red: 0.7, green: 0.4, blue: 0.9)
    
    static let accentBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let softGreen = Color(red: 0.4, green: 0.8, blue: 0.6)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let purpleGradient = LinearGradient(
        colors: [primaryPurple, secondaryPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBackground, lightGray],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let accentGradient = LinearGradient(
        colors: [accentBlue, primaryPurple],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct GradientBackground: View {
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            Circle()
                .fill(Color.primaryPurple.opacity(0.1))
                .frame(width: 200, height: 200)
                .offset(x: -100, y: -200)
            
            Circle()
                .fill(Color.accentBlue.opacity(0.1))
                .frame(width: 150, height: 150)
                .offset(x: 120, y: 100)
            
            Circle()
                .fill(Color.accentYellow.opacity(0.1))
                .frame(width: 100, height: 100)
                .offset(x: -80, y: 150)
        }
    }
}
