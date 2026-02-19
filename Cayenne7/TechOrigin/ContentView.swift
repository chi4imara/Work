import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DeviceViewModel()
    @State private var selectedTab: TabItem = .devices
    @State private var showingSplash = true
    
    var body: some View {
        ZStack {
            if viewModel.showOnboarding {
                OnboardingView(viewModel: viewModel)
            } else {
                NavigationStack {
                    MainTabView(selectedTab: $selectedTab, viewModel: viewModel)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

struct MainTabView: View {
    @Binding var selectedTab: TabItem
    @ObservedObject var viewModel: DeviceViewModel
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .devices:
                    DevicesView(viewModel: viewModel)
                case .characteristics:
                    CharacteristicsView(viewModel: viewModel)
                case .analytics:
                    AnalyticsView(viewModel: viewModel)
                case .settings:
                    SettingsView()
                }
            }
            .environmentObject(viewModel)
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
}
