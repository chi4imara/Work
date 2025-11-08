import SwiftUI
import UIKit
import CoreText

class FontManager {
    static let shared = FontManager()
    
    private var registeredFonts: [String: UIFont] = [:]
    
    private init() {
        registerFonts()
    }
    
    private func registerFonts() {
        let fontFiles = [
            "Poppins-Light": "Poppins-Light.ttf",
            "Poppins-Regular": "Poppins-Regular.ttf", 
            "Poppins-Medium": "Poppins-Medium.ttf",
            "Poppins-SemiBold": "Poppins-SemiBold.ttf",
            "Poppins-Bold": "Poppins-Bold.ttf"
        ]
        
        for (key, fileName) in fontFiles {
            if let font = loadFontFromBundle(fileName: fileName) {
                registeredFonts[key] = font
            } else {
                registeredFonts[key] = UIFont.systemFont(ofSize: 17)
            }
        }
    }
    
    private func loadFontFromBundle(fileName: String) -> UIFont? {
        guard let fontURL = Bundle.main.url(forResource: fileName.replacingOccurrences(of: ".ttf", with: ""), withExtension: "ttf") else {
            return nil
        }
        
        guard let fontData = NSData(contentsOf: fontURL) else {
            return nil
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            return nil
        }
        
        guard let font = CGFont(dataProvider) else {
            return nil
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            if let error = error {
                print("Font registration error: \(error)")
            }
        }
        
        let fontName = font.postScriptName as String? ?? fileName.replacingOccurrences(of: ".ttf", with: "")
        return UIFont(name: fontName, size: 17)
    }
    
    func getFont(name: String, size: CGFloat) -> Font {
        if let uiFont = registeredFonts[name] {
            return Font(uiFont.withSize(size))
        } else {
            return Font.system(size: size, weight: .regular, design: .rounded)
        }
    }
    
    func getUIFont(name: String, size: CGFloat) -> UIFont {
        if let uiFont = registeredFonts[name] {
            return uiFont.withSize(size)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}

extension Font {
    static func poppinsLight(size: CGFloat) -> Font {
        return FontManager.shared.getFont(name: "Poppins-Light", size: size)
    }
    
    static func poppinsRegular(size: CGFloat) -> Font {
        return FontManager.shared.getFont(name: "Poppins-Regular", size: size)
    }
    
    static func poppinsMedium(size: CGFloat) -> Font {
        return FontManager.shared.getFont(name: "Poppins-Medium", size: size)
    }
    
    static func poppinsSemiBold(size: CGFloat) -> Font {
        return FontManager.shared.getFont(name: "Poppins-SemiBold", size: size)
    }
    
    static func poppinsBold(size: CGFloat) -> Font {
        return FontManager.shared.getFont(name: "Poppins-Bold", size: size)
    }
}
