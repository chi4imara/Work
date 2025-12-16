import SwiftUI
import Combine

class ColorTheme: ObservableObject {
    static let shared = ColorTheme()
    
    private init() {}
    
    let primaryPurple = Color(red: 0.4, green: 0.2, blue: 0.8)
    let secondaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    let lightPurple = Color(red: 0.8, green: 0.7, blue: 0.95)
    
    let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    let lightBlue = Color(red: 0.7, green: 0.85, blue: 0.95)
    
    let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    let lightYellow = Color(red: 1.0, green: 0.95, blue: 0.7)
    
    let primaryWhite = Color.white
    let softWhite = Color(red: 0.98, green: 0.98, blue: 0.99)
    
    let statusIdea = Color.gray
    let statusInProgress = Color.orange
    let statusCompleted = Color.green
    
    var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [primaryWhite, lightPurple, softWhite],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var cardGradient: LinearGradient {
        LinearGradient(
            colors: [primaryWhite, softWhite],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var purpleGradient: LinearGradient {
        LinearGradient(
            colors: [primaryPurple, secondaryPurple],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var blueGradient: LinearGradient {
        LinearGradient(
            colors: [primaryBlue, lightBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    let primaryText = Color.black
    let secondaryText = Color.gray
    let accentText = Color(red: 0.2, green: 0.6, blue: 0.9)
    
    let shadowColor = Color.black.opacity(0.1)
}

extension Color {
    static let theme = ColorTheme.shared
}
