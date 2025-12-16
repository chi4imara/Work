import SwiftUI

struct AppColors {
    static let primaryPurple = Color(red: 0.5, green: 0.3, blue: 0.8)
    static let secondaryPurple = Color(red: 0.7, green: 0.5, blue: 0.9)
    
    static let blueText = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let yellowAccent = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    static let mintGreen = Color(red: 0.6, green: 0.9, blue: 0.8)
    static let lavender = Color(red: 0.8, green: 0.7, blue: 0.9)
    
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let contrastText = Color.white
    
    static let purpleGradient = LinearGradient(
        colors: [primaryPurple, secondaryPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, backgroundGray, Color(red: 0.9, green: 0.9, blue: 0.95)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [yellowAccent, Color(red: 1.0, green: 0.9, blue: 0.4)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 100) {
                ForEach(0..<5, id: \.self) { _ in
                    HStack(spacing: 100) {
                        ForEach(0..<3, id: \.self) { _ in
                            Circle()
                                .fill(AppColors.lavender.opacity(0.1))
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .rotationEffect(.degrees(15))
        }
    }
}
