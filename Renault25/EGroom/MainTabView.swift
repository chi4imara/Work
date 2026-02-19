import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case 0:
                    TodayView()
                case 1:
                    MyProceduresView()
                case 2:
                    StatisticsView()
                case 3:
                    HistoryView()
                case 4:
                    SettingsView()
                default:
                    TodayView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .environmentObject(viewModel)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
