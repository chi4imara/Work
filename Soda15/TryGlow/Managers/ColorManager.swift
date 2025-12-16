import SwiftUI
import Combine

class ColorManager: ObservableObject {
    static let shared = ColorManager()
    
    private init() {}
    
    let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    let primaryWhite = Color.white
    
    let secondaryPink = Color(red: 1.0, green: 0.6, blue: 0.8)
    let secondaryGreen = Color(red: 0.4, green: 0.9, blue: 0.6)
    let secondaryOrange = Color(red: 1.0, green: 0.7, blue: 0.3)
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [primaryBlue, primaryYellow]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var cardGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [primaryWhite.opacity(0.9), primaryWhite.opacity(0.7)]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var accentGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [primaryPurple, secondaryPink]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    let primaryText = Color.white
    let secondaryText = Color.black
    let accentText = Color(red: 0.6, green: 0.4, blue: 0.9)
}
