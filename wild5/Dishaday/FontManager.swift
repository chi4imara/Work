import Foundation
import SwiftUI
import UIKit
import CoreText

class FontManager {
    static let shared = FontManager()
    
    private var registeredFonts: [String: String] = [:]
    
    private init() {
        registerFonts()
    }
    
    private func registerFonts() {
        let fontFiles = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-BlackItalic",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-ExtraBoldItalic"
        ]
        
        for fontFile in fontFiles {
            var fontURL: URL?
            
            fontURL = Bundle.main.url(forResource: fontFile, withExtension: "ttf", subdirectory: "Playfair_Display/static")
            
            if fontURL == nil {
                fontURL = Bundle.main.url(forResource: fontFile, withExtension: "ttf")
            }
            
            if fontURL == nil {
                fontURL = Bundle.main.url(forResource: fontFile, withExtension: "ttf", subdirectory: "Playfair_Display")
            }
            
            guard let url = fontURL else {
                print("⚠️ Font file not found: \(fontFile).ttf")
                continue
            }
            
            registerFontFromURL(url, fontName: fontFile)
        }
        
        if !registeredFonts.isEmpty {
            let fontNames = registeredFonts.values.joined(separator: ", ")
            print("✅ Successfully registered \(registeredFonts.count) fonts: \(fontNames)")
        } else {
            print("⚠️ No fonts were registered. Check font files in bundle.")
        }
    }
    
    private func registerFontFromURL(_ url: URL, fontName: String) {
        guard let fontDataProvider = CGDataProvider(url: url as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("⚠️ Could not create font from URL: \(url.lastPathComponent)")
            return
        }
        
        guard let postScriptName = font.postScriptName as String? else {
            print("⚠️ Could not get PostScript name for: \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        let registrationResult = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if registrationResult {
            registeredFonts[fontName] = postScriptName
            print("✅ Registered font: \(fontName) -> \(postScriptName)")
        } else {
            if let error = error?.takeUnretainedValue() {
                let errorDescription = CFErrorCopyDescription(error) as String?
                if let description = errorDescription, description.contains("duplicate") {
                    registeredFonts[fontName] = postScriptName
                    print("ℹ️ Font already registered: \(fontName) -> \(postScriptName)")
                } else {
                    print("⚠️ Error registering font \(fontName): \(errorDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    func getPostScriptName(for fileName: String) -> String? {
        return registeredFonts[fileName]
    }
    
    func isFontAvailable(_ fontName: String) -> Bool {
        if registeredFonts.values.contains(fontName) {
            return true
        }
        return UIFont(name: fontName, size: 12) != nil
    }
}

extension Font {
    private static func customFont(_ fileName: String, size: CGFloat, fallback: Font) -> Font {
        if let postScriptName = FontManager.shared.getPostScriptName(for: fileName) {
            if FontManager.shared.isFontAvailable(postScriptName) {
                return Font.custom(postScriptName, size: size)
            }
        }
        
        if FontManager.shared.isFontAvailable(fileName) {
            return Font.custom(fileName, size: size)
        }
        
        return fallback
    }
    
    static func playfairTitle(_ size: CGFloat = 28) -> Font {
        return customFont("PlayfairDisplay-Bold", size: size, fallback: .system(size: size, weight: .bold, design: .serif))
    }
    
    static func playfairTitleLarge(_ size: CGFloat = 34) -> Font {
        return customFont("PlayfairDisplay-ExtraBold", size: size, fallback: .system(size: size, weight: .heavy, design: .serif))
    }
    
    static func playfairHeading(_ size: CGFloat = 22) -> Font {
        return customFont("PlayfairDisplay-SemiBold", size: size, fallback: .system(size: size, weight: .semibold, design: .serif))
    }
    
    static func playfairHeadingMedium(_ size: CGFloat = 20) -> Font {
        return customFont("PlayfairDisplay-Medium", size: size, fallback: .system(size: size, weight: .medium, design: .serif))
    }
    
    static func playfairBody(_ size: CGFloat = 16) -> Font {
        return customFont("PlayfairDisplay-Regular", size: size, fallback: .system(size: size, weight: .regular, design: .serif))
    }
    
    static func playfairBodyItalic(_ size: CGFloat = 16) -> Font {
        return customFont("PlayfairDisplay-Italic", size: size, fallback: .system(size: size, weight: .regular, design: .serif).italic())
    }
    
    static func playfairCaption(_ size: CGFloat = 14) -> Font {
        return customFont("PlayfairDisplay-Regular", size: size, fallback: .system(size: size, weight: .regular, design: .serif))
    }
    
    static func playfairCaptionMedium(_ size: CGFloat = 14) -> Font {
        return customFont("PlayfairDisplay-Medium", size: size, fallback: .system(size: size, weight: .medium, design: .serif))
    }
    
    static func playfairSmall(_ size: CGFloat = 12) -> Font {
        return customFont("PlayfairDisplay-Regular", size: size, fallback: .system(size: size, weight: .regular, design: .serif))
    }
}
