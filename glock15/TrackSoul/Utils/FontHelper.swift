import UIKit
import SwiftUI

class FontHelper {
    static let shared = FontHelper()
    
    private init() {
        registerFonts()
    }
    
    private func registerFonts() {
        let fontNames = [
            "Nunito-Regular",
            "Nunito-Medium", 
            "Nunito-SemiBold",
            "Nunito-Bold"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                registerFontFromURL(fontURL, name: fontName)
            } else if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "otf") {
                registerFontFromURL(fontURL, name: fontName)
            } else {
                print("❌ Font file not found: \(fontName).ttf or \(fontName).otf")
                if let resourcePath = Bundle.main.resourcePath {
                    print("📁 Bundle resource path: \(resourcePath)")
                    do {
                        let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                        print("📋 Available resources: \(contents.filter { $0.contains("Nunito") })")
                    } catch {
                        print("❌ Error listing bundle contents: \(error)")
                    }
                }
            }
        }
    }
    
    private func registerFontFromURL(_ fontURL: URL, name: String) {
        guard let fontData = NSData(contentsOf: fontURL) else {
            print("❌ Could not load font data for: \(name)")
            return
        }
        
        guard let provider = CGDataProvider(data: fontData) else {
            print("❌ Could not create data provider for: \(name)")
            return
        }
        
        guard let font = CGFont(provider) else {
            print("❌ Could not create CGFont for: \(name)")
            return
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if success {
            print("✅ Successfully registered font: \(name)")
        } else {
            if let error = error?.takeRetainedValue() {
                print("❌ Failed to register font \(name): \(error)")
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
            for name in UIFont.fontNames(forFamilyName: family) {
                print("  - \(name)")
            }
        }
    }
}
