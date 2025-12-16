import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppStateViewModel()
    
    var body: some View {
        ZStack {
            if appState.isFirstLaunch {
                OnboardingView(appState: appState)
            } else {
                MainAppView()
                    .environmentObject(appState)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.showingSplash)
        .animation(.easeInOut(duration: 0.5), value: appState.isFirstLaunch)
    }
}

struct MainAppView: View {
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            Group {
                switch appState.selectedTab {
                case 0: IdeasView()
                case 1: CalendarView()
                case 2: NotesView()
                case 3: StatisticsView()
                case 4: SettingsView()
                default: EmptyView()
                }
            }
            
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
