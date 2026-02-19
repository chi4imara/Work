import SwiftUI

struct ColorManager {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.gray
    
    static let primaryBackground = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.05, green: 0.1, blue: 0.25),
            Color(red: 0.1, green: 0.15, blue: 0.35),
            Color(red: 0.15, green: 0.2, blue: 0.4)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.8)
    
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    
    static let primaryButton = lightBlue
    static let secondaryButton = orange
    static let destructiveButton = error
}
