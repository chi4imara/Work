import SwiftUI
import UIKit

class FontInitializer {
    static let shared = FontInitializer()
    
    private var fontsLoaded = false
    
    private init() {
        loadFonts()
    }
    
    func loadFonts() {
        guard !fontsLoaded else { return }
        
        let fontNames = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium", 
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-Black"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                if let fontData = NSData(contentsOf: fontURL) {
                    let provider = CGDataProvider(data: fontData)
                    if let font = CGFont(provider!) {
                        var error: Unmanaged<CFError>?
                        if !CTFontManagerRegisterGraphicsFont(font, &error) {
                            if let error = error?.takeUnretainedValue() {
                                print("Failed to load font \(fontName): \(error)")
                            } else {
                                print("Failed to load font \(fontName): Unknown error")
                            }
                        } else {
                            print("Successfully loaded font: \(fontName)")
                        }
                    }
                }
            } else {
                print("Font file not found: \(fontName).ttf")
            }
        }
        
        fontsLoaded = true
        
        printAvailableFonts()
    }
    
    func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 16) != nil
    }
    
    func getAvailableFonts() -> [String] {
        let fontNames = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-SemiBold", 
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-Black"
        ]
        
        return fontNames.filter { isFontAvailable($0) }
    }
    
    private func printAvailableFonts() {
        print("=== FONT DEBUG INFO ===")
        
        let availableFonts = getAvailableFonts()
        print("Available Playfair Display fonts: \(availableFonts)")
        
        if availableFonts.isEmpty {
            print("⚠️ No Playfair Display fonts found! Using system fonts as fallback.")
        } else {
            print("✅ Successfully loaded \(availableFonts.count) Playfair Display fonts")
        }
        
        let allFonts = UIFont.familyNames.sorted()
        let playfairFonts = allFonts.filter { $0.contains("Playfair") }
        print("Playfair fonts in system: \(playfairFonts)")
        
        print("=== END FONT DEBUG ===")
    }
}
