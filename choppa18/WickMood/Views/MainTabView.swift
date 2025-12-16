import SwiftUI

struct MainTabView: View {
    @StateObject private var candleStore = CandleStore()
    @StateObject private var noteStore = NoteStore()
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .home:
                    HomeView(candleStore: candleStore)
                case .categories:
                    CategoriesView(candleStore: candleStore)
                case .notes:
                    NotesView(noteStore: noteStore)
                case .favorites:
                    FavoritesView(candleStore: candleStore)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
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
