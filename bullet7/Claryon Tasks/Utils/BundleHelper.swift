import Foundation

class BundleHelper {
    static let shared = BundleHelper()
    
    private init() {}
    
    func checkFontFiles() {
        print("🔍 Checking font files in bundle...")
        
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
            if let fontURL = Bundle.main.url(forResource: fontFile.replacingOccurrences(of: ".otf", with: ""), withExtension: "otf") {
                print("✅ Found: \(fontFile) at \(fontURL.path)")
            } else {
                print("❌ Missing: \(fontFile)")
            }
        }
    }
    
    func listAllFontFiles() {
        print("📁 All font files in bundle:")
        if let fontDirectory = Bundle.main.url(forResource: "Builder Sans", withExtension: nil) {
            do {
                let fontFiles = try FileManager.default.contentsOfDirectory(at: fontDirectory, includingPropertiesForKeys: nil)
                for file in fontFiles {
                    print("  - \(file.lastPathComponent)")
                }
            } catch {
                print("❌ Error reading font directory: \(error)")
            }
        } else {
            print("❌ Builder Sans directory not found")
        }
    }
}
