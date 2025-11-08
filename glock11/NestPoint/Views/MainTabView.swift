import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = PlacesViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    NavigationView {
                        HomeView(viewModel: viewModel)
                            .navigationBarHidden(true)
                    }
                case 1:
                    NavigationView {
                        CategoriesView(viewModel: viewModel, selectedTab: $selectedTab)
                            .navigationBarHidden(true)
                    }
                case 2:
                    NavigationView {
                        FavoritesView(viewModel: viewModel)
                            .navigationBarHidden(true)
                    }
                case 3:
                    NavigationView {
                        StatisticsView(viewModel: viewModel)
                            .navigationBarHidden(true)
                    }
                case 4:
                    NavigationView {
                        SettingsView()
                            .navigationBarHidden(true)
                    }
                default:
                    NavigationView {
                        HomeView(viewModel: viewModel)
                            .navigationBarHidden(true)
                    }
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
