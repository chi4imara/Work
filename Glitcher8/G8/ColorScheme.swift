import SwiftUI

extension Color {
    static let primaryBackground = Color("PrimaryBackground")
    static let secondaryBackground = Color("SecondaryBackground")
    static let primaryText = Color("PrimaryText")
    static let secondaryText = Color("SecondaryText")
    
    static let accentBlue = Color("AccentBlue")
    static let accentOrange = Color("AccentOrange")
    static let accentGreen = Color("AccentGreen")
    static let accentRed = Color("AccentRed")
    
    static let darkBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let lightBlue = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let brightOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let softGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let softRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    static let pureWhite = Color.white
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
}

struct GradientBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.darkBlue,
                Color(red: 0.15, green: 0.25, blue: 0.5),
                Color(red: 0.2, green: 0.3, blue: 0.6)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct RadialGradientBackground: View {
    var body: some View {
        RadialGradient(
            gradient: Gradient(colors: [
                Color(red: 0.2, green: 0.3, blue: 0.6),
                Color.darkBlue,
                Color(red: 0.05, green: 0.1, blue: 0.3)
            ]),
            center: .center,
            startRadius: 100,
            endRadius: 400
        )
        .ignoresSafeArea()
    }
}
