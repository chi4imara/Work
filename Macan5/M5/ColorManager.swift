import SwiftUI

struct ColorManager {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    
    static let statusInUse = Color.green
    static let statusInStock = Color.blue
    static let statusNeedToBuy = Color.red
    
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightGray],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let orbColors = [primaryBlue, primaryYellow, accentPurple, softPink]
}
