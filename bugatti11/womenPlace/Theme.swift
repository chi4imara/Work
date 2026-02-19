import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let accentYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let brightYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 1.0, green: 0.9, blue: 0.3)
    
    static let softPink = Color(red: 1.0, green: 0.8, blue: 0.9)
    static let lightGreen = Color(red: 0.7, green: 1.0, blue: 0.8)
    static let lavender = Color(red: 0.9, green: 0.8, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, lightBlue, darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let gridColor = Color.white.opacity(0.1)
}

struct AppFonts {
    static func playfairRegular(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Regular", size: size)
    }
    
    static func playfairMedium(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Medium", size: size)
    }
    
    static func playfairSemiBold(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-SemiBold", size: size)
    }
    
    static func playfairBold(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Bold", size: size)
    }
    
    static func playfairExtraBold(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-ExtraBold", size: size)
    }
    
    static func playfairItalic(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Italic", size: size)
    }
}

struct GridBackgroundView: View {
    let spacing: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for x in stride(from: 0, through: geometry.size.width, by: spacing) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                for y in stride(from: 0, through: geometry.size.height, by: spacing) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(AppColors.gridColor, lineWidth: 0.5)
        }
    }
}

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
                .ignoresSafeArea()
        }
    }
}
