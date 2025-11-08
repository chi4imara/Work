import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.8, green: 0.9, blue: 1.0)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.98)
    
    static let textPrimary = Color.black
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let textBlue = Color.primaryBlue
    
    static let statusWatching = Color.primaryBlue
    static let statusWaiting = Color(red: 0.6, green: 0.6, blue: 0.6)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let gridOverlay = Color.lightBlue.opacity(0.4)
}
