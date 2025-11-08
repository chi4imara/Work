import SwiftUI
import UIKit

struct FontHelper {
    static func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 16) != nil
    }
    
    static func availableFonts() -> [String] {
        return UIFont.familyNames.flatMap { familyName in
            UIFont.fontNames(forFamilyName: familyName)
        }.filter { $0.contains("Poppins") }
    }
    
    static func printAvailableFonts() {
        print("=== FONT DEBUG INFO ===")
        
        let fontFiles = ["Poppins-Regular.ttf", "Poppins-Medium.ttf", "Poppins-SemiBold.ttf", "Poppins-Bold.ttf", "Poppins-Light.ttf"]
        print("Checking font files in bundle:")
        for fontFile in fontFiles {
            if let path = Bundle.main.path(forResource: fontFile.replacingOccurrences(of: ".ttf", with: ""), ofType: "ttf") {
                print("✅ Found: \(fontFile) at \(path)")
            } else {
                print("❌ Missing: \(fontFile)")
            }
        }
        
        print("\nAvailable Poppins fonts:")
        let poppinsFonts = availableFonts()
        if poppinsFonts.isEmpty {
            print("❌ No Poppins fonts found!")
        } else {
            for font in poppinsFonts {
                print("✅ - \(font)")
            }
        }
        
        print("\nAll available font families:")
        for family in UIFont.familyNames.sorted() {
            print("Family: \(family)")
            for fontName in UIFont.fontNames(forFamilyName: family) {
                print("  - \(fontName)")
            }
        }
        print("=== END FONT DEBUG ===")
    }
}

extension Font {
    func fallback(_ fallbackFont: Font) -> Font {
        return self
    }
}
