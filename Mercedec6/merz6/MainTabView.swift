import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .recommendations
    @StateObject private var mealPlanViewModel = MealPlanViewModel()
    
    var body: some View {
        ZStack {
            AppGradients.primaryBackground
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .recommendations:
                    RecommendationsView()
                        .environmentObject(mealPlanViewModel)
                case .mealPlan:
                    MealPlanView()
                        .environmentObject(mealPlanViewModel)
                case .progress:
                    ProgressView()
                        .environmentObject(mealPlanViewModel)
                case .profile:
                    ProfileView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                CustomTabBar(
                    selectedTab: $selectedTab,
                    tabs: TabItem.allCases
                )
            }
        }
    }
}

#Preview {
    MainTabView()
}
