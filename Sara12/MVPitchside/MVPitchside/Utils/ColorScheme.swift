import SwiftUI

extension Color {
    static let primaryBackground = Color.white
    static let primaryText = Color.black
    static let primaryAccent = Color.red
    
    static let secondaryBackground = Color.gray.opacity(0.1)
    static let secondaryText = Color.gray
    static let cardBackground = Color.white
    
    static let successColor = Color.green
    static let warningColor = Color.orange
    static let errorColor = Color.red
    static let infoColor = Color.blue
    
    static let gradientStart = Color.white
    static let gradientEnd = Color.gray.opacity(0.2)
    
    static let tabBarBackground = Color.white
    static let tabBarSelected = Color.red
    static let tabBarUnselected = Color.gray
    
    static let shadowColor = Color.black.opacity(0.1)
}

struct AppGradient {
    static let background = BubbleBackground()
    
    static let card = LinearGradient(
        gradient: Gradient(colors: [Color.cardBackground, Color.secondaryBackground]),
        startPoint: .top,
        endPoint: .bottom
    )
}

struct BubbleBackground: View {
    let bubbleCount = 30
    let minBubbleSize: CGFloat = 20
    let maxBubbleSize: CGFloat = 100
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.gradientStart, Color.gradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                ForEach(0..<bubbleCount, id: \.self) { _ in
                    Circle()
                        .fill(Color.primaryAccent.opacity(0.15))
                        .frame(width: CGFloat.random(in: minBubbleSize...maxBubbleSize))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            .ignoresSafeArea()
        }
    }
}
