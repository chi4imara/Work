import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .journal
    @EnvironmentObject var procedureStore: ProcedureStore
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedTab {
        case .journal:
            JournalView()
        case .categories:
            CategoriesView()
        case .analytics:
            AnalyticsView()
        case .settings:
            SettingsView()
        }
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .environmentObject(procedureStore)
    }
}

#Preview {
    MainTabView()
        .environmentObject(ProcedureStore())
}
