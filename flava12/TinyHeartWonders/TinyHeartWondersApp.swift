import SwiftUI
import LibSync

@main
struct TinyHeartWondersApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataManager = DataManager.shared
    @State private var showingSplash = true
    @State private var showingOnboarding = true
    
    var body: some Scene {
        WindowGroup {
            RemoteScreen(loader: SplashView()) {
                Group {
                    if showingOnboarding && !dataManager.isOnboardingComplete {
                        OnboardingView(isOnboardingComplete: $showingOnboarding, dataManager: dataManager) {
                            print("Onboarding completed, updating DataManager")
                            withAnimation(.easeInOut(duration: 0.5)) {
                                dataManager.isOnboardingComplete = true
                                showingOnboarding = false
                            }
                        }
                        .onAppear {
                            registerFonts()
                        }
                        
                    } else {
                        MainTabView()
                            .environmentObject(dataManager)
                            .onAppear {
                                registerFonts()
                            }
                    }
                }
            }
        }
    }
    
    private func registerFonts() {
        let fontNames = [
            "Ubuntu-Light",
            "Ubuntu-Regular", 
            "Ubuntu-Medium",
            "Ubuntu-Bold",
            "Ubuntu-LightItalic",
            "Ubuntu-Italic",
            "Ubuntu-MediumItalic",
            "Ubuntu-BoldItalic"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
            }
        }
    }
}
