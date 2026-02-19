import SwiftUI

struct AppController: View {
    @State private var appState: AppState = .onboarding
    @State private var IsCOn = UserDefaults.standard.bool(forKey: "IsCOn")
    
    var body: some View {
        Group {
            switch IsCOn {
            case false:
                OnboardingView {
                    IsCOn = true
                    UserDefaults.standard.set(true, forKey: "IsCOn")
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState = .main
                    }
                }
            case true:
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

enum AppState {
    case onboarding
    case main
}

#Preview {
    AppController()
}
