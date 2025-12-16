import SwiftUI

struct AppRootView: View {
    @State private var showingSplash = true
    @AppStorage("OnboardingComplete") private var isOnboardingComplete = false
    
    var body: some View {
        ZStack {
           if !isOnboardingComplete {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
            } else {
                MainTabView()
            }
        }
        .onAppear {
            FontManager.shared.registerFonts()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showingSplash = false
                }
            }
        }
    }
}

#Preview {
    AppRootView()
}
