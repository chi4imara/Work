import SwiftUI
import UIKit
import CoreText

class FontManager {
    static let shared = FontManager()
    
    private var registeredFontNames: [String: String] = [:]
    
    private init() {
        registerFonts()
        printRegisteredFonts()
    }
    
    private func registerFonts() {
        let fontFileNames = [
            "ITC Bauhaus Bold",
            "ITC Bauhaus Bold Oblique",
            "ITC Bauhaus Demi",
            "ITC Bauhaus Demi Oblique",
            "ITC Bauhaus Heavy",
            "ITC Bauhaus Heavy Oblique",
            "ITC Bauhaus Light",
            "ITC Bauhaus Light Oblique",
            "ITC Bauhaus Medium",
            "ITC Bauhaus Medium Oblique"
        ]
        
        for fontFileName in fontFileNames {
            var fontURL: URL?
            
            let paths = [
                Bundle.main.url(forResource: fontFileName, withExtension: "ttf", subdirectory: "ITC Bauhaus"),
                Bundle.main.url(forResource: fontFileName, withExtension: "ttf"),
                Bundle.main.url(forResource: "ITC Bauhaus/\(fontFileName)", withExtension: "ttf"),
                Bundle.main.path(forResource: fontFileName, ofType: "ttf", inDirectory: "ITC Bauhaus").flatMap { URL(fileURLWithPath: $0) },
                Bundle.main.path(forResource: fontFileName, ofType: "ttf").flatMap { URL(fileURLWithPath: $0) }
            ]
            
            fontURL = paths.compactMap { $0 }.first
            
            guard let url = fontURL else {
                print("⚠️ Could not find font file: \(fontFileName).ttf")
                if let resourcePath = Bundle.main.resourcePath {
                    let fileManager = FileManager.default
                    if let files = try? fileManager.contentsOfDirectory(atPath: resourcePath) {
                        let ttfFiles = files.filter { $0.hasSuffix(".ttf") }
                        print("   Found .ttf files in bundle: \(ttfFiles)")
                    }
                }
                continue
            }
            
            print("📁 Found font file at: \(url.path)")
            
            guard let fontData = NSData(contentsOf: url) else {
                print("⚠️ Could not read font data from: \(fontFileName)")
                continue
            }
            
            guard let fontDataProvider = CGDataProvider(data: fontData),
                  let font = CGFont(fontDataProvider) else {
                print("⚠️ Could not create font from: \(fontFileName)")
                continue
            }
            
            var error: Unmanaged<CFError>?
            let success = CTFontManagerRegisterGraphicsFont(font, &error)
            
            if success {
                if let fontName = font.postScriptName as String? {
                    registeredFontNames[fontFileName] = fontName
                    print("✅ Registered font: \(fontFileName) -> \(fontName)")
                } else {
                    print("⚠️ Registered but could not get PostScript name for: \(fontFileName)")
                }
            } else {
                if let error = error?.takeRetainedValue() {
                    let errorDescription = CFErrorCopyDescription(error) as String?
                    let errorCode = CFErrorGetCode(error)
                    print("❌ Error registering \(fontFileName): \(errorDescription ?? "Unknown error") (code: \(errorCode))")
                    
                    if errorCode == 105 {
                        if let fontName = font.postScriptName as String? {
                            registeredFontNames[fontFileName] = fontName
                            print("   Font already registered, using: \(fontName)")
                        }
                    }
                } else {
                    print("⚠️ Font \(fontFileName) registration failed with unknown error")
                }
            }
        }
    }
    
    private func printRegisteredFonts() {
        print("\n📋 Available fonts in system:")
        var foundBauhaus = false
        for familyName in UIFont.familyNames.sorted() {
            let fonts = UIFont.fontNames(forFamilyName: familyName)
            if fonts.contains(where: { $0.contains("Bauhaus") || $0.contains("bauhaus") }) {
                foundBauhaus = true
                print("  Family: \(familyName)")
                for fontName in fonts {
                    if fontName.contains("Bauhaus") || fontName.contains("bauhaus") {
                        print("    - \(fontName)")
                    }
                }
            }
        }
        if !foundBauhaus {
            print("  ❌ No Bauhaus fonts found in system!")
        }
        print("\n")
    }
    
    func getFontName(for key: String) -> String? {
        return registeredFontNames[key]
    }
    
    func getAllRegisteredFontNames() -> [String: String] {
        return registeredFontNames
    }
}

extension Font {
    private static func safeCustomFont(_ name: String, size: CGFloat, fallback: Font) -> Font {
        if UIFont(name: name, size: size) != nil {
            return Font.custom(name, size: size)
        }
        
        let alternatives = [
            name,
            name.replacingOccurrences(of: "ITC ", with: ""),
            name.replacingOccurrences(of: " ", with: "-"),
            name.replacingOccurrences(of: " ", with: "")
        ]
        
        for altName in alternatives {
            if UIFont(name: altName, size: size) != nil {
                print("✅ Using alternative font name: \(altName)")
                return Font.custom(altName, size: size)
            }
        }
        
        print("⚠️ Font '\(name)' not found, using fallback")
        return fallback
    }
    
    static func bauhausLight(_ size: CGFloat) -> Font {
        let fallback = Font.system(size: size, weight: .light)
        
        if let registeredName = FontManager.shared.getFontName(for: "ITC Bauhaus Light") {
            return safeCustomFont(registeredName, size: size, fallback: fallback)
        }
        
        let namesToTry = [
            "ITC Bauhaus Light",
            "ITC Bauhaus-Light",
            "Bauhaus Light",
            "Bauhaus-Light"
        ]
        
        for name in namesToTry {
            if UIFont(name: name, size: size) != nil {
                return Font.custom(name, size: size)
            }
        }
        
        return fallback
    }
    
    static func bauhausMedium(_ size: CGFloat) -> Font {
        let fallback = Font.system(size: size, weight: .medium)
        
        if let registeredName = FontManager.shared.getFontName(for: "ITC Bauhaus Medium") {
            return safeCustomFont(registeredName, size: size, fallback: fallback)
        }
        
        let namesToTry = [
            "ITC Bauhaus Medium",
            "ITC Bauhaus-Medium",
            "Bauhaus Medium",
            "Bauhaus-Medium"
        ]
        
        for name in namesToTry {
            if UIFont(name: name, size: size) != nil {
                return Font.custom(name, size: size)
            }
        }
        
        return fallback
    }
    
    static func bauhausDemi(_ size: CGFloat) -> Font {
        let fallback = Font.system(size: size, weight: .semibold)
        
        if let registeredName = FontManager.shared.getFontName(for: "ITC Bauhaus Demi") {
            return safeCustomFont(registeredName, size: size, fallback: fallback)
        }
        
        let namesToTry = [
            "ITC Bauhaus Demi",
            "ITC Bauhaus-Demi",
            "Bauhaus Demi",
            "Bauhaus-Demi"
        ]
        
        for name in namesToTry {
            if UIFont(name: name, size: size) != nil {
                return Font.custom(name, size: size)
            }
        }
        
        return fallback
    }
    
    static func bauhausBold(_ size: CGFloat) -> Font {
        let fallback = Font.system(size: size, weight: .bold)
        
        if let registeredName = FontManager.shared.getFontName(for: "ITC Bauhaus Bold") {
            return safeCustomFont(registeredName, size: size, fallback: fallback)
        }
        
        let namesToTry = [
            "ITC Bauhaus Bold",
            "ITC Bauhaus-Bold",
            "Bauhaus Bold",
            "Bauhaus-Bold"
        ]
        
        for name in namesToTry {
            if UIFont(name: name, size: size) != nil {
                return Font.custom(name, size: size)
            }
        }
        
        return fallback
    }
    
    static func bauhausHeavy(_ size: CGFloat) -> Font {
        let fallback = Font.system(size: size, weight: .heavy)
        
        if let registeredName = FontManager.shared.getFontName(for: "ITC Bauhaus Heavy") {
            return safeCustomFont(registeredName, size: size, fallback: fallback)
        }
        
        let namesToTry = [
            "ITC Bauhaus Heavy",
            "ITC Bauhaus-Heavy",
            "Bauhaus Heavy",
            "Bauhaus-Heavy"
        ]
        
        for name in namesToTry {
            if UIFont(name: name, size: size) != nil {
                return Font.custom(name, size: size)
            }
        }
        
        return fallback
    }
}
