import SwiftUI

struct ContentView: View {
    @StateObject private var appStateViewModel = AppStateViewModel()
    @StateObject private var wardrobeViewModel = WardrobeViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    
    var body: some View {
        ZStack {
            if !appStateViewModel.hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $appStateViewModel.hasCompletedOnboarding)
            } else {
                MainTabView(
                    selectedTab: $appStateViewModel.selectedTab,
                    wardrobeViewModel: wardrobeViewModel,
                    notesViewModel: notesViewModel
                )
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appStateViewModel.isShowingSplash)
        .animation(.easeInOut(duration: 0.5), value: appStateViewModel.hasCompletedOnboarding)
    }
}

struct MainTabView: View {
    @Binding var selectedTab: Int
    @ObservedObject var wardrobeViewModel: WardrobeViewModel
    @ObservedObject var notesViewModel: NotesViewModel
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    WardrobeView(viewModel: wardrobeViewModel)
                case 1:
                    ShoppingListView(viewModel: wardrobeViewModel)
                case 2:
                    NotesView(viewModel: notesViewModel)
                case 3:
                    StatisticsView(wardrobeViewModel: wardrobeViewModel, notesViewModel: notesViewModel)
                case 4:
                    SettingsView()
                default:
                    WardrobeView(viewModel: wardrobeViewModel)
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
