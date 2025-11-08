import SwiftUI
import UIKit

#if DEBUG
struct FontDebugger {
    static func printAvailableFonts() {
        print("🔍 Available Font Families:")
        for family in UIFont.familyNames.sorted() {
            print("  📁 \(family)")
            for font in UIFont.fontNames(forFamilyName: family) {
                print("    📄 \(font)")
            }
        }
    }
    
    static func checkNunitoFonts() {
        print("🔍 Checking Nunito Fonts:")
        let nunitoFonts = [
            "Nunito-Regular",
            "Nunito-Medium",
            "Nunito-SemiBold", 
            "Nunito-Bold"
        ]
        
        for fontName in nunitoFonts {
            if UIFont(name: fontName, size: 16) != nil {
                print("  ✅ \(fontName) - Available")
            } else {
                print("  ❌ \(fontName) - Not Found")
            }
        }
    }
    
    static func testFontRendering() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Font Test")
                .font(.appTitle)
            
            Text("Regular Text")
                .font(.bodyText)
            
            Text("Medium Text")
                .font(.buttonText)
            
            Text("SemiBold Text")
                .font(.cardTitle)
            
            Text("Bold Text")
                .font(.screenTitle)
        }
        .padding()
        .onAppear {
            printAvailableFonts()
            checkNunitoFonts()
        }
    }
}
#endif
