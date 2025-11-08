import SwiftUI

struct AppTheme {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 0.9)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 0.95)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let primaryYellow = Color(red: 1.0, green: 0.85, blue: 0.0)
    static let lightYellow = Color(red: 1.0, green: 0.95, blue: 0.6)
    static let darkYellow = Color(red: 0.9, green: 0.7, blue: 0.0)
    
    static let primaryWhite = Color.white
    static let offWhite = Color(red: 0.98, green: 0.98, blue: 0.98)
    
    static let statusGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let statusYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let statusRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let gridWhite = Color.white.opacity(0.3)
    static let shadowColor = Color.black.opacity(0.1)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, lightBlue, darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [primaryWhite.opacity(0.9), offWhite.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let yellowGradient = LinearGradient(
        colors: [primaryYellow, lightYellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Font {
    static func playfairDisplay(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .black:
            fontName = "PlayfairDisplay-Black"
        case .bold:
            fontName = "PlayfairDisplay-Bold"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBold"
        case .medium:
            fontName = "PlayfairDisplay-Medium"
        default:
            fontName = "PlayfairDisplay-Regular"
        }
        
        return Font.custom(fontName, size: size)
    }
    
    static func playfairDisplayItalic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .black:
            fontName = "PlayfairDisplay-BlackItalic"
        case .bold:
            fontName = "PlayfairDisplay-BoldItalic"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBoldItalic"
        case .medium:
            fontName = "PlayfairDisplay-MediumItalic"
        default:
            fontName = "PlayfairDisplay-Italic"
        }
        
        return Font.custom(fontName, size: size)
    }
    
    static let appTitle = Font.playfairDisplay(size: 28, weight: .bold)
    static let screenTitle = Font.playfairDisplay(size: 24, weight: .semibold)
    static let cardTitle = Font.playfairDisplay(size: 20, weight: .medium)
    
    static let appBody = Font.playfairDisplay(size: 16)
    static let appBodyBold = Font.playfairDisplay(size: 16, weight: .semibold)
    static let appCaption = Font.playfairDisplay(size: 14)
    static let appSmall = Font.playfairDisplay(size: 12)
    
    static let buttonLarge = Font.playfairDisplay(size: 18, weight: .semibold)
    static let buttonMedium = Font.playfairDisplay(size: 16, weight: .medium)
    static let buttonSmall = Font.playfairDisplay(size: 14, weight: .medium)
    
    static let appLargeTitle = Font.playfairDisplay(size: 32, weight: .bold)
    static let appHeadline = Font.playfairDisplay(size: 22, weight: .semibold)
    static let appSubheadline = Font.playfairDisplay(size: 18, weight: .medium)
    static let appFootnote = Font.playfairDisplay(size: 13)
    static let appTiny = Font.playfairDisplay(size: 10)
}

struct GridBackgroundView: View {
    let gridSize: CGFloat = 30
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let verticalLines = Int(geometry.size.width / gridSize) + 1
                for i in 0..<verticalLines {
                    let x = CGFloat(i) * gridSize
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                let horizontalLines = Int(geometry.size.height / gridSize) + 1
                for i in 0..<horizontalLines {
                    let y = CGFloat(i) * gridSize
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(AppTheme.gridWhite, lineWidth: 1)
        }
    }
}
