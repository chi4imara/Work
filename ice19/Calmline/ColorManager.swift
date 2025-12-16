import SwiftUI
import Combine

class ColorManager: ObservableObject {
    static let shared = ColorManager()
    
    private init() {}
    
    let primaryWhite = Color.white
    let primaryPurple = Color(red: 0.4, green: 0.2, blue: 0.8)
    let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    let softGreen = Color(red: 0.3, green: 0.8, blue: 0.5)
    let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    let accentPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    
    var purpleGradient: LinearGradient {
        LinearGradient(
            colors: [primaryPurple, primaryPurple.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [primaryWhite, Color(red: 0.95, green: 0.95, blue: 1.0)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var cardGradient: LinearGradient {
        LinearGradient(
            colors: [primaryWhite, Color(red: 0.98, green: 0.98, blue: 1.0)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
