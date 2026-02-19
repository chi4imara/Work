import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = ItemsViewModel()
    @State private var selectedTab = 0
    @State private var showingAddItem = false
    @State private var previousTab = 0
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    MyItemsView(selectedTab: $selectedTab)
                case 1:
                    SearchView()
                case 2:
                    AddItemView(selectedTab: $selectedTab)
                case 3:
                    CategoriesView()
                case 4:
                    SettingsView()
                default:
                    MyItemsView(selectedTab: $selectedTab)
                }
            }
            .environmentObject(viewModel)
            
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
