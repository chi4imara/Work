import SwiftUI

struct AppRootView: View {
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        Group {
            if !hasSeenOnboarding {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        hasSeenOnboarding = true
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    }
                }
            } else {
                MainContainerView()
            }
        }
        .onAppear {
            FontManager.shared.registerFonts()
        }
    }
}

#Preview {
    AppRootView()
}
