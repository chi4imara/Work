import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = ManicureViewModel()
    
    var body: some View {
        TabView {
            DiaryView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Diary")
                }
            
            ColorsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "paintpalette.fill")
                    Text("Colors")
                }
            
            MastersView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Masters")
                }
            
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(ColorManager.yellow)
    }
}

#Preview {
    MainTabView()
}
