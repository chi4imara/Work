import SwiftUI

struct MainTabView: View {
    @StateObject private var purchaseStore = PurchaseStore()
    @State private var selectedTab: TabItem = .purchases
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .purchases:
                        PurchaseListView()
                    case .favorites:
                        FavoritesView()
                    case .statistics:
                        StatisticsView(selectedTab: $selectedTab)
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 10)
            }
        }
        .environmentObject(purchaseStore)
    }
}

#Preview {
    MainTabView()
}
