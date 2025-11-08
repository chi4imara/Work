import SwiftUI

struct MainView: View {
    @StateObject private var store = VictoryStore()
    @State private var selectedTabFirst: TabItem = .feed
    @State private var isShowingSidebarFirst = false
    
    var body: some View {
        ZStack {
                switch selectedTabFirst {
                case .feed:
                    FeedView(store: store)
                case .categories:
                    CategoriesView(store: store)
                case .insights:
                    InsightsView(store: store, selectedTab: $selectedTabFirst)
                case .settings:
                    SettingsView()
                }
            
            VStack {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isShowingSidebarFirst = true
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                Spacer()
            }
            
            CustomSideBar(
                selectedTab: $selectedTabFirst,
                isShowingSidebar: $isShowingSidebarFirst
            )
        }
    }
}

#Preview {
    MainView()
}
