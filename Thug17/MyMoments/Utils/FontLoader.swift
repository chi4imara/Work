import SwiftUI
import UIKit

class FontLoader {
    static let shared = FontLoader()
    
    private init() {
        loadCustomFonts()
    }
    
    private func loadCustomFonts() {
        let fontNames = [
            "Nunito-Regular",
            "Nunito-Medium", 
            "Nunito-SemiBold",
            "Nunito-Bold"
        ]
        
        for fontName in fontNames {
            if let url = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
    
    static func availableFonts() -> [String] {
        return UIFont.familyNames.sorted()
    }
    
    static func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 16) != nil
    }
}

extension FontLoader {
    static func registerFonts() {
        let fontFiles = [
            "Nunito-Regular.ttf",
            "Nunito-Medium.ttf",
            "Nunito-SemiBold.ttf", 
            "Nunito-Bold.ttf"
        ]
        
        for fontFile in fontFiles {
            guard let fontURL = Bundle.main.url(forResource: fontFile.replacingOccurrences(of: ".ttf", with: ""), withExtension: "ttf") else {
                print("⚠️ Font file \(fontFile) not found in bundle")
                continue
            }
            
            guard let fontData = NSData(contentsOf: fontURL) else {
                print("⚠️ Could not load font data for \(fontFile)")
                continue
            }
            
            guard let provider = CGDataProvider(data: fontData) else {
                print("⚠️ Could not create data provider for \(fontFile)")
                continue
            }
            
            guard let font = CGFont(provider) else {
                print("⚠️ Could not create font from data for \(fontFile)")
                continue
            }
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                if let error = error {
                    let errorDescription = CFErrorCopyDescription(error.takeRetainedValue())
                    print("⚠️ Failed to register font \(fontFile): \(errorDescription ?? "Unknown error" as CFString)")
                }
            } else {
                print("✅ Successfully registered font \(fontFile)")
            }
        }
    }
}
