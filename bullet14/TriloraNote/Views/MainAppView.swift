import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = NoticeViewModel()
    @State private var selectedTab: TabItem = .home
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
           if viewModel.showOnboarding {
                OnboardingView(viewModel: viewModel)
            } else {
                ZStack {
                    Group {
                        switch selectedTab {
                        case .home:
                            HomeView(viewModel: viewModel)
                        case .archive:
                            ArchiveView(viewModel: viewModel)
                        case .quotes:
                            QuotesView()
                        case .dayMap:
                            DayMapView(viewModel: viewModel, selectedTab: $selectedTab)
                        case .settings:
                            SettingsView()
                        }
                    }
                    
                    VStack {
                        Spacer()
                        CustomTabBar(selectedTab: $selectedTab)
                    }
                }
            }
        }
        .onAppear {
            FontManager.registerFonts()
        }
    }
}

#Preview {
    MainAppView()
}
