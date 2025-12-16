import SwiftUI

struct ColorManager {
    static let primaryBackground = Color.white
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.purple.opacity(0.4)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryText = Color.blue
    static let secondaryText = Color.gray
    static let accentText = Color.white
    
    static let accentYellow = Color.yellow
    static let accentOrange = Color.orange
    static let accentPink = Color.pink
    static let accentMint = Color.mint
    
    static let statusGood = Color.green
    static let statusWorn = Color.yellow
    static let statusBad = Color.red
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color.purple.opacity(0.1),
            Color.blue.opacity(0.05)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white.opacity(0.9),
            Color.purple.opacity(0.1)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryButton = LinearGradient(
        gradient: Gradient(colors: [Color.purple, Color.blue]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let secondaryButton = LinearGradient(
        gradient: Gradient(colors: [Color.yellow, Color.orange]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let shadowColor = Color.black.opacity(0.1)
    static let cardShadow = Color.purple.opacity(0.2)
}
