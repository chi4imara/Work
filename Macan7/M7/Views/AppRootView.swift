import SwiftUI

struct AppRootView: View {
    @StateObject private var viewModel = PhotoshootViewModel()
    @State private var showSplash = true
    @State private var showOnboarding = !AppSettings.hasCompletedOnboarding
    
    var body: some View {
        ZStack {
          if showOnboarding {
                OnboardingView(onComplete: {
                    AppSettings.completeOnboarding()
                    withAnimation(.easeOut(duration: 0.5)) {
                        showOnboarding = false
                    }
                })
                .transition(.slide)
            } else {
                MainTabView()
                    .environmentObject(viewModel)
                    .transition(.opacity)
            }
        }
        .onAppear {
            FontManager.shared.registerFonts()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: showOnboarding)
    }
}

#Preview {
    AppRootView()
}
