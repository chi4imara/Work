import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let lightPurple = Color(red: 0.7, green: 0.5, blue: 0.95)
    static let darkPurple = Color(red: 0.5, green: 0.3, blue: 0.8)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 0.9, green: 0.9, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [primaryBlue, lightBlue, primaryPurple]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let buttonBackground = primaryPurple
    static let buttonText = Color.white
    static let disabledButton = Color.gray.opacity(0.5)
    
    static let wantColor = Color.green.opacity(0.8)
    static let dontWantColor = Color.red.opacity(0.8)
    
    static let orbColor1 = Color.white.opacity(0.1)
    static let orbColor2 = Color.white.opacity(0.05)
    static let orbColor3 = Color.white.opacity(0.08)
}

struct AnimatedBackground: View {
    @State private var moveOrbs = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(orbColor(for: index))
                    .frame(width: orbSize(for: index), height: orbSize(for: index))
                    .offset(x: moveOrbs ? randomOffset() : -randomOffset(),
                           y: moveOrbs ? randomOffset() : -randomOffset())
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: moveOrbs
                    )
            }
        }
        .onAppear {
            moveOrbs = true
        }
    }
    
    private func orbColor(for index: Int) -> Color {
        switch index % 3 {
        case 0: return AppColors.orbColor1
        case 1: return AppColors.orbColor2
        default: return AppColors.orbColor3
        }
    }
    
    private func orbSize(for index: Int) -> CGFloat {
        CGFloat.random(in: 60...120)
    }
    
    private func randomOffset() -> CGFloat {
        CGFloat.random(in: -150...150)
    }
}
