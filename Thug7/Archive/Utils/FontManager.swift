import UIKit
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private var registeredFonts: [String: UIFont] = [:]
    
    private init() {
        registerFonts()
    }
    
    private func registerFonts() {
        let fontFiles = [
            "Poppins-Regular": "Poppins-Regular",
            "Poppins-Medium": "Poppins-Medium", 
            "Poppins-SemiBold": "Poppins-SemiBold",
            "Poppins-Bold": "Poppins-Bold",
            "Poppins-Light": "Poppins-Light"
        ]
        
        for (fontName, fileName) in fontFiles {
            if let fontURL = Bundle.main.url(forResource: fileName, withExtension: "ttf") {
                if let fontData = NSData(contentsOf: fontURL) {
                    if let provider = CGDataProvider(data: fontData) {
                        if let font = CGFont(provider) {
                            var error: Unmanaged<CFError>?
                            if CTFontManagerRegisterGraphicsFont(font, &error) {
                                print("✅ Successfully registered font: \(fontName)")
                                registeredFonts[fontName] = UIFont(name: fontName, size: 16)
                            } else {
                                print("❌ Failed to register font: \(fontName)")
                                if let error = error?.takeRetainedValue() {
                                    print("Error: \(error)")
                                }
                            }
                        }
                    }
                }
            } else {
                print("❌ Font file not found: \(fileName).ttf")
            }
        }
    }
    
    func getFont(name: String, size: CGFloat) -> UIFont? {
        return registeredFonts[name]?.withSize(size)
    }
    
    func isFontAvailable(_ name: String) -> Bool {
        return registeredFonts[name] != nil
    }
    
    func printRegisteredFonts() {
        print("=== REGISTERED FONTS ===")
        for (name, font) in registeredFonts {
            print("✅ \(name): \(font.fontName)")
        }
        print("=== END REGISTERED FONTS ===")
    }
}
