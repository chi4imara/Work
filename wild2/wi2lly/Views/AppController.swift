import SwiftUI

struct AppController: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            if !hasSeenOnboarding {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        hasSeenOnboarding = true
                    }
                }
            } else {
                MainTabView()
            }
        }
        .onAppear {
            FontManager.shared.registerFonts()
        }
    }
}

#Preview {
    AppController()
}
