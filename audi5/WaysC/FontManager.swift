import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private var registeredFontNames: [String: String] = [:]
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            ("Bell-Gothic_Regular", "Bell Gothic Regular"),
            ("Bell-Gothic_Bold", "Bell Gothic Bold"),
            ("Bell-Gothic_Italic", "Bell Gothic Italic"),
            ("Bell-Gothic_Bold-Italic", "Bell Gothic Bold Italic"),
            ("Bell-Gothic_Black", "Bell Gothic Black"),
            ("Bell-Gothic_Black-Italic", "Bell Gothic Black Italic")
        ]
        
        print("=== Font Registration Started ===")
        
        for (fileName, fontName) in fonts {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "ttf", subdirectory: "Bell Gothic Web") {
                print("Found font in subdirectory: \(fileName).ttf")
                registerFont(at: url, fileName: fileName, fontName: fontName)
            } else if let url = Bundle.main.url(forResource: fileName, withExtension: "ttf") {
                print("Found font in root: \(fileName).ttf")
                registerFont(at: url, fileName: fileName, fontName: fontName)
            } else {
                print("⚠️ Font file not found: \(fileName).ttf")
            }
        }
        
        print("=== Registered fonts: \(registeredFontNames) ===")
        
        print("=== Available font families containing 'Bell': ===")
        for family in UIFont.familyNames.sorted() {
            if family.lowercased().contains("bell") {
                print("Family: \(family)")
                for name in UIFont.fontNames(forFamilyName: family) {
                    print("  - \(name)")
                }
            }
        }
    }
    
    private func registerFont(at url: URL, fileName: String, fontName: String) {
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
        
        if success {
            if let fontData = NSData(contentsOf: url),
               let provider = CGDataProvider(data: fontData),
               let font = CGFont(provider) {
                if let postScriptName = font.postScriptName as String? {
                    registeredFontNames[fileName] = postScriptName
                    print("Successfully registered font: \(fileName) -> \(postScriptName)")
                } else {
                    let alternatives = [
                        fontName,
                        fileName.replacingOccurrences(of: "-", with: " "),
                        fileName.replacingOccurrences(of: "_", with: " ")
                    ]
                    
                    for altName in alternatives {
                        if UIFont(name: altName, size: 12) != nil {
                            registeredFontNames[fileName] = altName
                            print("Successfully registered font: \(fileName) -> \(altName)")
                            return
                        }
                    }
                    
                    registeredFontNames[fileName] = fontName
                    print("Registered font: \(fileName) (using default name: \(fontName))")
                }
            } else {
                registeredFontNames[fileName] = fontName
                print("Registered font: \(fileName) (using default name: \(fontName))")
            }
        } else {
            if let error = error?.takeRetainedValue() {
                print("Failed to register font \(fileName): \(error)")
            } else {
                print("Failed to register font: \(fileName)")
            }
        }
    }
    
    func getFontName(for fileName: String) -> String {
        if let registeredName = registeredFontNames[fileName] {
            return registeredName
        }
        
        let alternatives = [
            fileName.replacingOccurrences(of: "-", with: " "),
            fileName.replacingOccurrences(of: "_", with: " "),
            "Bell Gothic Regular",
            "Bell Gothic Bold",
            "Bell Gothic Italic",
            "Bell Gothic Bold Italic",
            "Bell Gothic Black",
            "Bell Gothic Black Italic"
        ]
        
        for altName in alternatives {
            if UIFont(name: altName, size: 12) != nil {
                registeredFontNames[fileName] = altName
                return altName
            }
        }
        
        return fileName
    }
}

extension Font {
    static func bellGothicRegular(size: CGFloat) -> Font {
        let fontName = FontManager.shared.getFontName(for: "Bell-Gothic_Regular")
        if UIFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        }
        return Font.system(size: size, weight: .regular)
    }
    
    static func bellGothicBold(size: CGFloat) -> Font {
        let fontName = FontManager.shared.getFontName(for: "Bell-Gothic_Bold")
        if UIFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        }
        return Font.system(size: size, weight: .bold)
    }
    
    static func bellGothicItalic(size: CGFloat) -> Font {
        let fontName = FontManager.shared.getFontName(for: "Bell-Gothic_Italic")
        if UIFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        }
        return Font.system(size: size, weight: .regular).italic()
    }
    
    static func bellGothicBoldItalic(size: CGFloat) -> Font {
        let fontName = FontManager.shared.getFontName(for: "Bell-Gothic_Bold-Italic")
        if UIFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        }
        return Font.system(size: size, weight: .bold).italic()
    }
    
    static func bellGothicBlack(size: CGFloat) -> Font {
        let fontName = FontManager.shared.getFontName(for: "Bell-Gothic_Black")
        if UIFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        }
        return Font.system(size: size, weight: .black)
    }
}
