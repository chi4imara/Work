import UIKit
import SwiftUI

extension UIFont {
    static func registerFonts() {
        let fontFiles = [
            "BuilderSans-Thin-100.otf",
            "BuilderSans-Light-300.otf", 
            "BuilderSans-Regular-400.otf",
            "BuilderSans-Medium-500.otf",
            "BuilderSans-SemiBold-600.otf",
            "BuilderSans-Bold-700.otf",
            "BuilderSans-ExtraBold-800.otf"
        ]
        
        for fontFile in fontFiles {
            guard let fontURL = Bundle.main.url(forResource: fontFile.replacingOccurrences(of: ".otf", with: ""), withExtension: "otf") else {
                print("Font file not found: \(fontFile)")
                continue
            }
            
            guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
                print("Could not create data provider for font: \(fontFile)")
                continue
            }
            
            guard let font = CGFont(fontDataProvider) else {
                print("Could not create font from data provider: \(fontFile)")
                continue
            }
            
            var error: Unmanaged<CFError>?
            let success = CTFontManagerRegisterGraphicsFont(font, &error)
            
            if !success {
                if let error = error {
                    let errorDescription = CFErrorCopyDescription(error.takeRetainedValue())
                    print("Failed to register font \(fontFile): \(errorDescription ?? "Unknown error" as CFString)")
                } else {
                    print("Font \(fontFile) might already be registered")
                }
            } else {
                print("Successfully registered font: \(fontFile)")
            }
        }
    }
}
