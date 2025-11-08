import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let lightBlue = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.8)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.98)
    
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let blueText = primaryBlue
    
    static let accent = Color(red: 0.0, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.6, blue: 0.0)
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let cardBackground = Color.white
    static let cardShadow = Color.black.opacity(0.1)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.95, green: 0.97, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueGradient = LinearGradient(
        gradient: Gradient(colors: [lightBlue, primaryBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let orbColors = [
        lightBlue.opacity(0.3),
        primaryBlue.opacity(0.2),
        Color(red: 0.6, green: 0.9, blue: 1.0).opacity(0.25),
        Color(red: 0.3, green: 0.7, blue: 1.0).opacity(0.2)
    ]
}
