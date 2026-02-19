import SwiftUI

struct MainTabView: View {
    @StateObject private var appState = AppStateViewModel()
    @StateObject private var viewModel = InventoryViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            InventoryView()
                .tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("Inventory")
                }
                .tag(0)
            
            CategoriesView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Categories")
                }
                .tag(1)
            
            NotesView(viewModel: notesViewModel)
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Notes")
                }
                .tag(2)
            
            StatisticsView(notesViewModel: notesViewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.lightBlue)
        .preferredColorScheme(.dark)
        .environmentObject(viewModel)
    }
}


#Preview {
    MainTabView()
}
