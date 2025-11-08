import SwiftUI
import UIKit

class FontManager {
    static let shared = FontManager()
    
    private init() {
        debugBundleContents()
        registerFonts()
    }
    
    private func debugBundleContents() {
        print("=== Bundle Contents Debug ===")
        
        if let resourcePath = Bundle.main.resourcePath {
            print("Resource path: \(resourcePath)")
            
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                print("Root contents: \(contents)")
                
                if contents.contains("Playfair_Display") {
                    let playfairPath = "\(resourcePath)/Playfair_Display"
                    let playfairContents = try FileManager.default.contentsOfDirectory(atPath: playfairPath)
                    print("Playfair_Display contents: \(playfairContents)")
                    
                    if playfairContents.contains("static") {
                        let staticPath = "\(playfairPath)/static"
                        let staticContents = try FileManager.default.contentsOfDirectory(atPath: staticPath)
                        print("Static contents: \(staticContents)")
                    }
                }
            } catch {
                print("Error reading bundle contents: \(error)")
            }
        }
        
        print("=== End Bundle Debug ===")
    }
    
    private func registerFonts() {
        let fontFiles = [
            ("PlayfairDisplay-Regular", "ttf"),
            ("PlayfairDisplay-Italic", "ttf"),
            ("PlayfairDisplay-Bold", "ttf"),
            ("PlayfairDisplay-BoldItalic", "ttf"),
            ("PlayfairDisplay-Black", "ttf"),
            ("PlayfairDisplay-BlackItalic", "ttf"),
            ("PlayfairDisplay-Medium", "ttf"),
            ("PlayfairDisplay-MediumItalic", "ttf"),
            ("PlayfairDisplay-SemiBold", "ttf"),
            ("PlayfairDisplay-SemiBoldItalic", "ttf"),
            ("PlayfairDisplay-ExtraBold", "ttf"),
            ("PlayfairDisplay-ExtraBoldItalic", "ttf"),
            ("PlayfairDisplay-VariableFont_wght", "ttf"),
            ("PlayfairDisplay-Italic-VariableFont_wght", "ttf")
        ]
        
        for (fontName, fontExtension) in fontFiles {
            let paths = [
                nil,
                "Playfair_Display",
                "Playfair_Display/static"
            ]
            
            var registered = false
            for path in paths {
                if registerFont(fontName: fontName, fontExtension: fontExtension, inSubdirectory: path) {
                    registered = true
                    break
                }
            }
            
            if !registered {
                print("Failed to register font: \(fontName).\(fontExtension)")
            }
        }
    }
    
    private func registerFont(fontName: String, fontExtension: String, inSubdirectory subdirectory: String? = nil) -> Bool {
        if let fontURL = Bundle.main.url(forResource: fontName, withExtension: fontExtension, subdirectory: subdirectory) {
            return registerFontFromURL(fontURL, fontName: fontName)
        }
        
        if let fontPath = Bundle.main.path(forResource: fontName, ofType: fontExtension, inDirectory: subdirectory) {
            let fontURL = URL(fileURLWithPath: fontPath)
            return registerFontFromURL(fontURL, fontName: fontName)
        }
        
        return false
    }
    
    private func registerFontFromURL(_ fontURL: URL, fontName: String) -> Bool {
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            print("Could not create data provider for font: \(fontName)")
            return false
        }
        
        guard let font = CGFont(fontDataProvider) else {
            print("Could not create font from data provider: \(fontName)")
            return false
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            if let error = error?.takeRetainedValue() {
                print("Error registering font \(fontName): \(error)")
            } else {
                print("Error registering font \(fontName): Unknown error")
            }
            return false
        } else {
            print("Successfully registered font: \(fontName)")
            return true
        }
    }
}

