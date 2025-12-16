import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var viewModel = BooksViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        HomeView(selectedTab: $selectedTab)
                    case 1:
                        SearchView()
                    case 2:
                        AddBookView(
                            book: nil,
                            onSave: { title, author, totalPages in
                                viewModel.addBook(title: title, author: author, totalPages: totalPages)
                            },
                            selectedTab: $selectedTab
                        )
                    case 3:
                        StatisticsView(selectedTab: $selectedTab)
                    case 4:
                        SettingsView()
                    default:
                        HomeView(selectedTab: $selectedTab)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainTabView()
}
