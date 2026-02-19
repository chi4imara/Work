import SwiftUI

struct AppCoordinator: View {
    @StateObject private var viewModel = ExerciseViewModel()
    @State private var isShowingSplash = true
    @State private var showOnboarding = false
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            if !hasSeenOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            } else {
                MainView()
                    .environmentObject(viewModel)
            }
        }
        .onAppear {            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isShowingSplash = false
                    
                    if !hasSeenOnboarding {
                        showOnboarding = true
                    }
                }
            }
        }
        .onChange(of: showOnboarding) { newValue in
            if !newValue && !hasSeenOnboarding {
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                hasSeenOnboarding = true
            }
        }
    }
}

#Preview {
    AppCoordinator()
}
