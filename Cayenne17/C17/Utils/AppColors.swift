import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let white = Color.white
    
    static let gray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let green = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let red = Color(red: 0.9, green: 0.2, blue: 0.2)
    
    static let backgroundGradient = LinearGradient(
        colors: [darkBlue, Color(red: 0.15, green: 0.2, blue: 0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color(red: 0.2, green: 0.25, blue: 0.4), Color(red: 0.15, green: 0.2, blue: 0.35)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
