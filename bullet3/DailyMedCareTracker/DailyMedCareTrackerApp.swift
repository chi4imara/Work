import SwiftUI
import LibSync

@main
struct DailyMedCareTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showingSplash = true
    @State private var hasCompletedOnboarding = DataManager.shared.hasCompletedOnboarding()
    
    init() {
        FontManager.registerFonts()
        
        printAvailableFonts()
    }
    
    private func printAvailableFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            if familyName.contains("Playfair") {
                print("Found Playfair font family: \(familyName)")
                let fontNames = UIFont.fontNames(forFamilyName: familyName)
                for fontName in fontNames {
                    print("  - \(fontName)")
                }
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashScreen()) {
                ZStack {
                if !hasCompletedOnboarding {
                        OnboardingView {
                            DataManager.shared.setOnboardingCompleted(true)
                            withAnimation(.easeInOut(duration: 0.5)) {
                                hasCompletedOnboarding = true
                            }
                        }
                    } else {
                        MainTabView()
                    }
                }
            }
        }
    }
}
