import UIKit
import SwiftUI

class FontHelper {
    static let shared = FontHelper()
    private var fontsRegistered = false
    
    private init() {}
    
    func registerFonts() {
        guard !fontsRegistered else { return }
        
        let fontNames = [
            "BuilderSans-Thin-100",
            "BuilderSans-Light-300",
            "BuilderSans-Regular-400", 
            "BuilderSans-Medium-500",
            "BuilderSans-SemiBold-600",
            "BuilderSans-Bold-700",
            "BuilderSans-ExtraBold-800"
        ]
        
        for fontName in fontNames {
            registerFont(named: fontName)
        }
        
        fontsRegistered = true
    }
    
    private func registerFont(named fontName: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "otf") else {
            print("❌ Font file not found: \(fontName).otf")
            return
        }
        
        guard let fontData = NSData(contentsOf: fontURL) else {
            print("❌ Could not load font data for: \(fontName)")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("❌ Could not create data provider for: \(fontName)")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            print("❌ Could not create font from data for: \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if success {
            print("✅ Successfully registered font: \(fontName)")
        } else {
            if let error = error {
                let errorDescription = CFErrorCopyDescription(error.takeRetainedValue())
                print("❌ Failed to register font \(fontName): \(errorDescription ?? "Unknown error" as CFString)")
            } else {
                print("⚠️ Font \(fontName) might already be registered")
            }
        }
    }
    
    func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 16) != nil
    }
    
    func listAvailableFonts() {
        print("📋 Available fonts:")
        for family in UIFont.familyNames.sorted() {
            print("Family: \(family)")
            for font in UIFont.fontNames(forFamilyName: family) {
                if font.contains("BuilderSans") {
                    print("  - \(font)")
                }
            }
        }
    }
}
