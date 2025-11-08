import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var showOnboarding = false
    
    var body: some View {
        ZStack {
                if showOnboarding {
                    OnboardingView()
                } else {
                    MainTabView()
                }
            }
        .onAppear {
            let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showOnboarding = !hasSeenOnboarding
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
