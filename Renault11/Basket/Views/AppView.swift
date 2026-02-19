import SwiftUI

struct AppView: View {
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            if showingOnboarding || !hasCompletedOnboarding {
                OnboardingView(showOnboarding: $showingOnboarding)
                    .transition(.slide)
            } else {
                NavigationStack {
                    MainTabView()
                        .transition(.opacity)
                        .navigationBarHidden(true)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showingSplash)
        .animation(.easeInOut(duration: 0.5), value: showingOnboarding)
        .onAppear {            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showingSplash = false
                
                if !hasCompletedOnboarding {
                    showingOnboarding = true
                }
            }
        }
        .onChange(of: showingOnboarding) { newValue in
            if !newValue && !hasCompletedOnboarding {
                hasCompletedOnboarding = true
            }
        }
    }
}

#Preview {
    AppView()
}
