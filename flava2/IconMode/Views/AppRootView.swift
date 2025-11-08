import SwiftUI

struct AppRootView: View {
    @State private var isShowingSplash = false
    @State private var showOnboarding = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
           if !hasSeenOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .transition(.move(edge: .trailing))
            } else {
                MainTabView()
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            FontRegistration.registerFonts()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                FontRegistration.listAvailableFonts()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    isShowingSplash = false
                    
                    if !hasSeenOnboarding {
                        showOnboarding = true
                    }
                }
            }
        }
        .onChange(of: showOnboarding) { newValue in
            if !newValue {
                hasSeenOnboarding = true
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isShowingSplash)
        .animation(.easeInOut(duration: 0.5), value: showOnboarding)
    }
}

#Preview {
    AppRootView()
        .environmentObject(VictoryViewModel())
}
