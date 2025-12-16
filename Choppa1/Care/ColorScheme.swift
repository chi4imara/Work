import SwiftUI

struct AppColors {
    static let primaryBackground = Color.white
    static let primaryText = Color.blue
    static let accentYellow = Color.yellow
    
    static let purpleGradientStart = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let purpleGradientEnd = Color(red: 0.8, green: 0.6, blue: 1.0)
    
    static let cardBackground = Color.white.opacity(0.9)
    static let shadowColor = Color.black.opacity(0.1)
    static let secondaryText = Color.gray
    static let successGreen = Color.green
    static let warningRed = Color.red
    
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [primaryBackground, purpleGradientStart.opacity(0.3)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var purpleGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [purpleGradientStart, purpleGradientEnd]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
