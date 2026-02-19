import SwiftUI

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    let backgroundWhite = Color.white
    
    let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.6)
    let accentOrange = Color(red: 1.0, green: 0.5, blue: 0.2)
    let softGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    let backgroundGradient = LinearGradient(
        colors: [Color.white, Color(red: 0.98, green: 0.99, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let cardGradient = LinearGradient(
        colors: [Color.white, Color(red: 0.97, green: 0.98, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let buttonGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.8, blue: 0.0), Color(red: 1.0, green: 0.6, blue: 0.0)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    static let theme = ColorManager.shared
}
