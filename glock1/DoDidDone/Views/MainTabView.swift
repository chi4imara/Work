import SwiftUI

struct MainTabView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView(taskViewModel: taskViewModel)
                    case .categories:
                        CategoriesView(taskViewModel: taskViewModel)
                    case .progress:
                        ProgressView(taskViewModel: taskViewModel)
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}
