import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        ZStack {
          if !appViewModel.hasCompletedOnboarding {
                OnboardingView(appViewModel: appViewModel)
                    .transition(.slide)
            } else {
                MainTabView(appViewModel: appViewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.isShowingSplash)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.hasCompletedOnboarding)
    }
}

struct MainTabView: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            Group {
                switch appViewModel.selectedTab {
                case .plants:
                    PlantsView(plantViewModel: appViewModel.plantViewModel, taskViewModel: appViewModel.taskViewModel)
                case .instructions:
                    InstructionsView(instructionViewModel: appViewModel.instructionViewModel)
                case .favorites:
                    FavoritesView(appViewModel: appViewModel)
                case .calendar:
                    CalendarView(taskViewModel: appViewModel.taskViewModel)
                case .archive:
                    ArchiveView(appViewModel: appViewModel)
                case .settings:
                    SettingsView()
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $appViewModel.selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}



#Preview {
    ContentView()
}
