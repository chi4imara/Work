import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: ProcedureViewModel
    @State private var selectedTab: TabItem = .care
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .care:
                    CareView(viewModel: viewModel)
                case .products:
                    ProductsView(viewModel: viewModel)
                case .calendar:
                    CalendarView(viewModel: viewModel)
                case .history:
                    HistoryView(viewModel: viewModel)
                case .settings:
                    SettingsView()
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView(viewModel: ProcedureViewModel())
}
