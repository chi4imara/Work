import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = RepairInstructionViewModel()
    @State private var selectedTab: TabItem = .handbook
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .handbook:
                        HandbookView(viewModel: viewModel)
                    case .categories:
                        CategoriesView(viewModel: viewModel)
                    case .archive:
                        ArchiveView(viewModel: viewModel)
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}

