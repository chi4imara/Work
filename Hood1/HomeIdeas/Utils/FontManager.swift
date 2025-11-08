import UIKit
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private var loadedFonts: [String: UIFont] = [:]
    
    private init() {
        loadCustomFonts()
    }
    
    private func loadCustomFonts() {
        let fontNames = [
            "Raleway-Light",
            "Raleway-Regular", 
            "Raleway-Medium",
            "Raleway-SemiBold",
            "Raleway-Bold"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                if let fontData = NSData(contentsOf: fontURL) {
                    if let provider = CGDataProvider(data: fontData) {
                        if let font = CGFont(provider) {
                            var error: Unmanaged<CFError>?
                            if CTFontManagerRegisterGraphicsFont(font, &error) {
                                print("Successfully loaded font: \(fontName)")
                                if let testFont = UIFont(name: fontName, size: 16) {
                                    loadedFonts[fontName] = testFont
                                    print("Font \(fontName) is available for use")
                                }
                            } else {
                                if let error = error?.takeUnretainedValue() {
                                    print("Failed to register font: \(fontName), error: \(error)")
                                } else {
                                    print("Failed to register font: \(fontName), unknown error")
                                }
                            }
                        }
                    }
                }
            } else {
                print("Font file not found: \(fontName).ttf")
            }
        }
    }
    
    func getFont(name: String, size: CGFloat) -> UIFont? {
        if let loadedFont = loadedFonts[name] {
            return UIFont(name: name, size: size)
        }
        return nil
    }
    
    func isFontLoaded(_ name: String) -> Bool {
        return loadedFonts[name] != nil
    }
    
    func getAvailableFonts() -> [String] {
        return Array(loadedFonts.keys)
    }
}
