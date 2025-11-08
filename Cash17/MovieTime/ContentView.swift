import SwiftUI

struct ContentView: View {
    @State private var isShowingSplash = true
    @State private var isOnboardingComplete = UserDefaults.standard.bool(forKey: "OnboardingComplete")
    @State private var selectedTab: TabItem = .movies
    
    var body: some View {
        ZStack {
            if !isOnboardingComplete {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                    .transition(.slide)
            } else {
                mainAppView
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isShowingSplash = false
                }
            }
        }
        .onChange(of: isOnboardingComplete) { completed in
            if completed {
                UserDefaults.standard.set(true, forKey: "OnboardingComplete")
            }
        }
    }
    
    private var mainAppView: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .movies:
                        MoviesView()
                    case .calendar:
                        CalendarView()
                    case .favorites:
                        FavoritesView()
                    case .wishlist:
                        WishlistView()
                    case .settings:
                        SettingsView()
                    }
                }
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
}
