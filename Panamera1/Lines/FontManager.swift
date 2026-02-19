import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private var registeredFontNames: [String: String] = [:]
    
    private init() {}
    
    func registerFonts() {
        let fontFiles = [
            "Bell-Gothic_Regular",
            "Bell-Gothic_Bold",
            "Bell-Gothic_Black",
            "Bell-Gothic_Italic",
            "Bell-Gothic_Bold-Italic",
            "Bell-Gothic_Black-Italic"
        ]
        
        for fileName in fontFiles {
            var url: URL?
            
            if let subdirectoryURL = Bundle.main.url(forResource: fileName, withExtension: "ttf", subdirectory: "Bell Gothic Web") {
                url = subdirectoryURL
            } else if let rootURL = Bundle.main.url(forResource: fileName, withExtension: "ttf") {
                url = rootURL
            } else if let path = Bundle.main.path(forResource: fileName, ofType: "ttf", inDirectory: "Bell Gothic Web") {
                url = URL(fileURLWithPath: path)
            }
            
            if let url = url {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                
                if success {
                    if let fontDataProvider = CGDataProvider(url: url as CFURL),
                       let font = CGFont(fontDataProvider) {
                        if let postScriptName = font.postScriptName as String? {
                            registeredFontNames[fileName] = postScriptName
                            print("✓ Registered: \(fileName) -> \(postScriptName)")
                        }
                    }
                } else {
                    if let error = error?.takeRetainedValue() {
                        print("✗ Failed to register \(fileName): \(error)")
                    } else {
                        print("✗ Failed to register: \(fileName)")
                    }
                }
            } else {
                print("✗ Font file not found: \(fileName).ttf (checked Bundle root and 'Bell Gothic Web' subdirectory)")
            }
        }
        
        printFontNames()
    }
    
    private func printFontNames() {
        print("\n=== Available Font Names ===")
        for family in UIFont.familyNames.sorted() {
            if family.contains("Bell") || family.contains("Gothic") {
                print("Family: \(family)")
                for name in UIFont.fontNames(forFamilyName: family) {
                    print("  - \(name)")
                }
            }
        }
        print("===========================\n")
    }
    
    func getFontName(for fileName: String) -> String? {
        return registeredFontNames[fileName]
    }
}

extension Font {
    static func bellGothicRegular(size: CGFloat) -> Font {
        if let registeredName = FontManager.shared.getFontName(for: "Bell-Gothic_Regular") {
            return Font.custom(registeredName, size: size)
        }
        
        let fontNames = [
            "BellGothicStd",
            "Bell Gothic Std",
            "BellGothicStd-Regular",
            "Bell-Gothic_Regular"
        ]
        return findFont(names: fontNames, size: size) ?? .system(size: size)
    }
    
    static func bellGothicBold(size: CGFloat) -> Font {
        if let registeredName = FontManager.shared.getFontName(for: "Bell-Gothic_Bold") {
            return Font.custom(registeredName, size: size)
        }
        
        let fontNames = [
            "BellGothicStd-Bold",
            "Bell Gothic Std Bold",
            "BellGothicStdBold",
            "Bell-Gothic_Bold"
        ]
        return findFont(names: fontNames, size: size) ?? .system(size: size, weight: .bold)
    }
    
    static func bellGothicBlack(size: CGFloat) -> Font {
        if let registeredName = FontManager.shared.getFontName(for: "Bell-Gothic_Black") {
            return Font.custom(registeredName, size: size)
        }
        
        let fontNames = [
            "BellGothicStd-Black",
            "Bell Gothic Std Black",
            "BellGothicStdBlack",
            "Bell-Gothic_Black"
        ]
        return findFont(names: fontNames, size: size) ?? .system(size: size, weight: .black)
    }
    
    static func bellGothicItalic(size: CGFloat) -> Font {
        if let registeredName = FontManager.shared.getFontName(for: "Bell-Gothic_Italic") {
            return Font.custom(registeredName, size: size)
        }
        
        let fontNames = [
            "BellGothicStd-Italic",
            "Bell Gothic Std Italic",
            "BellGothicStdItalic",
            "Bell-Gothic_Italic"
        ]
        return findFont(names: fontNames, size: size) ?? .system(size: size).italic()
    }
    
    private static func findFont(names: [String], size: CGFloat) -> Font? {
        for name in names {
            if UIFont(name: name, size: size) != nil {
                return Font.custom(name, size: size)
            }
        }
        return nil
    }
}
