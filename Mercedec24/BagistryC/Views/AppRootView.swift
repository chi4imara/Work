import SwiftUI

struct AppRootView: View {
    @State private var showingSplash = true
    @State private var hasCompletedOnboarding = UserDefaultsStorage.shared.hasCompletedOnboarding()
    
    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()
            
            if !hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .transition(.opacity)
            } else {
                NavigationStack {
                    GeometryReader { geometry in 
                        MainTabView()
                            .transition(.opacity)
                            .navigationBarHidden(true)
                    }
                }
            }
        }
        .onAppear {            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showingSplash = false
                }
            }
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
    }
}

#Preview {
    AppRootView()
}
