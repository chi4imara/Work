import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppStateViewModel()
    
    var body: some View {
        ZStack {
          if appState.isFirstLaunch {
                OnboardingView(appState: appState)
            } else {
                MainTabView(appState: appState)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.showingSplash)
        .animation(.easeInOut(duration: 0.5), value: appState.isFirstLaunch)
    }
}

struct MainTabView: View {
    @ObservedObject var appState: AppStateViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch appState.selectedTab {
                case .ideas:
                    IdeasView()
                case .notes:
                    NotesView()
                case .materials:
                    MaterialsView()
                case .inspiration:
                    InspirationView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
}
