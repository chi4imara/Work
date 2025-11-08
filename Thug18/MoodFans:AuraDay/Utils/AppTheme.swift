import SwiftUI
import UIKit

struct AppTheme {
    struct Colors {
        static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
        static let backgroundBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
        static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
        
        static let primaryText = Color.white
        static let secondaryText = Color.white.opacity(0.8)
        static let tertiaryText = Color.white.opacity(0.6)
        
        static let cardBackground = Color.white.opacity(0.1)
        static let overlayBackground = Color.black.opacity(0.3)
        
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        
        static let backgroundGradient = LinearGradient(
            colors: [
                Color(red: 0.2, green: 0.5, blue: 0.8),
                Color(red: 0.4, green: 0.7, blue: 1.0),
                Color(red: 0.3, green: 0.6, blue: 0.9)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let cardGradient = LinearGradient(
            colors: [
                Color.white.opacity(0.2),
                Color.white.opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    struct Fonts {
        private static let poppinsLight = "Poppins-Light"
        private static let poppinsRegular = "Poppins-Regular"
        private static let poppinsMedium = "Poppins-Medium"
        private static let poppinsSemiBold = "Poppins-SemiBold"
        private static let poppinsBold = "Poppins-Bold"
        
        static let largeTitle = Font.custom(poppinsBold, size: 28)
        static let title1 = Font.custom(poppinsBold, size: 28)
        static let title2 = Font.custom(poppinsBold, size: 22)
        static let title3 = Font.custom(poppinsSemiBold, size: 20)
        static let headline = Font.custom(poppinsSemiBold, size: 17)
        static let body = Font.custom(poppinsRegular, size: 17)
        static let callout = Font.custom(poppinsRegular, size: 16)
        static let subheadline = Font.custom(poppinsRegular, size: 15)
        static let footnote = Font.custom(poppinsRegular, size: 13)
        static let caption1 = Font.custom(poppinsRegular, size: 12)
        static let caption2 = Font.custom(poppinsRegular, size: 11)
        
        static let buttonFont = Font.custom(poppinsMedium, size: 16)
        static let navigationTitle = Font.custom(poppinsBold, size: 20)
        static let tabBarFont = Font.custom(poppinsMedium, size: 10)
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    struct Shadow {
        static let light = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.2)
        static let heavy = Color.black.opacity(0.3)
    }
}

extension AppTheme {
    static func registerFonts() {
        let fontNames = [
            "Poppins-Light",
            "Poppins-Regular", 
            "Poppins-Medium",
            "Poppins-SemiBold",
            "Poppins-Bold"
        ]
        
        for fontName in fontNames {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
                print("Could not find font file: \(fontName).ttf")
                continue
            }
            
            guard let fontData = NSData(contentsOf: fontURL) else {
                print("Could not load font data for: \(fontName)")
                continue
            }
            
            guard let dataProvider = CGDataProvider(data: fontData) else {
                print("Could not create data provider for: \(fontName)")
                continue
            }
            
            guard let font = CGFont(dataProvider) else {
                print("Could not create font from data provider for: \(fontName)")
                continue
            }
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                if let error = error?.takeRetainedValue() {
                    print("Error registering font \(fontName): \(error)")
                } else {
                    print("Error registering font \(fontName): Unknown error")
                }
            }
        }
    }
}
