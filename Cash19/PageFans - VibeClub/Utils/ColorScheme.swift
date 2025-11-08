import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.7)
    
    static let backgroundColor = Color.white
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let lightText = Color(red: 0.4, green: 0.6, blue: 0.8)
    
    static let readingColor = Color.blue
    static let completedColor = Color.green
    static let wantToReadColor = Color.orange
    
    static let accentColor = primaryBlue
    static let destructiveColor = Color.red
    static let warningColor = Color.orange
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.95, green: 0.98, blue: 1.0),
            Color(red: 0.9, green: 0.95, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let bubbleGradient = RadialGradient(
        gradient: Gradient(colors: [
            lightBlue.opacity(0.3),
            primaryBlue.opacity(0.1),
            Color.clear
        ]),
        center: .center,
        startRadius: 20,
        endRadius: 100
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            cardBackground,
            Color(red: 0.96, green: 0.98, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct BubbleEffect: View {
    @State private var animate = false
    let size: CGFloat
    let delay: Double
    
    var body: some View {
        Circle()
            .fill(AppColors.bubbleGradient)
            .frame(width: size, height: size)
            .scaleEffect(animate ? 1.2 : 0.8)
            .opacity(animate ? 0.3 : 0.6)
            .animation(
                Animation.easeInOut(duration: 3.0 + delay)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    animate = true
                }
            }
    }
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    BubbleEffect(size: 80, delay: 0.0)
                    Spacer()
                    BubbleEffect(size: 60, delay: 1.0)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                HStack {
                    Spacer()
                    BubbleEffect(size: 100, delay: 2.0)
                }
                .padding(.horizontal, 50)
                
                Spacer()
                
                HStack {
                    BubbleEffect(size: 70, delay: 1.5)
                    Spacer()
                }
                .padding(.horizontal, 40)
            }
            .padding(.vertical, 100)
        }
    }
}
