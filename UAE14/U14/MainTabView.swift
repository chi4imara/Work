import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = PullUpViewModel()
    @State private var selectedTab: TabItem = .diary
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            Group {
                switch selectedTab {
                case .diary:
                    DiaryView(viewModel: viewModel)
                case .progress:
                    PullUpProgressView(viewModel: viewModel)
                case .achievements:
                    AchievementsView(viewModel: viewModel)
                case .workouts:
                    WorkoutsView(viewModel: viewModel)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}


#Preview {
    MainTabView()
}
