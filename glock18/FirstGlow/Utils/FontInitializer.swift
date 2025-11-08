import SwiftUI
import CoreText

struct FontInitializer {
    
    static func initializeFonts() {
        print("🚀 Initializing Builder Sans fonts...")
        
        let fontFiles = [
            "BuilderSans-Thin-100",
            "BuilderSans-Light-300",
            "BuilderSans-Regular-400",
            "BuilderSans-Medium-500",
            "BuilderSans-SemiBold-600",
            "BuilderSans-Bold-700",
            "BuilderSans-ExtraBold-800"
        ]
        
        var successCount = 0
        var failureCount = 0
        
        for fontFile in fontFiles {
            if registerFontFromBundle(fontFile) {
                successCount += 1
            } else {
                failureCount += 1
            }
        }
        
        print("📊 Font registration complete:")
        print("   ✅ Success: \(successCount)")
        print("   ❌ Failed: \(failureCount)")
        
        verifyFontAvailability()
    }
    
    private static func registerFontFromBundle(_ fontName: String) -> Bool {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "otf") else {
            print("❌ Font file not found: \(fontName).otf")
            return false
        }
        
        guard let fontData = NSData(contentsOf: fontURL) else {
            print("❌ Could not load font data: \(fontName)")
            return false
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("❌ Could not create data provider: \(fontName)")
            return false
        }
        
        guard let font = CGFont(dataProvider) else {
            print("❌ Could not create CGFont: \(fontName)")
            return false
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if success {
            print("✅ Registered: \(fontName)")
            return true
        } else {
            if let error = error?.takeRetainedValue() {
                let errorDescription = CFErrorCopyDescription(error)
                print("❌ Registration failed for \(fontName): \(errorDescription ?? "Unknown error" as CFString)")
            } else {
                print("⚠️ \(fontName) might already be registered")
            }
            return false
        }
    }
    
    private static func verifyFontAvailability() {
        print("🔍 Verifying font availability...")
        
        let testCases = [
            ("BuilderSans-Regular-400", "Regular"),
            ("BuilderSans-Bold-700", "Bold"),
            ("BuilderSans-Medium-500", "Medium")
        ]
        
        for (fontName, description) in testCases {
            if UIFont(name: fontName, size: 16) != nil {
                print("✅ \(description) font is available")
            } else {
                print("❌ \(description) font is NOT available")
            }
        }
    }
    
    static func listAvailableFonts() {
        print("📋 Available fonts containing 'Builder':")
        for family in UIFont.familyNames {
            if family.contains("Builder") {
                print("   Family: \(family)")
                for font in UIFont.fontNames(forFamilyName: family) {
                    print("     - \(font)")
                }
            }
        }
    }
}
