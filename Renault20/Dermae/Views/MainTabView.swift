import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: SkinCareViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case 0:
                    CarePlanView(viewModel: viewModel)
                case 1:
                    SkinDiaryView(viewModel: viewModel)
                case 2:
                    HistoryView(viewModel: viewModel)
                case 3:
                    StatisticsView(viewModel: viewModel)
                case 4:
                    SettingsView(viewModel: viewModel)
                default:
                    CarePlanView(viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(SkinCareViewModel())
}
